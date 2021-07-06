window, segment, details = reaper.BR_GetMouseCursorContext()
envelope, takeEnvelope = reaper.BR_GetMouseCursorContext_Envelope()
position = reaper.BR_GetMouseCursorContext_Position()

reaper.InsertEnvelopePoint( envelope, position - 1, 0.5, 5, -0.25, 0, 0 )
reaper.InsertEnvelopePoint( envelope, position,     0.5, 5, 0.25, 1, 0 )
reaper.InsertEnvelopePoint( envelope, position + 1, 0.5, 0, 0, 0, 0 )
