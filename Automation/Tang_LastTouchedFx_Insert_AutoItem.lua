-- @version 1.01
-- @author MPL
-- @website http://forum.cockos.com/member.php?u=70694
-- @description Insert 1 measure long automation item for last touched parameter
-- @changelog
--    # support track volume and pan envelopes

  local script_title = 'Insert 1 measure long automation item for last touched parameter'
  for key in pairs(reaper) do _G[key]=reaper[key]  end 
  ----------------------------------------------------------------------------------------------------
  function GetLastTouchedEnv(act_str)
    if not act_str then return str end
    if act_str == 'Adjust track volume' then
      local tr = GetLastTouchedTrack()
      SetOnlyTrackSelected( tr ) -- for perform setting env visible
      Main_OnCommand(40052,0)--Track: Toggle track volume envelope active
      return GetTrackEnvelopeByName( tr, 'Volume' )
     elseif act_str == 'Adjust track pan' then
      local tr = GetLastTouchedTrack()
      SetOnlyTrackSelected( tr ) -- for perform setting env visible
      Main_OnCommand(40053,0)--Track: Toggle track volume envelope active
      return GetTrackEnvelopeByName( tr, 'Pan' )   
     else
      local retval, tracknum, fxnum, paramnum = GetLastTouchedFX()
      if not retval then return end    
      local track =  CSurf_TrackFromID( tracknum, false )
      if not track then return end
      return GetFXEnvelope( track, fxnum, paramnum, true )       
    end
  end
  ----------------------------------------------------------------------------------------------------
  function InsertAI(env) 
    if not env then return end
    count = reaper.CountSelectedMediaItems( 0 )
    startTime, endTime = GetSet_LoopTimeRange2( 0, 0, 0, 0, 0, 0 )
    if startTime == 0 and endTime == 00 then
    for i = 0,count-1 do
    item = GetSelectedMediaItem( 0, i )
    itemPos = GetMediaItemInfo_Value( item, 'D_POSITION')
    itemLength = GetMediaItemInfo_Value( item, 'D_LENGTH')
    startTime = itemPos
    endTime = itemPos + itemLength
    InsertAutomationItem( env, -1, startTime, itemLength ) 
    end
    else
    InsertAutomationItem( env, -1, startTime, endTime-startTime )   
    end
    
    TrackList_AdjustWindows( false )
    UpdateArrange()    
  end
  ----------------------------------------------------------------------------------------------------
  last_act =  Undo_CanUndo2( 0 )
  env = GetLastTouchedEnv(last_act)   
  InsertAI(env)
