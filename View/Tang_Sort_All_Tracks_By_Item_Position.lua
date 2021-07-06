reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

count_track = reaper.CountTracks(0)

if count_track > 0 then

for k = 0, count_track-2 do
for i = 0, count_track-2 do

track1 =  reaper.GetTrack( 0, i )
track2 =  reaper.GetTrack( 0, i+1 )

item1 =  reaper.GetTrackMediaItem( track1, 0 )
item2 =  reaper.GetTrackMediaItem( track2, 0 )

item_pos1 =  reaper.GetMediaItemInfo_Value( item1, "D_POSITION" )
item_pos2 =  reaper.GetMediaItemInfo_Value( item2, "D_POSITION" )

if item_pos1 > item_pos2 then 

retval, track_chunk1 = reaper.GetTrackStateChunk(track1, "", false)
retval, track_chunk2 = reaper.GetTrackStateChunk(track2, "", false)
retval = reaper.SetTrackStateChunk(track1, track_chunk2, false)
retval = reaper.SetTrackStateChunk(track2, track_chunk1, false)

elseif item_pos1 == item_pos2 then

item_length1 = reaper.GetMediaItemInfo_Value( item1, "D_LENGTH" )
item_length2 = reaper.GetMediaItemInfo_Value( item2, "D_LENGTH" )

if item_length1 > item_length2 then

retval, track_chunk1 = reaper.GetTrackStateChunk(track1, "", false)
retval, track_chunk2 = reaper.GetTrackStateChunk(track2, "", false)
retval = reaper.SetTrackStateChunk(track1, track_chunk2, false)
retval = reaper.SetTrackStateChunk(track2, track_chunk1, false)

end
end
end
end
end


reaper.TrackList_AdjustWindows(false)
reaper.UpdateTimeline()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)

reaper.Undo_BeginBlock("Sort all tracks by Item Pos and Length", -1)
