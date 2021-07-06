reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

reaper.ApplyNudge(0, 0, 4, 1, -0.15, 1, 0)

reaper.TrackList_AdjustWindows(false)
reaper.UpdateTimeline()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)

reaper.Undo_BeginBlock("Envelope FX Take", -1)
