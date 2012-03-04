function output=create_locked(sig,time,N,startp,stopp)
%Create a spike train where N spikes occur in the interval
%[WindowStart WindowEnd] of the instantaneous phase of a given signal 
%during each oscillation cycle.
%
%call:    create_locked(Signal,N,WindowStart,WindowStop)
%
%input:   Signal
%           Signal vector the spike train should lock to.
%         Time
%           Corresponding time stamp for each signal sample.
%         N
%           Number of spikes within each period
%         WindowStart, WindowStop
%           Window of each cycle within which to place the spikes, where
%           0 or 2pi is the peak and pi is the trough. For example,
%           WindowStart=pi and WindowStop=2*pi will place spikes locked to
%           the rising phase of the oscillation.
%
%return:  A vector of time stamps of the locked spike train.
%
%remarks: - Time given in ms, frequency in Hz.
%         - The signal must have a sufficiently high sampling rate such
%           that [WindowStart WindowEnd] can be resolved in each cycle.
%
%changes: 2010-02-24 Michael Denker

error(nargchk(5,6,nargin));


%wrap phase to 0..2pi
startp=mod(startp,2*pi);
stopp=mod(stopp,2*pi);

%first create empty spike train
output=[];

%size of
phasediff=mod(stopp-startp,2*pi);

%is there a locking region?
if phasediff<=0 || phasediff>=2*pi
    error('create_locked: locking width is either 0 or 2 pi.');
end

%make sure that there are 2 sample points in the locking region
ratewindowbinwidth=phasediff/1000;

%samplewindow for rate function
ratewindowlen=ceil(2*pi/ratewindowbinwidth);
ratewindow_p=linspace(0,2*pi,ratewindowlen);
ratewindow_r=zeros(1,ratewindowlen);
if startp<stopp
    ind=find(ratewindow_p>startp & ratewindow_p<stopp);
else
    ind=find(ratewindow_p>startp | ratewindow_p<stopp);
end

ratewindow_r(ind)=1/length(ind);

%extract phase from signal
phasesignal=mod(angle(hilbert(sig)),2*pi);
%phasesignal=angle(hilbert(sig));

%create cumulative distribution, where -intmax is inserted for each
%phase that is forbidden for spikes
cumdist=[];
for j=1:length(phasesignal)
    [dummy,b]=min(abs(phasesignal(j)-ratewindow_p));
    cumdist=[cumdist ratewindow_r(b)];
end
for j=2:length(phasesignal)
    cumdist(j)=cumdist(j)+cumdist(j-1);
end
%find all points where the slope of the cummulative dist. is zero
noslope=zeros(1,length(cumdist));
noslope(find(([0 cumdist(1:end-1)]-[cumdist])))=1;

%get indices where cycles start and end
startpos=find( ~[0 noslope] &  [noslope 0]);
stoppos=find(   [0 noslope] & ~[noslope 0])-1;

%now throw spikes, one per cycle
for j=1:length(startpos)
    %is there a region where we can put the spike?
    if startpos(j)~=stoppos(j)
        %move to next cycle and get corresponding part in cum. distrubution (and begin with zero)
        cycledist=cumdist(startpos(j):stoppos(j))-cumdist(startpos(j));
        cycletime=time(startpos(j):stoppos(j));
        
        %for each spike we place
        for k=1:N
            %folded spike time randomly chosen
            spiketime=max(cycledist)*rand;
            if spiketime==0, spiketime=max(cycledist); end;
            
            %get closest entry in our distribution (y-axis, so to speak)
            [dummy,b]=min(abs(spiketime-cycledist));
            
            %make sure that b is the index *below* the randomly chosen
            %number
            %                |                  |                  |
            %           cycledist(b)         spiketime        cycledist(b+1)
            %
            %since cycledist(1)=0 by definition, and spiketime>0 by
            %definition, we have no problem with the first bin.
            %similarly, if spiketime=cycledist(end), its maximum value,
            %then b->b-1, and again we have no problem with the last bin.
            if spiketime<=cycledist(b)
                b=b-1;
            end
            
            %save spike and interpolate between the closes cycletime bins
            output=[output cycletime(b)+(cycletime(b+1)-cycletime(b))*(spiketime-cycledist(b))/(cycledist(b+1)-cycledist(b))];
        end
    end
end

%sort spikes
output=sort(output);
