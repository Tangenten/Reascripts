reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

--reaper.Main_OnCommandEx(40716, 1, 0 )
editor = reaper.MIDIEditor_GetActive()
reaper.MIDIEditor_OnCommand(editor, 40902 )
--reaper.MIDIEditor_LastFocused_OnCommand( reaper.NamedCommandLookup("_RS7d3c_c04ad31787b312b1fabd7630de759a634f2984e7"), 0 )

reaper.PreventUIRefresh(-1)
reaper.Undo_BeginBlock("Inline Duplicate", -1)
