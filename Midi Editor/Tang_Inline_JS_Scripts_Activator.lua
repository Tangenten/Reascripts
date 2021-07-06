reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

--reaper.Main_OnCommandEx(40716, 1, 0 )
--editor = reaper.MIDIEditor_GetActive()
--reaper.MIDIEditor_OnCommand(editor, 40902 )
reaper.MIDIEditor_LastFocused_OnCommand( reaper.NamedCommandLookup("_RS7d3c_ac4ebae118f6903abf344247ba6df88fdb5f10e1"), 0 )
reaper.MIDIEditor_LastFocused_OnCommand( reaper.NamedCommandLookup("_RS7d3c_6a3b55c19fb0f7694e237dbdd82cb075f2ba9c78"), 0 )

reaper.PreventUIRefresh(-1)
reaper.Undo_BeginBlock("Inline Duplicate", -1)
