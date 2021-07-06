reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

--reaper.Main_OnCommandEx(40716, 1, 0 )
--editor = reaper.MIDIEditor_GetActive()
--reaper.MIDIEditor_OnCommand(editor, 40906 )
reaper.MIDIEditor_LastFocused_OnCommand(  reaper.NamedCommandLookup( "_S&M_ME_PIANO_CYCLACTION1" ), 0 )

reaper.PreventUIRefresh(-1)
reaper.Undo_BeginBlock("Inline Duplicate", -1)
