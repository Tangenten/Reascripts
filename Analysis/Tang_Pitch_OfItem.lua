function round(x)
  if x%2 ~= 0.5 then
    return math.floor(x+0.5)
  end
  return x-0.5
end

function hertzToPitch(hz)
  A4 = 440
  C0 = 16.35
  name = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
  
  h = round(12 * math.log(hz/C0, 2))
  octave = (math.floor(h / 12))
  n = h % 12
  pitchName = name[n+1] .. tostring(octave)
  pitchNumber = (n) + ((octave+1) * 12)
  return pitchName, pitchNumber
end

function GetSourceItemFrequencyAtPosition( take, pos )
  local source = reaper.GetMediaItemTake_Source(take)
  local nch = reaper.GetMediaSourceNumChannels(source)
  local ns = 1
  local buf = reaper.new_array(ns*3*nch)
  local rv = reaper.GetMediaItemTake_Peaks(take,1000.0,pos,nch,ns,115,buf)
  if rv & (1<<24) and (rv&0xfffff) > 0 then
    local spl = buf[nch*ns*2 + 1]
    return tonumber(string.format("%d",spl&0x7fff))
   end 
end

item = reaper.GetSelectedMediaItem(0,0)
if item then
  take = reaper.GetActiveTake(item,0)
  
  if take and not reaper.TakeIsMIDI(take) then
    --pos = reaper.GetCursorPosition()
    
    itemPos = reaper.GetMediaItemInfo_Value( item, "D_POSITION" )
    itemLength = reaper.GetMediaItemInfo_Value( item,"D_LENGTH" )
    
    pos = itemPos + (itemLength / 4)
    
    freq = GetSourceItemFrequencyAtPosition( take, pos )
    pitchName, pitchNumber = hertzToPitch(freq)
    reaper.ShowMessageBox(string.format("Hertz: %d, Note: %s, MidiNumber: %s",freq,pitchName,pitchNumber), "Data", 0 )
  end
 end 
 


