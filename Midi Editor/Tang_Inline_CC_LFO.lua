reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

--reaper.Main_OnCommandEx(40716, 1, 0 )
editor = reaper.MIDIEditor_GetActive()
--reaper.MIDIEditor_OnCommand(editor, 40902 )
reaper.MIDIEditor_LastFocused_OnCommand( reaper.NamedCommandLookup("_RS7d3c_6d0dbfd00ea9b324f5eeec96b49f2c29ee9b880f"), 0 )

reaper.PreventUIRefresh(-1)
reaper.Undo_BeginBlock("Inline Duplicate", -1)
