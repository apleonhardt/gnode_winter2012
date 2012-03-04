function output=create_isi_surrogate(spikes,timestart,timestop)
%Creates a surrogate of trials of a spike train by randomizing the 
%corresponding ISI intervals per trial.
%
%call:    create_isi_surrogate(Spiketrain,TimeStart,TimeStop)
%
%input:   Spiketrain
%           Cell array containing the spike data to create a surrogate 
%           of.
%         TimeStart, TimeStop
%           Time range in which to place the interval shuffle.
%
%return:  Cell array containing trials with the ISI's randomly shuffled.
%
%remarks: - The remaining time between before the first and after the last
%           spike is randomly allocated in the surrogate.
%
%changes: 2010-02-24 Michael Denker

error(nargchk(3,3,nargin));

%go through each trial
for i=1:length(spikes)
    output{i}=zeros(1,length(spikes{i}));
    
    %get ISI's
    intv=spikes{i}(2:end)-spikes{i}(1:end-1);
    
    offset=timestart+rand*(timestop-timestart-max(spikes{i})+min(spikes{i}));
    
    %shuffle each vector
    [dummy, order]=sort(rand(length(intv),1));
    newintv=[offset intv(order)];
    
    %set new spikes
    for j=1:length(newintv)
        output{i}(j)=sum(newintv(1:j));
    end
end
