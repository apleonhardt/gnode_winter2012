function varargout = errorwindow(inputtext,varargin)
    
	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);
    
    if nargin == 1
     
        set(handles.listbox,'string',inputtext);
    
    end
% --------------------------------------------------------------------
function varargout = listbox_Callback(h, eventdata, handles, varargin)
