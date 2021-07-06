reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

--reaper.Main_OnCommandEx(40716, 1, 0 )
editor = reaper.MIDIEditor_GetActive()
--reaper.MIDIEditor_OnCommand(editor, 40905 )
reaper.MIDIEditor_LastFocused_OnCommand( reaper.NamedCommandLookup("_43084d8160e54c48968c29d8758a0701"), 0 )

reaper.PreventUIRefresh(-1)
reaper.Undo_BeginBlock("Inline Duplicate", -1)
