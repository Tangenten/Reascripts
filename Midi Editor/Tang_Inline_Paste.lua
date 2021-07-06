--reaper.Undo_BeginBlock()
--reaper.PreventUIRefresh(1)

--editor = reaper.MIDIEditor_GetActive()
--reaper.MIDIEditor_OnCommand(editor, 40502)
reaper.Main_OnCommand(40434, 1 )
reaper.MIDIEditor_LastFocused_OnCommand(40011, 0 )

--reaper.PreventUIRefresh(-1)
--reaper.Undo_BeginBlock("Inline Paste", -1)
