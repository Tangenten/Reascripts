count = reaper.CountSelectedMediaItems( 0 )
selItem = {}
for i = 0, count-1 do
selItem[i] = reaper.GetSelectedMediaItem(0, i )
end

for i = 0, count-1 do

itemPosition = reaper.GetMediaItemInfo_Value( selItem[i], "D_POSITION" )
itemLength = reaper.GetMediaItemInfo_Value( selItem[i], "D_LENGTH" )

reaper.GetSet_LoopTimeRange2( 0, 1, 1, itemPosition, itemPosition + itemLength, 0 )

id = reaper.NamedCommandLookup("_RS1754a2d67176493b221124504259f7eeedc684de")
reaper.Main_OnCommandEx(id,1,0)
reaper.Main_OnCommandEx(40020,1,0)


end

