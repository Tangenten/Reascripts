first_Track =  reaper.GetSelectedTrack( 0, 0 )

reaper.Main_OnCommandEx( 40001, 0, 0 )

second_Track = reaper.GetSelectedTrack( 0, 0 )

reaper.CreateTrackSend(first_Track,second_Track )
