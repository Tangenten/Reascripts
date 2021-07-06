reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

reaper.MIDIEditor_LastFocused_OnCommand(  reaper.NamedCommandLookup( "_FNG_ME_SHOW_USED_CC_LANES" ), 0 )

reaper.PreventUIRefresh(-1)
reaper.Undo_BeginBlock("Inline Show Only Used Lanes", -1)
