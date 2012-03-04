function [cch,tautime,cchpred,cchcov,cchcoeff]=crossprog(signal1,signal2,maxlag)
% [cch,tautime,cchpred,cchcov,cchcoeff]=crossprog(signal1,signal2,maxlag)
% raw cross-correlogram, cch-predictor, crosscovariance and correlation coeff
% of signal1 and signal2
%
% input:
%   signal1, signal2: signals to cross-correlate
%                     both in the same time resolution
%                     and both by 2*maxlag longer than
%                     the signal part to be correlated.
%                     Time along rows, per row one trial.
%                     
%   maxlag : maximal shift implicitly in units of 
%            the signal time resolution
%
%  NOTE: the user takes care of the data that are 
%        at the borders - the programm does not do any 
%        zero-padding or adding of data, but
%        takes all the data!
%
%       
%       |------|================|------|
%       |------|================|------|
%        <---->                  <---->
%        maxlag                   maxlag 
%
%       |------|================|------|
%              |------|================|------|
%
%
%       |------|================|------|
%|------|================|------|
%
%
% output:
%  cch     : raw cross-correlogram
%  tautime : time axis of tau from -maxlag:1:maxlag
%  cchpred : predictor, based on trial averages of the
%            two signals
%  cchcov  : cch - cchpred (element by element)
%  cchcoeff: correlation coefficient:
%            cchcov normalized for each shift by the
%            product of the stds of the signals,
%            computed as the cross-correlogram
%            of std(signal1) and std(signal2)
%            see Aertsen et al (1989)
%            
%
% (c) Sonja Gruen, 17.9.04, Berlin
%


% or directly without going over trials
[cch,tautime]=crosscorr(signal1,signal2,maxlag);

%
% predictor based on the trial averaged signals
%
mean_signal1 = mean(signal1);
std_signal1  = std(signal1);
mean_signal2 = mean(signal2);
std_signal2  = std(signal2);

[cchpred,tautime]=crosscorr(mean_signal1,mean_signal2,maxlag);


%
% Covariance : raw CCH - pred CCH
%
cchcov = cch - cchpred;


%
% Correlation coefficient : (raw CCH - pred
% CCH)/cch(std(signal1)*std(signal2))
%

[cchstd,tautime]=crosscorr(std_signal1,std_signal2,maxlag);
cchcoeff = cchcov./cchstd;
