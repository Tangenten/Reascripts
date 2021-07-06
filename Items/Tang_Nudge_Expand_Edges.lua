reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

sel_Item = reaper.GetSelectedMediaItem(0,0)
old_Pos = reaper.GetMediaItemInfo_Value( sel_Item, "D_POSITION")
old_Length = reaper.GetMediaItemInfo_Value( sel_Item, "D_LENGTH")
reaper.BR_SetItemEdges( sel_Item, old_Pos-0.15, old_Pos+old_Length+0.15)
--reaper.SetMediaItemInfo_Value( sel_Item, "D_POSITION", old_Pos +  0.015)

reaper.TrackList_AdjustWindows(false)
reaper.UpdateTimeline()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)

reaper.Undo_BeginBlock("Envelope FX Take", -1)
