function [ti,tr, ntr] = Convert2SpTr(datafile)
% [ti,tr, ntr] = Convert2SpTr(datafile)
%
% input:  datafile: filename (as string) of data file
%                   consisting of matrix of
%                   2 columns : [spiketimespertrial trialids]
%                   (e.g. from a [0,1] matrix by
%                   [spiketimespertrial trialids] = find(matrix);
%                   EXPECTS the matrix in the variable
%                   sptrmat  as e.g. generated
%                   by sptrmat = [spiketimespertrial trialids];
%                   EXPECTS spiketimes in ms
%
% output: ti     : column vector with spike times
%                  per trial
%         tr     : column vector with trial id per 
%                  spike time 
%         ntr    : number of trials
%
% (c) Sonja Gruen, 1999-2003
% 

eval(['load ' datafile]);

ti  = sptrmat(:,1);          % spike times in ms
tr  = sptrmat(:,2);          % trial ids
ntr = length(unique(tr));    % number of trials



