function varargout = information(inputtext)
    
	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    set(handles.text,'string',inputtext);
    
	if nargout > 0
		varargout{1} = fig;
	end
