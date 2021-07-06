take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
retval,notes,cc,sysex = reaper.MIDI_CountEvts(take)
fng_tk = reaper.FNG_AllocMidiTake( take )
notes = reaper.FNG_CountMidiNotes(fng_tk)
reaper.ShowMessageBox(notes,"ok",0)

for i = 0, notes do
reaper.MIDIEditor_OnCommand( reaper.MIDIEditor_GetActive(), 40752 )
reaper.Main_OnCommandEx(42082,1,0 )
reaper.MIDIEditor_OnCommand(reaper.MIDIEditor_GetActive(),reaper.NamedCommandLookup("_59058ab5fe74514babf81850ca759a99"))
end


