timeSelIn,timeSelOut = reaper.GetSet_LoopTimeRange2(0,false,true,0,0,false)
env =  reaper.GetSelectedEnvelope( 0 )
reaper.SetEditCurPos( timeSelIn, 0, 0 )
reaper.Main_OnCommandEx( 40058, 1, 0 )

aItems = reaper.CountAutomationItems( env )

for i = 0, aItems do
position = reaper.GetSetAutomationItemInfo( env, i, "D_POSITION", 0, 0 )
if position == timeSelIn then
length1 = (timeSelOut - timeSelIn)
length2 = reaper.GetSetAutomationItemInfo( env, i, "D_LENGTH", 0, 0 )
reaper.GetSetAutomationItemInfo( env, i, "D_PLAYRATE", length2 / length1  , 1 )
reaper.GetSetAutomationItemInfo( env, i, "D_LENGTH", length1  , 1 )
end
end

reaper.UpdateArrange()
reaper.UpdateTimeline()
