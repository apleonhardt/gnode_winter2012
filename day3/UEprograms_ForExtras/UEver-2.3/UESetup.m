function varargout = UESetup(varargin)
% UESETUP Application M-file for UESetup.fig
%    FIG = UESETUP launch UESetup GUI.
%    UESETUP('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 24-Sep-2002 14:43:08

if nargin == 0  % LAUNCH GUI

	warning off;
    fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    
    % These variables are used in addition to the handles structure.
    % Only those variables, that are passed between funtioncs are mentioned.
    % All other variables are privat in those functions, where they are used.
    
    % DataFile structure
    
    % Fill Figure with default parameters
    
    DataFile = [];
    load UEParameters_Default.mat; % returns DataFile structure
    if ~isempty(DataFile)
       handles.DataFile = DataFile;
       guidata(fig,handles);
       UESetupFillParameters(handles,handles.DataFile);
       information('Select data or paramter file in File menu.');
       drawnow;
    else
       information('Could not load valid DataFile structure from UEParameters_Default.mat.');
       drawnow;
    end
    clear DataFile;

	if nargout > 0
		varargout{1} = fig;
	end
    
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end
end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.



% --------------------------------------------------------------------
function varargout = datafile_edit_Callback(h, eventdata, handles, varargin)

 % remove .gdf from filename and store filename in DataFile 
 fullfilename = get(handles.datafile_edit,'string');
 position = findstr('.gdf',fullfilename);

 if ~isempty(position)
    handles.DataFile.FileName = fullfilename(1:(position-1));
 else
    handles.DataFile.FileName = fullfilename
 end
 
 guidata(h,handles);
 set(handles.loaddata_pushbutton,'enable','on');
 information(['To open the selected data file click "Load selected Data File". '...
              'The list of all events in the file will then be displayed in ' ...
              'the corresponding listbox.']);
 drawnow;
     
% --------------------------------------------------------------------
function varargout = outfilename_edit_Callback(h, eventdata, handles, varargin)

 fullfilename = get(handles.outfilename_edit,'string');
 if ~isempty(fullfilename) 
   % store filename and path to handles.DataFile
   [path, filename] = SplitFileName(fullfilename);
   handles.DataFile.OutPath     = path;
   handles.DataFile.OutFileName = filename;
   handles.DataFile.SaveResult.Mode = 'on';
   guidata(h,handles);
   set(handles.saveresultmode_checkbox,'value',1);
   information(['You can choose, if you want to save the analysis results in '...
                'the selected file by switching the "Save Results to File" '...
                'checkbox "on" or "off".']);
   drawnow;
 end
                                                          
% --------------------------------------------------------------------
function varargout = addneuron_pushbutton_Callback(h, eventdata, handles, varargin)

    % get eventnumber form eventlist
    index_selected = get(handles.allevents_listbox,'value');
	event_list = cellstr(get(handles.allevents_listbox,'string'));	
	allevents_selected_item = event_list{index_selected};
    oldstring = get(handles.neuronlist_listbox,'string');
    
    % look, if there is allready at least one neuron selected 
    if ~isempty(oldstring)
      % make sure that no neuron is selected twice
      if ~ismember(allevents_selected_item,cellstr(oldstring))
        set(handles.neuronlist_listbox,'string',...
            char(oldstring,allevents_selected_item));
            information(['Added event ' allevents_selected_item  ...
                         '  to "Selected Neurons".']);
            drawnow;
      else
        information('Each neuron can only be selected once');
        drawnow;
      end
    else % no neuron selected up to now, select neuron and initialize remove_button
      set(handles.neuronlist_listbox,'string',allevents_selected_item);
      set(handles.removeneuron_pushbutton,'enable','on');
      information(['Added event ' allevents_selected_item  ...
                         '  to "Selected Neurons".']);
      drawnow;
    end
    
    % save DataFile.NeuronList
    handles.DataFile.NeuronList = (str2num(get(handles.neuronlist_listbox,'string')))';
    guidata(h,handles);
    
% --------------------------------------------------------------------
function varargout = addevent_pushbutton_Callback(h, eventdata, handles, varargin)

    % get eventnumber form eventlist
    index_selected = get(handles.allevents_listbox,'value');
	event_list = cellstr(get(handles.allevents_listbox,'string'));	
	allevents_selected_item = event_list{index_selected};
    oldstring = get(handles.eventlist_listbox,'string');
    
    % look, if there is allready at least one event selected 
    if ~isempty(oldstring)
      % make sure that no event is selected twice
      if ~ismember(allevents_selected_item,cellstr(oldstring))
        eventlist = char(oldstring,allevents_selected_item);
        set(handles.eventlist_listbox,'string',eventlist);  
            information(['Added event ' allevents_selected_item  ...
                         '  to "Selected Events".']);
            drawnow;
      else
        information('Each event can only be selected once');
        drawnow;
      end
    else % no event selected up to now, select event and initialize remove_button
      set(handles.eventlist_listbox,'string',allevents_selected_item);
      set(handles.removeevent_pushbutton,'enable','on');
      information(['Added event ' allevents_selected_item  ...
                         '  to "Selected Events".']);
      drawnow;
    end
   
    % save DataFile.Eventlist
    handles.DataFile.EventList = (str2num(get(handles.eventlist_listbox,'string')))';
    guidata(h,handles);
    
% --------------------------------------------------------------------
function varargout = startue_pushbutton_Callback(h, eventdata, handles, varargin)

 information('Started UE Analysis with current Parameter Setting.');
 drawnow;
 UEMain(handles.DataFile);
 
% --------------------------------------------------------------------
function varargout = removeneuron_pushbutton_Callback(h, eventdata, handles, varargin)

    % get neuronnumber form neuronlist and convert to cell
    index_selected = get(handles.neuronlist_listbox,'value');
	neuronlist = cellstr(get(handles.neuronlist_listbox,'string'));	
	information(['Removed neuron ' neuronlist{index_selected}  ...
                         '  from "Selected Neurons".']);
    neuronlist(index_selected)=[];
    % convert neuronlist back to char
    neuronlist=char(neuronlist);
    set(handles.neuronlist_listbox,'string',neuronlist);
    set(handles.neuronlist_listbox,'value',1);
    
    % check, if there are neurons left in neuronlist, else disactivate removebutton
    if isempty(neuronlist)
      set(handles.removeneuron_pushbutton,'enable','off');
    end

    % save DataFile.NeuronList
    handles.DataFile.NeuronList = (str2num(get(handles.neuronlist_listbox,'string')))';
    guidata(h,handles);
    
% --------------------------------------------------------------------
function varargout = removeevent_pushbutton_Callback(h, eventdata, handles, varargin)

    % get eventnumber form eventlist and convert to cell
    index_selected = get(handles.eventlist_listbox,'value');
	eventlist = cellstr(get(handles.eventlist_listbox,'string'));
	information(['Removed event ' eventlist{index_selected}  ...
                         '  from "Selected Events".']);
    eventlist(index_selected)=[];
    % convert eventlist back to char
    eventlist=char(eventlist);
    set(handles.eventlist_listbox,'string',eventlist);
    % check, if there are events left in eventlist, else disactivate removebutton
    if isempty(eventlist)
      set(handles.removeevent_pushbutton,'enable','off');
    else
      set(handles.eventlist_listbox,'value',1);
    end

    % save DataFile.Eventlist
    handles.DataFile.EventList = (str2num(get(handles.eventlist_listbox,'string')))';
    guidata(h,handles);

% --------------------------------------------------------------------
function varargout = allevents_listbox_Callback(h, eventdata,handles, varargin)
% --------------------------------------------------------------------
function varargout = neuronlist_listbox_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = eventlist_listbox_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = cutevent_popupmenu_Callback(h, eventdata, handles, varargin)

  eventlist = cellstr(get(handles.cutevent_popupmenu,'string'));
  position  = get(handles.cutevent_popupmenu,'value');
  cutevent  = eventlist{position};
  set(handles.cutevent_edit,'string',cutevent);
  handles.DataFile.CutEvent = str2num(cutevent);
  guidata(h,handles);
 
% --------------------------------------------------------------------
function varargout = tpre_edit_Callback(h, eventdata, handles, varargin)

 handles.DataFile.TPre = str2num(get(handles.tpre_edit,'string'));
 guidata(h,handles);
 
% --------------------------------------------------------------------
function varargout = tpost_edit_Callback(h, eventdata, handles, varargin)

 handles.DataFile.TPost = str2num(get(handles.tpost_edit,'string'));
 guidata(h,handles);
 
% --------------------------------------------------------------------
function varargout = timeunits_edit_Callback(h, eventdata, handles, varargin)

 handles.DataFile.TimeUnits = str2num(get(handles.timeunits_edit,'string'));
 guidata(h,handles);

% --------------------------------------------------------------------
function varargout = alpha_edit_Callback(h, eventdata, handles, varargin)

 handles.DataFile.Analysis.Alpha = str2num(get(handles.alpha_edit,'string'));
 guidata(h,handles);

% --------------------------------------------------------------------
function varargout = complexity_edit_Callback(h, eventdata, handles, varargin)

 handles.DataFile.Analysis.Complexity = str2num(get(handles.complexity_edit,'string'));
 guidata(h,handles);
 
 % --------------------------------------------------------------------
function varargout = complexity_max_Callback(h, eventdata, handles, varargin)

 handles.DataFile.Analysis.ComplexityMax = str2num(get(handles.complexity_max,'string'));
 guidata(h,handles);

% --------------------------------------------------------------------
function varargout = binsize_edit_Callback(h, eventdata, handles, varargin)

 handles.DataFile.Analysis.Binsize = str2num(get(handles.binsize_edit,'string'));
 guidata(h,handles);

% --------------------------------------------------------------------
function varargout = tslid_edit_Callback(h, eventdata, handles, varargin)

 handles.DataFile.Analysis.TSlid = str2num(get(handles.tslid_edit,'string'));
 guidata(h,handles);

% --------------------------------------------------------------------
function varargout = windowshift_edit_Callback(h, eventdata, handles, varargin)

 handles.DataFile.Analysis.WindowShift = str2num(get(handles.windowshift_edit,'string'));
 guidata(h,handles);
 
% --------------------------------------------------------------------
function varargout = uemethod_popupmenu_Callback(h, eventdata, handles, varargin)

 selection = get(handles.uemethod_popupmenu,'value');
 switch selection
   case 1
       handles.DataFile.Analysis.UEMethod = 'trialaverage';
   case 2
       handles.DataFile.Analysis.UEMethod = 'trialbytrial';
   case 3
       handles.DataFile.Analysis.UEMethod = 'csr';
       information(['CSR Parameters can be changed in the "General Options" '...
                    'submenu of the "File" Menu.']);
       drawnow;
 end
 guidata(h,handles); 
 
% --------------------------------------------------------------------
function varargout = wildcard_popupmenu_Callback(h, eventdata, handles, varargin)

 selection = get(handles.wildcard_popupmenu,'value');
 switch selection
   case 1
       handles.DataFile.Analysis.Wildcard = 'off';
   case 2
       handles.DataFile.Analysis.Wildcard = 'on';
 end
 guidata(h,handles);
 
% --------------------------------------------------------------------
function varargout = saveresultmode_checkbox_Callback(h, eventdata, handles, varargin)

 mode = get(handles.saveresultmode_checkbox,'value');
 switch mode
  case 0     
    handles.DataFile.SaveResult.Mode = 'off';
  case 1
    handles.DataFile.SaveResult.Mode = 'on';
 end
 % save ResultMode to DataFile.Result.Mode
 guidata(h,handles);
 
% --------------------------------------------------------------------
function varargout = loaddata_pushbutton_Callback(h, eventdata, handles, varargin)
 
 information('Wait while program is reading the GDF File.');
 drawnow;
 
 % initialize listofallevents, clear list and get filename
 listofallevents = [];
 set(handles.allevents_listbox,'string',listofallevents);
 set(handles.addneuron_pushbutton,'enable','off');
 set(handles.addevent_pushbutton,'enable','off');
     
 % read gdf-data from file
 try
   gdf = read_gdf([handles.DataFile.FileName '.gdf']);
 catch
   information(lasterr)
 end

 if isempty(gdf.Data)
   information('ERROR: File does not have the right format (read_gdf).');
 elseif gdf.Data == -1
   information('ERROR: Could not open selected file (read_gdf).');
 else       
     
   % fill listofallevents and activate addneuron and addevent
   listofallevents = unique(gdf.Data(:,1));
   set(handles.allevents_listbox,'string',listofallevents);
   set(handles.cutevent_popupmenu,'string',listofallevents);
   set(handles.cutevent_popupmenu,'enable','on');
   set(handles.addneuron_pushbutton,'enable','on');
   set(handles.addevent_pushbutton,'enable','on');
      
   % save allevents_listbox content and CutEvent to handles.DataFile
   eventlist = cellstr(get(handles.cutevent_popupmenu,'string'));
   position  = get(handles.cutevent_popupmenu,'value');
   cutevent  = eventlist{position};
   set(handles.cutevent_edit,'string',cutevent);
   handles.DataFile.CutEvent = str2num(cutevent);
   handles.DataFile.ListofallEvents = listofallevents;
   guidata(h,handles);
   
   information(['You can choose events from the list of all events in the selected file ' ...
                'and add them to the "List of Neurons" or the "List of selected Events".']);
 end    
     
% --------------------------------------------------------------------
function varargout = datahandling_menu_Callback(h, eventdata, handles, varargin)

 % check for non empty ListofallEvents
 if isempty(handles.DataFile.ListofallEvents)
     information(['The Data Handling menu can only be opened if the "List of all Events" ' ...
                  'is not empty. To fill the list you have to load a valid Data File.']);
     drawnow;
 else
     information('');
     handles.DataFile = datahandling('init',handles.DataFile);
     guidata(h,handles);
 end

% --------------------------------------------------------------------
function varargout = uemwafigure_menu_Callback(h, eventdata, handles, varargin)

     information('');
     handles.DataFile = uemwaparameters('init',handles.DataFile);
     guidata(h,handles);
 
% --------------------------------------------------------------------
function varargout = signfigure_menu_Callback(h, eventdata, handles, varargin)

     information('');
     handles.DataFile = signparameters('init',handles.DataFile);
     guidata(h,handles);

% --------------------------------------------------------------------
function varargout = dotdisplay_menu_Callback(h, eventdata, handles, varargin)

     information('');
     handles.DataFile = dotparameters('init',handles.DataFile);
     guidata(h,handles);
  
% --------------------------------------------------------------------
function varargout = batchmode_menu_Callback(h, eventdata, handles, varargin)

     batchwindow;

% --------------------------------------------------------------------
function parallelmode_menu_Callback(h, eventdata, handles)

     information('');
     handles.DataFile = parallelmode('init',handles.DataFile);
     guidata(h,handles);
     
% --------------------------------------------------------------------
function varargout = loadparafile_submenu_Callback(h, eventdata, handles, varargin)

  [filename, pathname] = uigetfile({'*.mat',...
                                   '.mat Format (*.mat)';...
                                   '*.*', 'All Files (*.*)'},...
                                   'Load Parameters from File');
  if ~(filename == 0)
    % load DataFile structure
    DataFile = []; 
    loadfilename = [pathname filename];
    load(loadfilename); %eval(['load ' loadfilename]);
    % fill new parameters
    if ~isempty(DataFile)
       handles.DataFile = DataFile;
       guidata(h,handles);
       UESetupFillParameters(handles,handles.DataFile);
       set(handles.parameter_edit,'visible','on');
       set(handles.parameter_edit,'enable','inactive');
       set(handles.parameter_edit,'string',['Parameter File: ' loadfilename]);
       set(handles.savepara_submenu,'enable','on');
       information(['Loaded new Parameter File: ' loadfilename]);
       drawnow;
    else
       information('Could not load valid DataFile structure from selected Parameter File.');
       drawnow;
    end
    clear DataFile;
  end
  
% --------------------------------------------------------------------
function varargout = saveparafile_submenu_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
 
 [path, name] = SplitFileName(handles.DataFile.FileName);
 
 [filename, pathname] = uiputfile([name 'Param'],'Save Parameters to File');
 
  if ~(filename == 0)
    % eventually add .mat to filename
    position = findstr('.mat',filename);
    if isempty(position)
      savefilename = [pathname filename '.mat'];
    else
      savefilename = [pathname filename];
    end   
    % save DataFile structure
    DataFile = handles.DataFile;
    save(savefilename,'DataFile'); %eval(['save ' savefilename ' DataFile']);
    set(handles.parameter_edit,'visible','on');
    set(handles.savepara_submenu,'enable','on');
    set(handles.parameter_edit,'string',['Parameter File: ' savefilename]);
    information(['Saved Parameter Setting to File: ' savefilename]);
    drawnow;
  end

% --------------------------------------------------------------------
function varargout = savepara_submenu__Callback(h, eventdata, handles, varargin)

    filename = get(handles.parameter_edit,'string');
    % remove "Parameter File:" from filename
    filename = filename(17:length(filename));
    % eventually add .mat to filename
    position = findstr('.mat',filename);
    if isempty(position)
      savefilename = [filename '.mat'];
    else
      savefilename = filename;
    end   
    % save DataFile structure
    DataFile = handles.DataFile;
    save(savefilename,'DataFile'); %eval(['save ' savefilename ' DataFile']);
    information(['Saved Parameter Setting to File: ' savefilename]);
    drawnow;

% --------------------------------------------------------------------
function varargout = chosedatafile_submenu_Callback(h, eventdata, handles,varargin)

 [filename, pathname] = uigetfile({'*.gdf',...
                                   'Data File in GDF Format (*.gdf)';...
                                   '*.*', 'All Files (*.*)'},...
                                   'Select Data File');
 
 if ~isequal(filename,0) & ~isequal(pathname,0)
 
    % remove .gdf from filename and store filename in DataFile 
    position = findstr('.gdf',filename);

    if ~isempty(position)
       handles.DataFile.FileName = [pathname filename(1:(position-1))];
       set(handles.datafile_edit,'string',[handles.DataFile.FileName '.gdf']);
    else
       handles.DataFile.FileName = [pathname filename];
       set(handles.datafile_edit,'string',handles.DataFile.FileName);
    end                             
 
    guidata(h,handles);
 
    set(handles.datafile_edit,'enable','on');
    set(handles.loaddata_pushbutton,'enable','on');
    information(['To open the selected data file click "Load selected Data File". '...
                 'The list of all events in the file will then be displayed in ' ...
                 'the corresponding listbox.']);
 end
            
% --------------------------------------------------------------------
function varargout = resetpara_submenu_Callback(h, eventdata, handles, varargin)

 % Load new default DataFile structure and fill parameters
 try
  load UEParameters_Default.mat;
  handles.DataFile = DataFile;
  guidata(h,handles);
  UESetupFillParameters(handles,handles.DataFile);
  set(handles.parameter_edit,'visible','off');
  information('Parameters have been set back to default values.');
 catch
  information(lasterr);
 end
 
% --------------------------------------------------------------------
function varargout = chooseoutfile_submenu_Callback(h, eventdata, handles, varargin)

 information(['IMPORTANT: Do not select a Filename with an extention, because the '...
              'programm will create a whole set of files, that do all have the same '...
              'Filename, but different extensions. If you select a file from the '...
              'list make sure to remove its extension.']);
 drawnow;

 [path, filename] = SplitFileName(handles.DataFile.FileName);
 [filename, pathname] = uiputfile([filename 'Res'],...
                                  'Select File to Save Results to');
        
 % store filename and path to handles.DataFile
 if ~isequal(filename,0) & ~isequal(pathname,0)
   handles.DataFile.OutPath     = pathname;
   handles.DataFile.OutFileName = filename;
   handles.DataFile.SaveResult.Mode = 'on';
   guidata(h,handles);
   set(handles.outfilename_edit,'string',[pathname filename]);
   set(handles.saveresultmode_checkbox,'value',1);
   information(['You can choose, if you want to save the analysis results in '...
              'the selected file by switching the "Save Results to File" '...
              'checkbox "on" or "off".']);
   drawnow;
 end
 
% --------------------------------------------------------------------
function varargout = generaloptions_submenu_Callback(h, eventdata, handles,varargin)

 information('');
 drawnow;
 handles.DataFile = generaloptions('init',handles.DataFile);
 guidata(h,handles);
 
% --------------------------------------------------------------------
function varargout = close_submenu_Callback(h, eventdata, handles, varargin)

 delete(handles.figure1);
 
% --------------------------------------------------------------------
function varargout = check_pushbutton_Callback(h, eventdata, handles, varargin)

 checkdatafile(handles.DataFile); 

% --------------------------------------------------------------------
function varargout = closeplots_submenu_Callback(h, eventdata, handles, varargin)

 close all;

% --------------------------------------------------------------------
function varargout = file_menu_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = parameter_edit_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
