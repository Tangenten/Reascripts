


--[[
   * ReaScript Name: Toggle stretch selected items positions  
   * Lua script for Cockos REAPER
   * Author: MPL
   * Author URI: http://forum.cockos.com/member.php?u=70694
   * Licence: GPL v3
   * Version: 1.0
  ]]

  
  ----------------------------------------------


  ---------------------------------------------------ON EXIT
  function onExit()
  end
  ---------------------------------------------------LOOP
  function loop()
  x,y = reaper.GetMousePosition()
  diffX = (1-(x0-x)*0.01)
  diffY = 1 + (y0-y)*0.01
  aDiff = 716 * (1-diffX)
  bDiff = envPosition * (1+diffY)
  
  retval, mousePosition = reaper.BR_ItemAtMouseCursor()
  envPosition = mousePosition - itemPosition
  
  reaper.SetEnvelopePoint( env, envPoint, envPosition, 716 * diffY, 0, 1, 0, 0 )
    
  reaper.UpdateItemInProject( item )
  reaper.defer( loop )
  end
  ---------------------------------------------------INIT
reaper.Undo_BeginBlock()
x0, y0 = reaper.GetMousePosition()

item, mousePosition = reaper.BR_ItemAtMouseCursor()


if item ~= nil then

reaper.Main_OnCommand(reaper.NamedCommandLookup( "_S&M_TAKEENV1" ), 1 )
itemPosition = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
take = reaper.GetActiveTake(item)
env = reaper.GetTakeEnvelopeByName(take, "Volume")

envPosition = mousePosition - itemPosition



brEnv = reaper.BR_EnvAlloc(env, 0 )

active, visible, armed, inLane, laneHeight, defaultShape, minValue, maxValue, centerValue, types, faderScaling = reaper.BR_EnvGetProperties(brEnv)
reaper.BR_EnvSetProperties(brEnv, 1, 0, armed, inLane, laneHeight, defaultShape, 1 )



--envPoint = reaper.BR_EnvFind( brEnv, mousePosition, 100 )
reaper.BR_EnvFree( brEnv, 1 )
--if envPoint == -1 then
reaper.InsertEnvelopePoint(env, envPosition, 716, 0, 1, 0, 0 )
envPoint = reaper.GetEnvelopePointByTime( env, envPosition )
--end

  ---------------------------------------------------START

loop()
end
reaper.atexit(onExit)




