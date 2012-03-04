%% EXERCISE 1 :   PSC DETECTION, VISUALIZATION AND STATISTICAL ANALYSIS
% Clemens Boucsein, 4/2008
%
%
%% Part I: detect and display spontaneous PSC's from voltage clamp data
% Tasks to solve:
%
% 1. load data
% 2. plot raw data, filtered data and detected onsets for control purposes
% 3. find onsets of negative deflections below threshold
% 4. extract PSC's from data and plot them
% 5. plot extracted PSC's 
% 6. PSC statistics
% 7. print all figures
%


%% 1. Loading data into the Matlab workspace.
% 
% * make sure to empty (clear) your workspace to prevent occurrence of 
%   unexpected variables and values
% * Recall the name of the data file containing the PSC
%   data and the directory you stored it in, define variables for 
%   data directory and data file
% * load data
% * Define directory for results of today
%




 
%% 2. plot raw data and filtered data 
% 
% * data are contained within a so-called structure. This is a virtual container,
% which can be filled with different data formats. Access works via the point operator
% (see Matlab tutorial). Use this operator to explore the structure, and try to find
% the vectors containing the raw data, filtered data and the sampling rate!
% * plot a small piece of data (both, raw and filtered data in the same plot, use
% different colors)! Make sure that your time axis is properly scaled (i.e. it gives
% ms or sec, not units of sampling tics)! A small piece here means a few seconds.
%




%% 3. find onsets of negative deflections below threshold, plot threshold
% 
% * define a detection threshold and plot this level into the plot from task 1. 
%   You can infere a meaningful threshold from your plot of the raw data!
% * extract the time points where the current trace crossed the threshold
%   and collect them into one vector. As a control if you caught the correct
%   times, you can plot the detected PSC onsets into the raw data trace, too.
% * to access the raw data plot again, it is useful to collect the figure
%   handle from the 'figure' routine. To access a certain figure, you can
%   always activate the corresponding figure with the command 'figure(handle)'.
% 




 
%% 4. extract PSC's from data and plot them
% 



%
% 5. plot extracted PSC's 
%



%
% 6. PSC statistics
%




%
% 7. print all figures
%

%% Part II: detect and display evoked PSC's from uncaging experiment

%
% 8. load data
%


% 
% 9. detect stimulation times, re-group shutter opening times corresponding
% to pre-synaptic sites
% 


%
% 10. extract PSCs and plot them, one plot for each pre-synaptic site
%


% 
% 11. find onsets of negative deflections below threshold
% 

%
% 12. plot all figures
%
