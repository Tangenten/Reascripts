local reaper = reaper
local done = false
reaper.Main_OnCommandEx( 42197, 1, 0 )
local timeStart, timeEnd = reaper.GetSet_LoopTimeRange( false, false, 0, 0, false )
local sel_env = reaper.GetSelectedEnvelope( 0 )
local track_cnt = reaper.CountSelectedTracks( 0 )
-- proceed if time selection exists and there is a selected envelope
if sel_env and timeStart ~= timeEnd then
  local sel_env_track = reaper.Envelope_GetParentTrack( sel_env )
  local _, env_name = reaper.GetEnvelopeName( sel_env, "" )
  local ai_cnt =  reaper.CountAutomationItems( sel_env )
  local pool_id
  for i = 0, ai_cnt-1 do
    local pos = reaper.GetSetAutomationItemInfo( sel_env, i, "D_POSITION" , 0, false )
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
    local env = reaper.GetTrackEnvelopeByName( track, env_name )
    if env then
  itemPosition = reaper.GetMediaItemInfo_Value( selItem[i], "D_POSITION" )
  itemLength = reaper.GetMediaItemInfo_Value( selItem[i], "D_LENGTH" )
  reaper.GetSet_LoopTimeRange2( 0, 1, 1, itemPosition, itemPosition + itemLength, 0 )
  reaper.InsertAutomationItem( env, pool_id, itemPosition, itemLength )
  done = true
  end
  end
  
end
reaper.UpdateArrange()
if done then
reaper.GetSet_LoopTimeRange( true, false, 0, 0, false )
reaper.Main_OnCommandEx( 40020, 1, 0 )
reaper.Undo_OnStateChangeEx2( 0, "Insert pooled instances of one automation item for selected tracks", 1|8 , -1 )
end
