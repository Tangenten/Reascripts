reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

reaper.Main_OnCommand(40290,0)

reaper.Main_OnCommand(reaper.NamedCommandLookup("_RSf5a6e5063d8f79a477e73a183032cac347f28da5"),0)

reaper.Main_OnCommand(reaper.NamedCommandLookup("_RS2c5787802969afac1fda0f7015bfe3e57ef3ae64"),0)

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_SELALLPARENTS"),0)

reaper.Main_OnCommand(reaper.NamedCommandLookup("_SWS_AWRENDERSTEREOSMART"),0)

sel_Track = reaper.GetSelectedTrack( 0, 0 )

local retval, track_name = reaper.GetSetMediaTrackInfo_String(sel_Track, "P_NAME", "", true)

reaper.Main_OnCommand(reaper.NamedCommandLookup("_RS090a607010ce2ffcaab03c03b3dfebfe4b92be4e"),0)

reaper.Main_OnCommand(40005,0)

reaper.Main_OnCommand(40020,0)

reaper.UpdateTimeline()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)

reaper.Undo_BeginBlock("Render Items", -1)
