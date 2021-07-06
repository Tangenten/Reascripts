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
  reaper.Main_OnCommandEx(  reaper.NamedCommandLookup( "_RS53d4d4f877116bdf643b7a5d3a3b99b009894e8f" ), 1, 0 )
  reaper.Main_OnCommandEx( 1008, 1, 0 )
  reaper.Main_OnCommandEx( 40020, 1, 0 )
  reaper.Main_OnCommandEx( 41588, 1, 0 )
  reaper.Main_OnCommandEx( 40640, 1, 0 )
  reaper.Undo_BeginBlock("Transient Quick FX", -1)
  end
  ---------------------------------------------------LOOP
  function loop()
  x,y = reaper.GetMousePosition()
  diffX = (x0-x)*0.01
  diffY = (y0-y)*0.01
  aDiff = orignalvalueX * (1-diffX)
  bDiff = originalvalueY * (1+diffY)
  
  
  reaper.TakeFX_SetParam( sel_Take, count_Fx-1, paramPosX, orignalvalueX * (1-diffX) )
  reaper.TakeFX_SetParam( sel_Take, count_Fx-1, paramPosY, originalvalueY * (1+diffY) )
  
  
  reaper.defer( loop )
  end
  ---------------------------------------------------INIT
reaper.Undo_BeginBlock()
x0, y0 = reaper.GetMousePosition()
param_NameX = {"Cutoff"}
param_NameY = {"Gain"}
fx_Name = "Neutron 2 Transient Shaper (iZotope, Inc.)"
sel_Item = reaper.GetSelectedMediaItem(0,0)
sel_Take = reaper.GetActiveTake(sel_Item)
reaper.TakeFX_AddByName(sel_Take, fx_Name, -1)
count_Fx = reaper.TakeFX_GetCount(sel_Take)
num_Param = reaper.TakeFX_GetNumParams(sel_Take, count_Fx-1)

for j = 0, 2 do 
for i = 0, num_Param do

retval, name_Iter = reaper.TakeFX_GetParamName(sel_Take, count_Fx-1, i, "")
if name_Iter == "TS B1 Attack" then
paramPosX = i
orignalvalueX, minvalX, maxvalX, midvalX = reaper.TakeFX_GetParamEx( sel_Take, count_Fx-1, i )
end
if name_Iter == "TS B1 Sustain" then
paramPosY = i
originalvalueY, minvalY, maxvalY, midvalY = reaper.TakeFX_GetParamEx( sel_Take, count_Fx-1, i )
end
end
end

  ---------------------------------------------------START
  reaper.Main_OnCommandEx( 40290, 1, 0 )
  reaper.Main_OnCommandEx( 1007, 1, 0 )
  reaper.Main_OnCommandEx(  reaper.NamedCommandLookup( "_RS53d4d4f877116bdf643b7a5d3a3b99b009894e8f" ), 1, 0 )
loop()
reaper.atexit(onExit)




