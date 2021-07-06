-- @version 1.01
-- @author MPL
-- @website http://forum.cockos.com/member.php?u=70694
-- @description Insert 1 measure long automation item for last touched parameter
-- @changelog
--    # support track volume and pan envelopes
  poolId = 1
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
    if startTime == 0 and endTime == 0 then
    
    for i = 0,count-1 do
    item = GetSelectedMediaItem( 0, i )
    itemPos = GetMediaItemInfo_Value( item, 'D_POSITION')
    itemLength = GetMediaItemInfo_Value( item, 'D_LENGTH')
    itemStartTime = itemPos
    itemEndTime = itemPos + itemLength
    
    if i == 0 then
    InsertAutomationItem( env, -1, startTime, itemLength ) 
    else
    InsertAutomationItem( env, poolId, startTime, itemLength )
    end
    end
    else
    InsertAutomationItem( env, poolId, startTime, endTime ) 
    end
    
    ai_cnt =  reaper.CountAutomationItems( env )
    
    if startTime == 0 and endTime == 00 then
    
    for i = 0, ai_cnt do
    itemPos = GetMediaItemInfo_Value( item, 'D_POSITION')
    itemLength = GetMediaItemInfo_Value( item, 'D_LENGTH')
    itemStartTime = itemPos
    itemEndTime = itemPos + itemLength
    
    autoPos = GetSetAutomationItemInfo( env, i, "D_POSITION", 0, 0 )
    autoLength = GetSetAutomationItemInfo( env, i, "D_LENGTH", 0, 0 )
    
    if autoPos == itemStartTime and (autoPos+autoLength) == itemEndTime then
    reaper.GetSetAutomationItemInfo( env, i, "D_PLAYRATE", autoLength / itemLength, 1 )
    reaper.GetSetAutomationItemInfo( env, i, "D_LENGTH", itemLength, 1 )
    end
    end
    
    else
    
    for i = 0, ai_cnt do
    autoPos = GetSetAutomationItemInfo( env, i, "D_POSITION", 0, 0 )
    autoLength = GetSetAutomationItemInfo( env, i, "D_LENGTH", 0, 0 )
    
    if autoPos == startTime and (autoPos+autoLength) == endPos then
    reaper.GetSetAutomationItemInfo( env, i, "D_PLAYRATE", autoLength / itemLength, 1 )
    reaper.GetSetAutomationItemInfo( env, i, "D_LENGTH", itemLength, 1 )
    end
    end
    
    end
    
    TrackList_AdjustWindows( false )
    UpdateArrange()    
  end
  ----------------------------------------------------------------------------------------------------
  last_act =  Undo_CanUndo2( 0 )
  env = GetLastTouchedEnv(last_act)   
  InsertAI(env)
