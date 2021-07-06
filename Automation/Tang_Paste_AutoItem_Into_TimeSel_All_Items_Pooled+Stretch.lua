reaper = reaper
done = false
reaper.Main_OnCommandEx( 42197, 1, 0 )
--reaper.Main_OnCommandEx(reaper.NamedCommandLookup( "_RSf5a6e5063d8f79a477e73a183032cac347f28da5" ), 1, 0 )
timeStart, timeEnd = reaper.GetSet_LoopTimeRange( false, false, 0, 0, false )
sel_env = reaper.GetSelectedEnvelope( 0 )
track_cnt = reaper.CountSelectedTracks( 0 )
-- proceed if time selection exists and there is a selected envelope
if sel_env and timeStart ~= timeEnd then
  sel_env_track = reaper.Envelope_GetParentTrack( sel_env )
  _, env_name = reaper.GetEnvelopeName( sel_env, "" )
  ai_cnt =  reaper.CountAutomationItems( sel_env )
  local pool_id
  for i = 0, ai_cnt-1 do
    pos = reaper.GetSetAutomationItemInfo( sel_env, i, "D_POSITION" , 0, false )
    if pos == timeStart then
      pool_id = reaper.GetSetAutomationItemInfo( sel_env, i, "D_POOL_ID" , 0, false )
    break
    end
  end
  
  count = reaper.CountSelectedMediaItems( 0 )
  selItem = {}
  for i = 0, count-1 do
  selItem[i] = reaper.GetSelectedMediaItem(0, i )
  end
  
  for i = 0, count-1 do
  local track = reaper.GetSelectedTrack( 0, 0 )
    env = reaper.GetTrackEnvelopeByName( track, env_name )
    autoLength = reaper.GetSetAutomationItemInfo( sel_env, i, "D_LENGTH" , 0, false )
    if env then
  itemPosition = reaper.GetMediaItemInfo_Value( selItem[i], "D_POSITION" )
  itemLength = reaper.GetMediaItemInfo_Value( selItem[i], "D_LENGTH" )
  reaper.GetSet_LoopTimeRange2( 0, 1, 1, itemPosition, itemPosition + itemLength, 0 )
  reaper.InsertAutomationItem( env, pool_id, itemPosition, autoLength )

  done = true
  end
  end
  
  sel_env = reaper.GetSelectedEnvelope( 0 )
  ai_cnt =  reaper.CountAutomationItems(sel_env)
  for i = 0,  reaper.CountSelectedMediaItems(0)-1 do
  for j = 0, ai_cnt-1 do
  itemPosition = reaper.GetMediaItemInfo_Value( selItem[i], "D_POSITION" )
  itemLength = reaper.GetMediaItemInfo_Value( selItem[i], "D_LENGTH" )
  pos = reaper.GetSetAutomationItemInfo( sel_env, j, "D_POSITION" , 0, false )
  if pos == itemPosition then
  reaper.GetSetAutomationItemInfo( sel_env, j, "D_PLAYRATE", autoLength / itemLength, 1 )
  reaper.GetSetAutomationItemInfo( sel_env, j, "D_LENGTH", itemLength, 1 )
  break
  end
  end
  end
  
end
reaper.UpdateArrange()

--reaper.GetSet_LoopTimeRange( true, false, 0, 0, false )
reaper.Main_OnCommandEx( 40020, 1, 0 )
reaper.Undo_OnStateChangeEx2( 0, "Insert pooled instances of one automation item for selected tracks", 1|8 , -1 )

