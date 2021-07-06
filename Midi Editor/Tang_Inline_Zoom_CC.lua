reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

--reaper.Main_OnCommandEx(40716, 1, 0 )
editor = reaper.MIDIEditor_GetActive()
--reaper.MIDIEditor_OnCommand(editor, 40902 )
reaper.MIDIEditor_LastFocused_OnCommand( reaper.NamedCommandLookup("_BR_ME_TOGGLE_HIDE_ALL_NO_LAST_CLICKED_250_PX"), 0 )

reaper.PreventUIRefresh(-1)
reaper.Undo_BeginBlock("Inline Duplicate", -1)
