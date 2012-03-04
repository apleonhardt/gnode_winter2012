function [spmat,nbins,ntr] = Convert2ZeroOneMat(spti,trid,T,ntrials)
%
% [spmat,nbins,ntr] = Convert2ZeroOneMat(spti,trid,T,ntrials)
%
% input:  spti: sptimes as col vector
%         trid: trial ids as col vector (same length as spti)
%         T:    number of bins (assumes 1ms bins)
%         ntrials: total number of trials  
%
% output: mat: zero-one matrix, each column is one trials; 
%              spikes are marked by 1, otherwise 0
%         nbins : same as T (number of bins)  
%         ntr   : same as ntrials (number of trials)
%
% (c) Sonja Gruen, 2010, RIKEN BSI
% 

spmat   = zeros(T,ntrials);
  for ii=1:ntrials
    tmpidx = find(trid == ii);
    spmat(spti(tmpidx),ii)=1;
    clear tmpidx;
  end

  nbins = T;
  ntr   = ntrials;


