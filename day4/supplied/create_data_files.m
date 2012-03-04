%for reference only: how to obtain lfp.mat and spikes.mat from the raw data files
expnr=133;
lfpnr=2;
unitnr=1;
tr=3;

[lfp,spikes]=LoadRiehle('ori',expnr,tr,lfpnr,unitnr,'ps');
lfp_el=Riehle_eli(lfp);
lfp_cut=sig_chop(lfp_el,[0 1200]);
lfp_matrix=reshape([lfp_cut.data(:).signal],length(lfp_cut.data(1).signal),length(lfp_cut.data))';
time=sig_get_timestamps(lfp_cut,[],[],1);
time=[time{:}];
sf=lfp.data(1).sf;
save('lfp.mat','lfp_matrix','sf','time');
spikes_el=Riehle_eli(spikes);
spikes_cut=stts_chop(spikes_el,[0 1200]);
spike_cell=cell(length(spikes_cut.data));
for i=1:length(spikes_cut.data)
    spike_cell{i}=sort(spikes_cut.data(i).spikes);
end
save('spikes.mat','spike_cell');