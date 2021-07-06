count = reaper.CountSelectedMediaItems(0)

if count ~= 0 then
keyItem = reaper.GetSelectedMediaItem(0, 0)
keyPosition = reaper.GetMediaItemInfo_Value(keyItem,"D_POSITION")

for i = 0, count-1  do
item1 = reaper.GetSelectedMediaItem(0, i)
pos1 = reaper.GetMediaItemInfo_Value(item1,"D_POSITION")
if pos1 <= keyPosition then
keyItem = item1
keyPosition = pos1
end
end

alphaItem = keyItem
alphaPosition = keyPosition
alphaLength = reaper.GetMediaItemInfo_Value(alphaItem,"D_LENGTH")
alphaOfset = alphaPosition

reaper.SetMediaItemInfo_Value(alphaItem,"D_POSITION", alphaOfset - alphaLength)
itemArray={}
for i = 0, count-1 do
itemArray[i] = reaper.GetSelectedMediaItem(0, i)
end

for i = 0, count-1 do
item = reaper.GetSelectedMediaItem(0, i)
position = reaper.GetMediaItemInfo_Value(itemArray[i],"D_POSITION")
length = reaper.GetMediaItemInfo_Value(itemArray[i],"D_LENGTH")

if itemArray[i] ~= alphaItem then
reaper.SetMediaItemInfo_Value(itemArray[i],"D_POSITION", alphaOfset - (position - alphaOfset) - length)
end
end
end

reaper.Main_OnCommandEx( 41051, 1, 0 )
reaper.UpdateArrange()
