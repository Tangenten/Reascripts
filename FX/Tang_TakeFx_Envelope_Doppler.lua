reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)


param_Name = {"source"}
nr_of_Param = #param_Name
fx_Name = "Cabbage Vsts/Doppler"
sel_Item = reaper.GetSelectedMediaItem(0,0)
sel_Take = reaper.GetActiveTake(sel_Item)
reaper.TakeFX_AddByName(sel_Take, fx_Name, -1)

count_Fx = reaper.TakeFX_GetCount(sel_Take)
num_Param = reaper.TakeFX_GetNumParams(sel_Take, count_Fx-1)

for j = 0, nr_of_Param do 
for i = 0, num_Param do

retval, name_Iter = reaper.TakeFX_GetParamName(sel_Take, count_Fx-1, i, "")
if name_Iter == param_Name[j] then
reaper.TakeFX_GetEnvelope(sel_Take, count_Fx-1, i, true)
break
end
end
end


reaper.TrackList_AdjustWindows(false)
reaper.UpdateTimeline()
reaper.UpdateArrange()
reaper.PreventUIRefresh(-1)

reaper.Undo_BeginBlock("Envelope FX Take", -1)
