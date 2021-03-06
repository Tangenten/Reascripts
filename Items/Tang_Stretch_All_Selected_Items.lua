--[[
* ReaScript Name: Toggle stretch selected items positions
* Lua script for Cockos REAPER
* Author: MPL
* Author URI: http://forum.cockos.com/member.php?u=70694
* Licence: GPL v3
* Version: 1.0
]]
_, _, sec, cmd = reaper.get_action_context()
state = reaper.GetToggleCommandStateEx(sec, cmd)

----------------------------------------------
function SetButtonON()
  reaper.SetToggleCommandState(sec, cmd, 1)
  -- Set ON
  reaper.RefreshToolbar2(sec, cmd)
end

----------------------------------------------
function SetButtonOFF()
  reaper.SetToggleCommandState(sec, cmd, 0)
  -- Set OFF
  reaper.RefreshToolbar2(sec, cmd)
end

----------------------------------------------
function GetItems()
  local t = {}
  local count_sel_items = reaper.CountSelectedMediaItems(0)
  min_pos = math.huge
  for i = 1, count_sel_items do
    local item = reaper.GetSelectedMediaItem(0, i - 1)
    min_pos = math.min(min_pos, reaper.GetMediaItemInfo_Value(item, "D_POSITION"))
  end
  for i = 1, count_sel_items do
    local item = reaper.GetSelectedMediaItem(0, i - 1)
    t[#t + 1] = {
      ["guid"] = reaper.BR_GetMediaItemGUID(item),
      ["pos"] = reaper.GetMediaItemInfo_Value(item, "D_POSITION"),
      ["length"] = reaper.GetMediaItemInfo_Value(item, "D_LENGTH"),
      ["playrate"] = reaper.GetMediaItemTakeInfo_Value(reaper.GetActiveTake(item), "D_PLAYRATE")
    }
  end
  return t, count_sel_items
end

----------------------------------------------
function StretchItemPositions(t)
  if t == nil or #t == 0 then
    return
  end
  for i = 1, #t do
    min_pos = math.min(min_pos, t[i].pos)
  end
  for i = 1, #t do
    item = reaper.BR_GetMediaItemByGUID(0, t[i].guid)
    if item ~= nil and diff < 1 then
      if toggle == 0 then
        reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_RSd9f8a8ee7377ca1386d23482b0af5ba443e71616"), 1, 0)
        toggle = 1
      end
      reaper.SetMediaItemInfo_Value(item, "D_POSITION", min_pos + (t[i].pos - min_pos) * (1 - diff))
      reaper.SetMediaItemInfo_Value(item, "D_LENGTH", t[i].length * (1 - diff))
      reaper.SetMediaItemTakeInfo_Value(reaper.GetActiveTake(item), "D_PLAYRATE", t[i].playrate / (1 - diff))
    end
    if item ~= nil and diff > 1 then
      if toggle == 1 then
        reaper.Main_OnCommandEx(reaper.NamedCommandLookup("_RSd9f8a8ee7377ca1386d23482b0af5ba443e71616"), 1, 0)
        toggle = 0
      end

      reaper.SetMediaItemInfo_Value(
        item,
        "D_POSITION",
        min_pos + (t[i].pos - min_pos) * (1 - diff) - (t[i].length * (-(1 - diff)))
      )
      reaper.SetMediaItemInfo_Value(item, "D_LENGTH", t[i].length * (-(1 - diff)))
      reaper.SetMediaItemTakeInfo_Value(reaper.GetActiveTake(item), "D_PLAYRATE", t[i].playrate / (-(1 - diff)))
    end
  end
end

----------------------------------------------
function run()
  if x0 == nil then
    x0 = reaper.GetMousePosition()
  end
  x = reaper.GetMousePosition()
  diff = (x0 - x) * 0.01
  defer_sel_items = reaper.CountSelectedMediaItems(0)
  SetButtonON()
  if last_defer_sel_items == nil then
    last_defer_sel_items = defer_sel_items
  end
  if last_defer_sel_items ~= defer_sel_items then
    t0, count_sel_items0 = nil, nil
    reaper.atexit(SetButtonOFF)
  else
    StretchItemPositions(t0)
    reaper.defer(run)
  end
  last_defer_sel_items = reaper.CountSelectedMediaItems(0)
end

----------------------------------------------
if state == 0 then
  reaper.Undo_BeginBlock()
  x0 = reaper.GetMousePosition()
  t0, count_sel_items0 = GetItems()
  toggle = 1
  run()
else
  t0, count_sel_items0 = nil, nil
  reaper.Undo_BeginBlock("Render Items", -1)
  reaper.atexit(SetButtonOFF)
end
