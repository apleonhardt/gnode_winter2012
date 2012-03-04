function DataFile = parallelmode(varargin)


if isequal(varargin{1},'init')  % LAUNCH GUI
    
    fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    DataFile = varargin{2};
    
    handles.data.mode            = DataFile.PVM.ParallelMode;
    handles.data.scratchdirname  = DataFile.PVM.ScratchDirName;
    handles.data.autodelete      = DataFile.PVM.AutomaticDelete;
    handles.data.njob            = DataFile.PVM.NumberOfJobs;
    handles.data.ncpu            = DataFile.PVM.NumberOfProcessors;
    handles.data.randomize       = DataFile.PVM.RandomizeWindows;
    handles.data.priority        = DataFile.PVM.NicePriority;
     
    % in case of cancel, return original parameters
    handles.cancel = 'on';
    handles.originaldata = DataFile;
    
    guidata(fig, handles);

    % Set parameters
    
      
    % ScratchDirName
    set(handles.scratch_edit,'string',DataFile.PVM.ScratchDirName);
            
    % AutomaticDelete
    switch DataFile.PVM.AutomaticDelete
      case 'on'
        set(handles.delete_checkbox,'value',1);
      case 'off'
        set(handles.delete_checkbox,'value',0);
    end
    
    % Balancing
    switch DataFile.PVM.RandomizeWindows
      case 'on'
        set(handles.randomize_checkbox,'value',1);
      case 'off'
        set(handles.randomize_checkbox,'value',0);
    end
        
    % NumberofJobs
    set(handles.njob_edit,'string',num2str(DataFile.PVM.NumberOfJobs));    
    
    % NumberofProcessors
    set(handles.ncpu_edit,'string',num2str(DataFile.PVM.NumberOfProcessors));
    
    % Priority Level
    set(handles.priority_edit,'string',num2str(DataFile.PVM.NicePriority));

    % Mode
    switch DataFile.PVM.ParallelMode
      case 'off'
        set(handles.mode_checkbox,'value',0);
        set(handles.scratch_edit,'enable','off');
        set(handles.delete_checkbox,'enable','off');
        set(handles.njob_edit,'enable','off');
        set(handles.ncpu_edit,'enable','off');
        set(handles.priority_edit,'enable','off');
        set(handles.randomize_checkbox,'enable','off');
    case 'on'
        set(handles.mode_checkbox,'value',1);
        set(handles.scratch_edit,'enable','on');
        set(handles.delete_checkbox,'enable','on');
        set(handles.njob_edit,'enable','on');
        set(handles.ncpu_edit,'enable','on');
        set(handles.priority_edit,'enable','on');
        set(handles.randomize_checkbox,'enable','on');
    end
    
    
    % Wait for callbacks to run and window to be dismissed:
    uiwait(fig);
    
    handles = guidata(fig);
    
    switch handles.cancel
      case 'off'
        DataFile.PVM.ParallelMode       = handles.data.mode;
        DataFile.PVM.ScratchDirName     = handles.data.scratchdirname;
        DataFile.PVM.AutomaticDelete    = handles.data.autodelete;
        DataFile.PVM.NumberOfJobs       = handles.data.njob;
        DataFile.PVM.NumberOfProcessors = handles.data.ncpu;
        DataFile.PVM.RandomizeWindows   = handles.data.randomize;
        DataFile.PVM.NicePriority       = handles.data.priority;
        
        information('Saved changes made in Parallel Mode menu.');
        drawnow;
      case 'on'
        DataFile = handles.originaldata;
        
        information('No changes applied in Parallel Mode menu.');
        drawnow;
    end
    
    delete(fig);
        

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

% CALLBACKS

 
% -------------------------------------------------------------------------
function varargout = scratch_edit_Callback(h, eventdata, handles, varargin)
% -------------------------------------------------------------------------
function varargout = ncpu_edit_Callback(h, eventdata, handles, varargin)
% -------------------------------------------------------------------------
function varargout = delete_checkbox_Callback(h, eventdata, handles, varargin)
% -------------------------------------------------------------------------
function varargout = njob_edit_Callback(h, eventdata, handles, varargin)
% -------------------------------------------------------------------------
function varargout = randomize_checkbox_Callback(h, eventdata, handles, varargin)
% -------------------------------------------------------------------------
function varargout = priority_edit_Callback(h, eventdata, handles, varargin)
% -------------------------------------------------------------------------
function varargout = mode_checkbox_Callback(h, eventdata, handles, varargin)

selection = get(handles.mode_checkbox,'value');

 switch selection
      case 0
        set(handles.scratch_edit,'enable','off');
        set(handles.delete_checkbox,'enable','off');
        set(handles.njob_edit,'enable','off');
        set(handles.ncpu_edit,'enable','off');
        set(handles.priority_edit,'enable','off');
        set(handles.randomize_checkbox,'enable','off');
      case 1
        set(handles.scratch_edit,'enable','on');
        set(handles.delete_checkbox,'enable','on');
        set(handles.njob_edit,'enable','on');
        set(handles.ncpu_edit,'enable','on');
        set(handles.priority_edit,'enable','on');
        set(handles.randomize_checkbox,'enable','on');
 end


% --------------------------------------------------------------
function varargout = cancel_pushbutton_Callback(h, eventdata, handles, varargin)

 uiresume(handles.figure1);

% ------------------------------------------------------------
function varargout = apply_pushbutton_Callback(h, eventdata, handles, varargin)

 selection = get(handles.mode_checkbox,'value');
 
 switch selection
  case 1
      handles.data.mode = 'on';
  case 0
      handles.data.mode = 'off';
 end
 
 selection = get(handles.delete_checkbox,'value');
 
 switch selection
  case 1
      handles.data.autodelete = 'on';
  case 0
      handles.data.autodelete = 'off';
 end
 
 selection = get(handles.randomize_checkbox,'value');
 
 switch selection
  case 1
      handles.data.randomize = 'on';
  case 0
      handles.data.randomize = 'off';
 end

 handles.data.scratchdirname = get(handles.scratch_edit,'string');
 handles.data.ncpu           = str2num(get(handles.ncpu_edit,'string'));
 handles.data.njob           = str2num(get(handles.njob_edit,'string'));
 handles.data.priority       = str2num(get(handles.priority_edit,'string'));
 
 handles.cancel = 'off';
 
 guidata(h, handles);
 uiresume(handles.figure1);