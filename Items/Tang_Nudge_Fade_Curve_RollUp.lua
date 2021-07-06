reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

a, b, c = reaper.BR_GetMouseCursorContext()

item = reaper.BR_GetMouseCursorContext_Item()
sel_Item = reaper.GetSelectedMediaItem(0,0)
sel_Item_Pos = reaper.GetMediaItemInfo_Value( sel_Item, "D_POSITION")
sel_Item_Length = reaper.GetMediaItemInfo_Value( sel_Item, "D_LENGTH")

if reaper.BR_GetMouseCursorContext_Position() < (sel_Item_Pos + (sel_Item_Length / 2)) then
old_Fade_Left = reaper.GetMediaItemInfo_Value( sel_Item, "D_FADEINDIR")
reaper.SetMediaItemInfo_Value( sel_Item, "D_FADEINDIR", old_Fade_Left - 0.05)
--if old_Fade_Left < -0.9 then
--reaper.SetMediaItemInfo_Value( sel_Item, "D_FADEINDIR",1)
--end
else
old_Fade_Right = reaper.GetMediaItemInfo_Value( sel_Item, "D_FADEOUTDIR")
reaper.SetMediaItemInfo_Value( sel_Item, "D_FADEOUTDIR", old_Fade_Right + 0.05)
--if old_Fade_Right > 0.9 then
--reaper.SetMediaItemInfo_Value( sel_Item, "D_FADEOUTDIR",-1)
--end
end


reaper.TrackList_AdjustWindows(false)
reaper.UpdateTimeline()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)

reaper.Undo_BeginBlock("Envelope FX Take", -1)
