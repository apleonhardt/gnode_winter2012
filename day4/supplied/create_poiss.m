function output=create_poiss(slength,tlength,rate)
%Creates a Poisson spike train.
%
%call:    create_poiss(SLength,TLength,Rate)
%
%input:   SLength
%           Minimum length of the spike train in number of spikes.
%           Either SLength of TLength must be nonempty.
%         TLength
%           Length of the spike train in time length.
%           Either SLength of TLength must be nonempty.
%         Rate
%           Rate of the process.
%
%return:  A vector of time stamps of the resulting Poisson spike train.
%
%remarks: - Leaving either Slength or Tlength (but not both) empty (i.e., []) or 
%           setting either to zero disregards the minimum length requirement.
%           Examples:
%            SLength=0, TLength=100:   Spike train extends for 100 ms
%            SLength=200, TLength=0:   Spike train has 200 spikes
%            SLength=200, TLength=100: Spike train is at most 100 ms and
%                                      has at most 200 spikes
%         - For a Poisson train, it is not necessary to treat the first
%           spike in a special way.
%         - Time given in ms, frequency in Hz.
%
%changes: 2010-02-24 Michael Denker


error(nargchk(3,3,nargin));

if isempty(slength)
    slength=0;
end

if isempty(tlength)
    tlength=0;
end

%is there a condition to terminate?
if ~slength && ~tlength, error('create_poiss: Must supply length condition either via SLength or TLength parameter.'); end;
    
output=[];
lasttime=0;
i=1;

%continue adding spikes until minimum number of spikes and minimum time is met
while i<=slength || lasttime<tlength
    rv=exprnd(1000/rate+1);
    
    %In extreme cases the poisson rnd function will return too small values,
    %which is bad because then there are two simultaneous events
    %(too small for numerical precision) -> brutal countermeasure
    if rv<1e-10, rv=1e-10; end
    
    output(i)=lasttime+rv;
    lasttime=output(i);
    
    i=i+1;
end

if tlength>0 && lasttime>tlength
    output=output(1:end-1);
end
