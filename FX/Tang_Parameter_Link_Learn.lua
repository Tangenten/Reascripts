  --  INIT -------------------------------------------------  
  local vrs = 1.0
  local global_font_size = 15
  local global_font_name = 'Arial'
  debug = 0
  local mouse = {}
  local gui -- see GUI_define()
  local obj = {blit_offs = 0}
  L = {success = 0}
   conf = {}
  local cycle = 0
  local redraw = 1
  local SCC, lastSCC, SCC_trig,drag_mode,last_drag_mode
  for key in pairs(reaper) do _G[key]=reaper[key]  end 
  --local data
  b_offs = 0
  --------------------------------------------------- 
  function Action_CheckLink()
    L.check_exists_dest = false
    if L.destpar and L.destfx then 
      for i =1, #data do
        if L.destfx == data[i].slave_fx_id and L.destpar == data[i].slave_param_num then 
          check_exists = true
          L.check_exists_dest = true
          break
        end
      end
    end
    if (L.tracknumber and L.desttracknumber and L.tracknumber == L.desttracknumber) and
     (L.destfx and L.srcfx and L.destpar and L.srcpar and not
      (L.srcfx == L.destfx and L.srcpar == L.destpar) ) and
     not L.check_exists_dest then 
      L.success = 1      
     else
      L.success = 0
    end
  end
  --------------------------------------------------- 
    function Action_CreateLink()
      if not L  then reaper.MB( 'Missed source and destination parameters (get it from last touched parameter first)', 'Error', 0 ) return end
      if not L.destfx  then reaper.MB( 'Missed destination parameter (get it from last touched parameter first)', 'Error', 0 ) return end
      if not L.srcfx  then reaper.MB( 'Missed source parameter (get it from last touched parameter first)', 'Error', 0 ) return end
      if L.tracknumber 
        and L.desttracknumber
        and L.tracknumber ~= L.desttracknumber then reaper.MB( 'REAPER support parameter linking only beetween same track', 'Error', 0 ) return end
      if L.check_exists_dest then reaper.MB( 'Modulation for destination parameter already exists', 'Error', 0 ) return end
      
      
      local tr = reaper.CSurf_TrackFromID( L.tracknumber, false )
      
  local insert_chunk = 
  [[
  <PROGRAMENV ]]..L.destpar..[[ 0
  PARAMBASE 0
  LFO 0
  LFOWT 1 1
  AUDIOCTL 0
  AUDIOCTLWT 1 1
  PLINK 1 ]]..L.srcfx..':'..L.srcfx-L.destfx..'  '..L.srcpar..[[ 0
      >
      ]]  
        local _, chunk = reaper.GetTrackStateChunk(  tr, '', false )
        local dest_fxGUID = reaper.TrackFX_GetFXGUID( tr, L.destfx):gsub('-','')
        local t= {} for line in chunk:gmatch('[^\n\r]+') do t[#t+1] = line end
        for i = 1, #t do  local line = t[i]  if line:gsub('-',''):match(dest_fxGUID) then fxguid_chunkpos = i break end end
        if fxguid_chunkpos then table.insert(t, fxguid_chunkpos+1, insert_chunk) end
        local out_chunk = table.concat(t, '\n')
        reaper.SetTrackStateChunk(  tr, out_chunk, true )
        reaper.ClearConsole()
        --reaper.ShowConsoleMsg(out_chunk)]]
    
    end  
  ---------------------------------------------------  
  function Action_CreateLink_TakeSrc()          
    local ret, tracknumber, fxnumber, paramnumber = reaper.GetLastTouchedFX() 
    if not ret then return end
    local tr = CSurf_TrackFromID( tracknumber, false )
    GetTrInfo( tr)
    if not ret then return end 
    L.srcfx = fxnumber
    L.srcpar = paramnumber
    L.tracknumber = tracknumber
    --obj.get_PM_src.txt = 'SRC: '..({reaper.TrackFX_GetFXName( tr, fxnumber, '' )})[2]..' / '..({TrackFX_GetParamName( tr, fxnumber, paramnumber, '' )})[2]
    
  end   
  ---------------------------------------------------
  function Action_CreateLink_TakeDest()
    local ret, tracknumber, fxnumber, paramnumber = reaper.GetLastTouchedFX() 
    if not ret then return end
    local tr = CSurf_TrackFromID( tracknumber, false )
    GetTrInfo( tr)
    if not ret then return end 
    L.destfx = fxnumber
    L.destpar = paramnumber
    L.desttracknumber = tracknumber
    --obj.get_PM_dest.txt = 'DEST: '..({reaper.TrackFX_GetFXName( tr, fxnumber, '' )})[2]..' / '..({TrackFX_GetParamName( tr, fxnumber, paramnumber, '' )})[2]
  end
  --------------------------------------------------- 
  local function GetFxNamebyGUID(guid, fx_names)
    for key in pairs(fx_names) do
      if guid:match(key) then return fx_names[key] end
    end
  end
  ---------------------------------------------------
  function GetTrInfo(tr0)
    data = {}
    local tr 
    if not tr0 then tr = GetSelectedTrack(0,0) else tr = tr0 end
    if not tr then return end
    -- name
      data.tr_name =  ({GetTrackName( tr, '' )})[2]
    -- fx names
      local fx_names = {}
      for fx =1,  TrackFX_GetCount( tr ) do
        local guid = TrackFX_GetFXGUID( tr, fx-1 ):gsub('-',''):match('{.-}')
        guid = guid:gsub('[{}]','')
        fx_names[guid] = {id = fx-1,
                          name = ({reaper.TrackFX_GetFXName( tr, fx-1, '' )})[2]}
      end
    
    -- chunk stuff
      local _, chunk = GetTrackStateChunk(  tr, '', false )
      local t= {} for line in chunk:gmatch('[^\n\r]+') do t[#t+1] = line end
      local collect_chunk = false
      local look_FXGUID = nil
      for i = 1, #t do 
        local line = t[i]
        if line:match('FXID') then look_FXGUID = line:gsub('-',''):match('{.-}') end
        if line:match('PROGRAMENV') then collect_chunk = '' end
        if collect_chunk and look_FXGUID then collect_chunk = collect_chunk..'\n'..line end
        if collect_chunk  and line:match('>') then 
          look_FXGUID = look_FXGUID:gsub('[{}]','')
          local fx_gett = GetFxNamebyGUID(look_FXGUID, fx_names)
          local fx_name =fx_gett.name
          local fx_id = fx_gett.id
          local param_num = tonumber(collect_chunk:match('[%d]+'))
          local param_name =  ({TrackFX_GetParamName( tr, fx_id, param_num, '' )})[2]
          
          local lfo_str = collect_chunk:match('LFO %d')
          if lfo_str and lfo_str:match('1') then lfo_str = 'LFO: Enabled' else lfo_str = 'LFO: Disabled' end
          
          local aud_str = collect_chunk:match('AUDIOCTL %d')
          if aud_str and aud_str:match('1') then aud_str = 'AudioControl: Enabled' else aud_str = 'AudioControl: Disabled' end
          
          local plink_str = collect_chunk:match('PLINK .-[\n]')
          local pm_offs,pm_scale,pm_par,pm_fx, pm_fx_name,pm_par_name ='','','','','',''
          if plink_str then 
            local t2 = {}
            for num in plink_str:gmatch('[%d%p]+') do t2[#t2+1]  = num end
            pm_offs = '         Link: offset '..math.floor(t2[1]*100)..'%\n'
            pm_scale = '         Link: scale '..math.floor(t2[4]*100)..'%\n'
            pm_par = tonumber(t2[3])
            pm_fx = tonumber(t2[2]:match('[%d]+'))
            pm_par_name = '         SourceParam: '..({TrackFX_GetParamName( tr, pm_fx, pm_par, '' )})[2]..'\n'
            pm_fx_name = ({reaper.TrackFX_GetFXName( tr,pm_fx, '' )})[2]
            if fx_id == pm_fx then pm_fx_name = pm_fx_name..' (self)' end
            pm_fx_name = '         SourceFX: '..pm_fx_name..'\n'
          end
          data[#data+1] = {ch = collect_chunk ,
                           slave_fx_name =fx_name,
                           slave_fx_id=fx_id,
                           slave_param_num = param_num,
                           slave_param_name=param_name,
                           lfo_str=lfo_str,
                           aud_str=aud_str,
                           plink_str=plink_str,
                           pm_offs = pm_offs,
                           pm_scale = pm_scale,
                           pm_par_name = pm_par_name,
                           pm_fx_name = pm_fx_name}
          
          
          collect_chunk = nil 
          --look_FXGUID = nil
        end
      end
    --msg(chunk)
    
  end
  ---------------------------------------------------
  function onExit()
  Action_CreateLink_TakeSrc() 
  Action_CheckLink()
  Action_CreateLink()
  GetTrInfo()
  end
  ---------------------------------------------------
  function main()
  reaper.defer( main )
  end
  ---------------------------------------------------
  GetTrInfo()
  Action_CreateLink_TakeDest()
  Action_CheckLink()
  main()
  reaper.atexit(onExit)
