reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

sel_Item = reaper.GetSelectedMediaItem(0,0)
old_Fade = reaper.GetMediaItemInfo_Value( sel_Item, "D_FADEOUTDIR")
reaper.SetMediaItemInfo_Value( sel_Item, "D_FADEOUTDIR", old_Fade +  0.05)

reaper.TrackList_AdjustWindows(false)
reaper.UpdateTimeline()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)

reaper.Undo_BeginBlock("Envelope FX Take", -1)
