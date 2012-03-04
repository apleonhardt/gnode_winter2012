function output=convert2bin(st,start,stop,res,clip)
%Converts a spike train from a time stamp representation to a binned spike
%train.
%
%call:    [V,T]=convert2bin(Spiketrain,*Start,*Stop,*Resolution,*Clipping)
%
%input:   Spiketrain
%           Vector of time stamps.
%         Start , Stop = [First and last spike time]
%           Starting time and stopping time of the binned array
%         Resolution = 0.1 ms
%           Temporal resolution of bins in ms
%         Clipping = 1
%           Clipping if more than one spike falls in a bin
%
%return:  V
%           Vector that contains the resulting binned vector structure.
%         T
%           Vector of the resulting corresponding time stamps of each bin.
%
%remarks: - Spikes before Start or after Stop are ignored.
%
%
%changes: 2010-02-24 Michael Denker

error(nargchk(1,5,nargin));

if nargin<5 || isempty(clip)
    clip=1;
end

if nargin<4 || isempty(res)
    res=0.1;
end

if nargin<3
    stop=max(st);
end

if nargin<2
    start=min(st);
end

output=zeros(1,ceil((stop-start)/res)+1);

validspikes=find(st>=start & st<=stop);

if clip
    for j=validspikes
        output(round((st(j)-start)/res)+1)=1;
    end
else
    for j=validspikes
        output(round((st(j)-start)/res)+1)=output(round((st(j)-start)/res)+1)+1;
    end
end

