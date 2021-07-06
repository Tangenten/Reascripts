timeSelIn,timeSelOut = reaper.GetSet_LoopTimeRange2(0,false,true,0,0,false)
index = reaper.InsertAutomationItem( reaper.GetSelectedTrackEnvelope(0), 1, timeSelIn, reaper.GetSetAutomationItemInfo( reaper.GetSelectedTrackEnvelope(0), 0, "D_LENGTH", value, 0 ) )
reaper.CountAutomationItems( reaper.GetSelectedTrackEnvelope(0) )
reaper.GetSetAutomationItemInfo( reaper.GetSelectedTrackEnvelope(0), index, "D_PLAYRATE", (timeSelOut-timeSelIn)/length2, 1 )
