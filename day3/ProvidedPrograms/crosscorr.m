function [cch,tautime]=crosscorr(signal1,signal2,maxlag)
% [cch,tautime]=crosscorr(signal1,signal2,maxtau): 
% cross-correlogram of signal1 and signal2
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
%
%
% (c) Sonja Gruen , 17.9.04, Berlin
%

signalsize1 = size(signal1);
signalsize2 = size(signal2);

% check if both are the same and 
% if the orientation is correct
if (signalsize1 == signalsize2)

    



nTrials = signalsize1(1,1);

for ii=1:nTrials

for jj=0:maxlag
  
  % shift to the right 
  signal1tmp = signal1(ii,(maxlag+1):end-maxlag);
  signal2tmp  = signal2(ii,maxlag+1+jj:end-maxlag+jj);
  cchright(ii,jj+1) = signal1tmp*signal2tmp';
  
  
  % shift to the left
  signal1tmp = signal1(ii,(maxlag+1):end-maxlag);   
  signal2tmp = signal2(ii,maxlag+1-jj:end-maxlag-jj);
  cchleft(ii,jj+1) = signal1tmp*signal2tmp';
   
end

% combine shifts to the left and to the right
% invert shift entries to the left, neglect 0
% take to the right as it is
cchtrials(ii,:) = [cchleft(ii,(maxlag+1):(-1):2), cchright(ii,:)];

end
cch     = sum(cchtrials,1)/nTrials;
tautime = -maxlag:1:maxlag;

else
    error('InputDataDoNotHaveSameSize');
end


%plot(tautime, cch)