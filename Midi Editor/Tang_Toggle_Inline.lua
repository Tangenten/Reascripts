reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

item = reaper.GetSelectedMediaItem( 0, 0 )
take = reaper.GetMediaItemTake( item, 0 )
inlineState = reaper.BR_IsMidiOpenInInlineEditor( take )

if inlineState == true then
reaper.Main_OnCommandEx(reaper.NamedCommandLookup( "_468fb4354f47df459f9f3e7c94a130ac" ), 1, 0 )
elseif inlineState == false then
reaper.Main_OnCommandEx(reaper.NamedCommandLookup( "_56619704099d7d48a13135e8e1feedce" ), 1, 0 )
end

reaper.UpdateTimeline()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)

reaper.Undo_BeginBlock("Inline Toggle", -1)
