function UESetupFillParameters(handles,DataFile)

% Initialize file menu

set(handles.savepara_submenu,'enable','off');

% Initialize datafile edit
if isempty(DataFile.FileName)
    set(handles.loaddata_pushbutton,'enable','off');
    set(handles.datafile_edit,'enable','inactive');
    set(handles.datafile_edit,'string','   Select "Import Data" in File Menu');
else
    set(handles.loaddata_pushbutton,'enable','on');
    set(handles.datafile_edit,'enable','on');
    set(handles.datafile_edit,'string',[DataFile.FileName '.gdf']);
end

% Initialize outfilename edit and saveresultmode checkbox
fullname = [DataFile.OutPath DataFile.OutFileName];
if ~isempty(fullname)
    set(handles.outfilename_edit,'enable','on');
    set(handles.outfilename_edit,'string',fullname);
else
    set(handles.outfilename_edit,'enable','inactive');
    set(handles.outfilename_edit,'string','   Select "Choose Results File" in File Menu');
end
switch DataFile.SaveResult.Mode
  case 'off'
    set(handles.saveresultmode_checkbox,'value',0);
  case 'on'
    set(handles.saveresultmode_checkbox,'value',1); 
end

% Initialize parameter file edit
set(handles.parameter_edit,'string','');
set(handles.parameter_edit,'visible','off');

% Initialize allevents listbox
set(handles.allevents_listbox,'string',DataFile.ListofallEvents);
if isempty(DataFile.ListofallEvents)
    set(handles.addneuron_pushbutton,'enable','off');
    set(handles.addevent_pushbutton,'enable','off');
else 
    set(handles.addneuron_pushbutton,'enable','on');
    set(handles.addevent_pushbutton,'enable','on');
end

% Initialize neuronlist listbox
set(handles.neuronlist_listbox,'string',DataFile.NeuronList);
if isempty(DataFile.NeuronList)
    set(handles.removeneuron_pushbutton,'enable','off');
else    
    set(handles.removeneuron_pushbutton,'enable','on');
end

% Initialize eventlist listbox
set(handles.eventlist_listbox,'string',DataFile.EventList);
if isempty(DataFile.EventList)
    set(handles.removeevent_pushbutton,'enable','off');
else    
    set(handles.removeevent_pushbutton,'enable','on');
end

% Initialize cutevent listbox and cutevent edit

set(handles.cutevent_popupmenu,'string',DataFile.ListofallEvents);
if ~isempty(DataFile.ListofallEvents)
    set(handles.cutevent_popupmenu,'enable','on');
else
    set(handles.cutevent_popupmenu,'enable','off');
end
set(handles.cutevent_edit,'string',DataFile.CutEvent);
set(handles.cutevent_edit,'enable','inactive');

% Initialize cut times
set(handles.tpre_edit,'string',DataFile.TPre);
set(handles.tpost_edit,'string',DataFile.TPost);
set(handles.timeunits_edit,'string',DataFile.TimeUnits);

% Initialze analysis parameters
set(handles.alpha_edit,'string',DataFile.Analysis.Alpha);
set(handles.complexity_edit,'string',DataFile.Analysis.Complexity);
set(handles.complexity_max,'string',DataFile.Analysis.ComplexityMax);
set(handles.binsize_edit,'string',DataFile.Analysis.Binsize);
set(handles.tslid_edit,'string',DataFile.Analysis.TSlid);
set(handles.windowshift_edit,'string',DataFile.Analysis.WindowShift);
set(handles.uemethod_popupmenu,'string',char('trialaverage','trialbytrial','csr'));
if isempty(DataFile.Analysis.UEMethod)
    set(handles.uemethod_popupmenu,'value',1);
else switch DataFile.Analysis.UEMethod
      case 'trialaverage'
         set(handles.uemethod_popupmenu,'value',1);
      case 'trialbytrial'
         set(handles.uemethod_popupmenu,'value',2);
      case 'csr'
         set(handles.uemethod_popupmenu,'value',3);
     end
end
set(handles.wildcard_popupmenu,'string',char('off','on'));
if isempty(DataFile.Analysis.Wildcard)
    set(handles.wildcard_popupmenu,'value',1);
else switch DataFile.Analysis.Wildcard
      case 'off'
          set(handles.wildcard_popupmenu,'value',1);
      case 'on'
          set(handles.wildcard_popupmenu,'value',2);
      end
end