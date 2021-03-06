  -- Adjust volume envelope point at mouse cursor via mousewheel 
-- Lua script by SPK77 31-Aug-2015
--
-- Version: 0.2015.9.2
-- Changelog: 2-Sep-2015
--   added support for all track envelopes

-------------------
-- User settings --
-------------------
-- Adjustment behavior
local adj_sel_env = false   -- true:  envelope has to be selected


-- Volume envelope step size
-- (User configurable "dB_steps": see "set_envelope_point" -function)

-- Pan envelope step size
local pan_env_step = 0.01 -- 200 steps (-1 to 1)

-- Width envelope step size
local width_env_step = 0.01 -- 200 steps (-1 to 1)

-- Mute envelope step size
local mute_env_step = 1 -- 2 steps (0 to 1)

----------------------------------------------------------------------



local dB_step = 0.2

local max = math.max
local abs = math.abs
local exp = math.exp
local log = math.log

local dbg = true

function msg(m)
  if dbg then
    reaper.ShowConsoleMsg(tostring(m) .. "\n")
  end
end

-- Justin's functions ----------------------------------------
function VAL2DB(x)
  if x < 0.0000000298023223876953125 then 
    x = -150
  else
    x = max(-150, log(x)* 8.6858896380650365530225783783321)
  end
  return x
end

function DB2VAL(x)
  return exp(x*0.11512925464970228420089957273422)
end
--------------------------------------------------------------

-- Set new value for an envelope point
function set_envelope_point(env_prop_table, m_wheel_delta)
  local e = env_prop_table
  local env = e.pointer
  --msg(env)
  if env == nil then
    return
  end
  local min_val = e.min_val
  local max_val = e.max_val

  local br_env = reaper.BR_EnvAlloc(env, true)
  local pos = reaper.BR_PositionAtMouseCursor(false)
  local p_index = reaper.BR_EnvFind(br_env, pos, 10)
  local get_point_ret, position, value, shape, selected, bezier = reaper.BR_EnvGetPoint(br_env, p_index)
  reaper.BR_EnvFree(br_env, false)
  
  if e.is_fader_scaling then
    value = reaper.ScaleToEnvelopeMode(1, value)
  end
  
  pos_step = 0.2
  if m_wheel_delta < -1 then 
   pos_step = -0.2
  end
  position = position + pos_step
  
  reaper.SetEnvelopePoint(env, p_index, position, nil, nil, nil, nil, true)
  reaper.UpdateArrange()
  reaper.Undo_OnStateChangeEx("Adjust volume envelope point", -1, -1)
end


-- Returns "envelope properties" table 
function get_env_properties(env)
   envelope = {}
  if env ~= nil then
    --local env_name = ({reaper.GetEnvelopeName(env, "")})[2]
    local br_env = reaper.BR_EnvAlloc(env, true)
    local active, visible, armed, in_lane, lane_height, default_shape, 
          min_val, max_val, center_val, env_type, is_fader_scaling
          = reaper.BR_EnvGetProperties(br_env, false, false, false, false, 0, 0, 0, 0, 0, 0, false)        
    reaper.BR_EnvFree(br_env, false)
    
    local env_name = ({reaper.GetEnvelopeName(env, "")})[2]
    if env_name == "Volume" or env_name == "Volume (Pre-FX)" then
      max_val = reaper.SNM_GetIntConfigVar("volenvrange", -1)
      if max_val ~= -1 then
        if max_val == 1 then 
          max_val = 1.0
        elseif max_val == 0 then 
          max_val = 2.0
        elseif max_val == 4 then 
          max_val = 4.0
        else 
          max_val = 16.0
        end
      end 
    end
    
    --[[
    if is_fader_scaling then
      max_val    = reaper.ScaleToEnvelopeMode(1, max_val)
      center_val = reaper.ScaleToEnvelopeMode(1, center_val)
      min_val    = reaper.ScaleToEnvelopeMode(1, min_val)
    end
    --]]
    
    -- Store values to "envelope" table
    envelope.pointer = env
    envelope.active = active
    envelope.visible = visible
    envelope.armed = armed
    envelope.in_lane = in_lane
    envelope.lane_height = lane_height
    envelope.default_shape = default_shape
    envelope.min_val = min_val
    envelope.max_val = max_val
    envelope.center_val = center_val
    envelope.is_fader_scaling = is_fader_scaling
    envelope.type = env_type
    envelope.name = env_name
    envelope.is_tempo = env_type == 9
  end
  return envelope
  
end 


----------
-- Main --
----------
function main()
  local m_wheel_delta = ({reaper.get_action_context()})[7]
  if m_wheel_delta == -1 then 
    return
  end 
  local windowOut, segment, details = reaper.BR_GetMouseCursorContext()
  local env
  if adj_sel_env then
    env = reaper.GetSelectedEnvelope(0)
  else
    env, is_take_env = reaper.BR_GetMouseCursorContext_Envelope()
  end
  if env == nil then -- or is_take_env then
    return
  end
  --local env_name = ({reaper.GetEnvelopeName(env, "")})[2]
  --if env_name == "Volume" or env_name == "Volume (Pre-FX)" then  
    env_properties = get_env_properties(env)
    set_envelope_point(env_properties, m_wheel_delta)
  --end
end

reaper.defer(main)

