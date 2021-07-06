reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

a, b, c = reaper.BR_GetMouseCursorContext()

item = reaper.BR_GetMouseCursorContext_Item()
sel_Item = reaper.GetSelectedMediaItem(0,0)
sel_Item_Pos = reaper.GetMediaItemInfo_Value( sel_Item, "D_POSITION")
sel_Item_Length = reaper.GetMediaItemInfo_Value( sel_Item, "D_LENGTH")

if reaper.BR_GetMouseCursorContext_Position() < (sel_Item_Pos + (sel_Item_Length / 2)) then
old_Left_Fade = reaper.GetMediaItemInfo_Value( sel_Item, "D_FADEINLEN")
reaper.SetMediaItemInfo_Value( sel_Item, "D_FADEINLEN", old_Left_Fade +  0.05)
else
old_Right_Fade = reaper.GetMediaItemInfo_Value( sel_Item, "D_FADEOUTLEN")
reaper.SetMediaItemInfo_Value( sel_Item, "D_FADEOUTLEN", old_Right_Fade -  0.05)
end

reaper.TrackList_AdjustWindows(false)
reaper.UpdateTimeline()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)

reaper.Undo_BeginBlock("Envelope FX Take", -1)
