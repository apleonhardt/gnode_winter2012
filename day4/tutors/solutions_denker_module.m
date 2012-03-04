%This script contains a rough solution to the exercises related to the
%teaching module 'Analysis of phase relation of spikes to LFP' of the G-Node.
%Each cell of this script provides a guide on answering the corresponding
%questions in the exercises.
%
%The time to complete exercises is very limited, such that analyses techniques 
%can only be performed in a sketchy manner.
%For a thorough analysis, all code presented here needs substantial improvement.
%The aim here was to keep the code as simple as possible.
%
%This module requires the following additional functions which are assumed
%to be in the directory "supplied":
%  create_sine: create a sine wave time series
%  create_poiss: create a spike train modeled as a Poisson process
%  create_locked: create a spike train that is phase-locked to the LFP with a given precision
%  convert2bin: convert a spike train given by spike time stamps into a binned spike train
%  cs_mean: circular mean of a vector
%  cs_std: circular std of a vector
%  cs_R: normalized vector strength
%  cs_test_uniform: circular Rayleigh test for uniformity (corrected for small samples)
%  vonMise: a normalized von Mise distribution
%  create_isi_surrogates: create a spike train by shuffling the inter-spike intervals of an exisiting one
%
%In addition, this script uses the chronux toolbox (available at http://chronux.org/) developed 
%by the Mitra Lab at Cold Spring Harbor Laboratory (see also: "Observed Brain 
%Dynamics", Partha Mitra and Hemant Bokil, Oxford University Press, New York, 2008.))
%It is assumed that this toolbox resides in the subdirectory 'chronux' in
%the current directory.
%
%
%changes: 2010-02-24 Michael Denker
%         2012-02-28 Michael Denker


%% Part 1 Prerequisites

clear
close all hidden

%randomize
rand('state',sum(100*clock));

%add chronux files to path
addpath(genpath('chronux_fixed'));
addpath(genpath('supplied'));

uniform={'uniform','non-uniform'};
locked={'non-locked','locked'};


%% Part 1.1a

%sampling rate in Hz
samplingrate=1000;

%sampling period in ms
samplingperiod=1000/samplingrate;

%rate of the Poisson in Hz
poisson_rate=10;

%length of simulated data segment in ms
timelength=5000;

%frequency of LFP
%note that the frequency is the same as for the Poisson process
lfp_freq=10;
lfp_amp=4;

%create Poisson spike train
st_poiss=create_poiss([],timelength,poisson_rate);

%create LFP sine wave
lfp_sine=create_sine(timelength,samplingrate,lfp_freq,lfp_amp,[]);



%% Part 1.1b
close all

%actual length of the sta will be 2*sta_lags+1 bins
sta_lags_ms=200;
sta_lags=sta_lags_ms/samplingperiod;

%eliminate spikes on the border (sta_lags bins on the left and right) to exclude border effects
st_poiss_reduced=st_poiss(st_poiss>sta_lags_ms & st_poiss<timelength-sta_lags_ms);



%calculate STA in a straight-forward fashion

sta_1=zeros(1,2*sta_lags+1);

for i=1:length(st_poiss_reduced)
    sta_1=sta_1+lfp_sine(round(st_poiss_reduced(i)/samplingperiod)-sta_lags+1:round(st_poiss_reduced(i)/samplingperiod)+sta_lags+1);
end
sta_1=sta_1./length(st_poiss_reduced);



%calculate STA via CC

%create binned version of spike train
st_poiss_binned        =convert2bin(st_poiss        ,0,timelength,samplingperiod);
st_poiss_binned_reduced=convert2bin(st_poiss_reduced,0,timelength,samplingperiod);

sta_2=xcov(lfp_sine,st_poiss_binned_reduced,sta_lags,'none')/sum(st_poiss_binned_reduced);



%calculate STA using the Chronux toolbox

sta_3=sta(st_poiss,lfp_sine,0:samplingperiod:timelength,'n',[],[0 timelength],[-sta_lags_ms sta_lags_ms],0);



%show that methods yield the same result
figure
plot((-sta_lags:sta_lags)*samplingperiod,sta_1,'b-');
hold on;
plot((-sta_lags:sta_lags)*samplingperiod,sta_2,'r--');
plot((-sta_lags:sta_lags)*samplingperiod,sta_3,'k:');
xlabel('t (ms)');
ylabel('STA');



%estimate confidence interval for simple Poisson data

%number of resamples
num_resample=1000;

%holds sta of each resample
sta_resamp=zeros(num_resample,2*sta_lags+1);

for i=1:num_resample
    %create a random permutation of the original spike train
    %such a simple surrogate works here, because we are testing for Poisson
    %spike trains only
    st_resamp=st_poiss_binned(randperm(length(st_poiss_binned)));
    %or:
    %[dummy,ind]=sort(rand(1,length(st_poiss_binned)));
    %st_resamp=st_poiss_binned(ind);
    
    %remove spikes at the border of the recording
    st_resamp(1:sta_lags)=0;
    st_resamp(end-sta_lags+1:end)=0;

    %calculate sta using method 2 for this resample
    sta_resamp(i,:)=xcov(lfp_sine,st_resamp,sta_lags,'none')/sum(st_resamp);
end

%for each time lag, get top and bottom 2.5% of the resampled STAsvariable
sta_resamp=sort(sta_resamp);

%plot confidence
plot((-sta_lags:sta_lags)*samplingperiod,sta_resamp(.975*num_resample,:),'m-');
plot((-sta_lags:sta_lags)*samplingperiod,sta_resamp(.025*num_resample,:),'m-');
legend({'STA straight','STA CCH','STA chronux','Conf'});



%% Part 1.1c
close all

%calculate SFC

%set a few parameters for the routine, like the type of error and the
%sampling rate
cparam.err=[1 0.01];
cparam.Fs=samplingrate;
[cohere_coherency,cohere_phase,dummy1,dummy2,dummy3,freq,zs,confidence,phisigma]=...
    coherencycpb(lfp_sine',st_poiss_binned',cparam);

%plot coherence and its confidence level
figure
plot(freq,cohere_coherency);
hold on
plot(freq,confidence,'r-');
xlim([0 50]);
xlabel('f (Hz)');
ylabel('coherence');



%% Part 1.1d
close all

%calculate hilbert transform of signal
lfp_sine_analytic=hilbert(lfp_sine);

%backtrack to obtain Hilbert transform (90 degree phase shifted signal)
lfp_sine_hilbert=imag(lfp_sine_analytic);

%amplitude and phase
lfp_sine_amp  =abs(lfp_sine_analytic);
lfp_sine_phase=angle(lfp_sine_analytic);

%visualize
figure
plot(0:samplingperiod:timelength,lfp_sine_phase);
hold on
plot(0:samplingperiod:timelength,lfp_sine,'k-');
plot(0:samplingperiod:timelength,lfp_sine_hilbert,'r--');
xlim([0 500]);
xlabel('t (ms)');
ylabel('signals, phase');
legend({'phase','signal','H[signal]'});


%extract phase at time points of spiking
st_poiss_phase=lfp_sine_phase(st_poiss_binned==1);

%print statistics of phase locking
disp('1.1d');
disp(['Vector Strength R: ' num2str(cs_R(st_poiss_phase))]);
disp(['Mean: ' num2str(cs_mean(st_poiss_phase))]);
disp(['Variance: ' num2str(cs_std(st_poiss_phase))]);
disp(['Test Uniform: ' num2str(cs_test_uniform(st_poiss_phase)) ' ' uniform{(cs_test_uniform(st_poiss_phase)<0.05)+1}]);



%% Part 1.2
close all

%p=precision of locking 
%pi must be < pi!!
%p=0+eps == precise locking on [pi-p,pi+p]
%p=pi-eps == almost no locking on [pi-p,pi+p]
p=pi-0.01;
%p=0.1;
st_locked=create_locked(lfp_sine,0:samplingperiod:timelength,1,pi-p,pi+p);
st_locked_binned=convert2bin(st_locked,0,timelength,samplingperiod);

%plot signal and spikes
figure
plot(lfp_sine,'k-');
hold on
plot(st_locked_binned,'r-');
xlabel('time (ms)');



%calculate STA

%eliminate spikes on the border (sta_lags bins on the left and right) to exclude border effects
st_locked_reduced=st_locked(st_locked>sta_lags_ms & st_locked<timelength-sta_lags_ms);

sta_l=zeros(1,2*sta_lags+1);

for i=1:length(st_locked_reduced)
    sta_l=sta_l+lfp_sine(round(st_locked_reduced(i)/samplingperiod)-sta_lags+1:round(st_locked_reduced(i)/samplingperiod)+sta_lags+1);
end
sta_l=sta_l./length(st_locked_reduced);

%plot STA, using same Poisson confidence bands as before (assuming that the locked 
%spike train has the same frequency as the Poisson spike train -- here Poisson
%is at 10Hz, and the locked spike train has 1 spike per 10Hz oscillation)
figure
plot((-sta_lags:sta_lags)*samplingperiod,sta_l,'b-');
hold on;
plot((-sta_lags:sta_lags)*samplingperiod,sta_resamp(.975*num_resample,:),'m-');
plot((-sta_lags:sta_lags)*samplingperiod,sta_resamp(.025*num_resample,:),'m-');
xlabel('t (ms)');
ylabel('STA');



%extract coherence
cparam.err=[1 0.05];
cparam.Fs=samplingrate;
[cohere_coherency,cohere_phase,dummy1,dummy2,dummy3,freq,zs,confidence,phisigma]=...
    coherencycpb(lfp_sine',st_locked_binned',cparam);

%plot coherence and its confidence level
figure
plot(freq,cohere_coherency);
hold on
plot(freq,confidence,'r-');
xlim([0 50]);
xlabel('f (Hz)');
ylabel('coherency');



%extract phases
st_locked_phase=lfp_sine_phase(st_locked_binned==1);

%print statistics of phase locking
disp(['Vector Strength R: ' num2str(cs_R(st_locked_phase))]);
disp(['Mean: ' num2str(cs_mean(st_locked_phase))]);
disp(['Variance: ' num2str(cs_std(st_locked_phase))]);
disp(['Test Uniform: ' num2str(cs_test_uniform(st_locked_phase)) ' ' uniform{(cs_test_uniform(st_locked_phase)<0.05)+1}]);



%% Part 1.3
close all

%create one precisely locked and one random process. both with equal rates
st_mixed_poiss=create_poiss([],timelength,poisson_rate);
st_mixed_regular=create_locked(lfp_sine,0:samplingperiod:timelength,1,pi-0.1,pi+0.1);

%f=fraction of spikes from random process as opposed to precisely locked process
f=0.5;

%select random spikes from the regular and Poisson spike train according to
%ratio f
n_from_poiss  =round(f*length(st_mixed_poiss));
n_from_regular=round((1-f)*length(st_mixed_regular));
st_mixed=[st_mixed_poiss  (randi(length(st_mixed_poiss),1,n_from_poiss)) ...
          st_mixed_regular(randi(length(st_mixed_regular),1,n_from_regular))];
            
st_mixed_binned=convert2bin(st_mixed,0,timelength,samplingperiod);

%plot resulting spike train
figure
plot(lfp_sine,'k-');
hold on
plot(st_mixed_binned,'r-');



%calculate STA

%eliminate spikes on the border (sta_lags bins on the left and right) to exclude border effects
st_mixed_reduced=st_mixed(st_mixed>sta_lags_ms & st_mixed<timelength-sta_lags_ms);

sta_m=zeros(1,2*sta_lags+1);

for i=1:length(st_mixed_reduced)
    sta_m=sta_m+lfp_sine(round(st_mixed_reduced(i)/samplingperiod)-sta_lags+1:round(st_mixed_reduced(i)/samplingperiod)+sta_lags+1);
end
sta_m=sta_m./length(st_mixed_reduced);

%plot STA, using same Poisson confidence bands as before (assuming that the locked 
%spike train has the same frequency as the Poisson spike train -- here Poisson
%is at 10Hz, and the locked spike train has 1 spike per 10Hz oscillation)
figure
plot((-sta_lags:sta_lags)*samplingperiod,sta_m,'b-');
hold on;
plot((-sta_lags:sta_lags)*samplingperiod,sta_resamp(.975*num_resample,:),'m-');
plot((-sta_lags:sta_lags)*samplingperiod,sta_resamp(.025*num_resample,:),'m-');
xlabel('t (ms)');
ylabel('STA');



%extract coherence
cparam.err=[1 0.05];
cparam.Fs=samplingrate;
[cohere_coherency,cohere_phase,dummy1,dummy2,dummy3,freq,zs,confidence,phisigma]=...
    coherencycpb(lfp_sine',st_mixed_binned',cparam);

%plot coherence and its confidence level
figure
plot(freq,cohere_coherency);
hold on
plot(freq,confidence,'r-');
xlim([0 50]);
xlabel('f (Hz)');
ylabel('coherency');



%extract phases
st_mixed_phase=lfp_sine_phase(st_mixed_binned==1);

%print statistics of phase locking
disp(['Vector Strength R: ' num2str(cs_R(st_mixed_phase))]);
disp(['Mean: ' num2str(cs_mean(st_mixed_phase))]);
disp(['Variance: ' num2str(cs_std(st_mixed_phase))]);
disp(['Test Uniform: ' num2str(cs_test_uniform(st_mixed_phase)) ' ' uniform{(cs_test_uniform(st_mixed_phase)<0.05)+1}]);



%% Part 1.4
close all

%define two amplitudes
lfp_amp1=1;
lfp_amp2=100;

%create LFP sine wave with two different amplitudes, low the first half,
%high the second half. The amplitude is linearly increased from left to
%right
temp=create_sine(timelength,samplingrate,lfp_freq,lfp_amp1,0);
lfp_mixamp=temp.*((0:timelength/samplingperiod)*(lfp_amp2/lfp_amp1-1)/timelength*samplingperiod + 1);

%create a spike train that is locked well in the first half, and Poisson in
%the second half
st_mixamp=[create_locked(lfp_mixamp(1:floor(end/2)),0:samplingperiod:timelength/2,1,pi-0.1,pi+0.1) ...
           create_poiss([],                                     timelength/2,poisson_rate)+timelength/2];
st_mixamp_binned=convert2bin(st_mixamp,0,timelength,samplingperiod);

%plot the signal
figure
plot(lfp_mixamp);
hold on
plot(st_mixamp_binned*max(lfp_amp1,lfp_amp2),'r-');



%calculate the coherency and error bounds
cparam.err=[1 0.05];
cparam.Fs=samplingrate;
[cohere_coherency,cohere_phase,sxy,sxx,syy,freq,zs,confidence,phisigma]=...
    coherencycpb(lfp_mixamp',st_mixamp_binned',cparam);

[c2,f]=mscohere((lfp_mixamp'-mean(lfp_mixamp))/std(lfp_mixamp),(st_mixamp_binned'-mean(st_mixamp_binned))/std(st_mixamp_binned),[],[],[],samplingrate);


%plot the cross spectra
figure
plot(freq,abs(sxy),'k-');
hold on
plot(freq,abs(sxx),'r-');
plot(freq,abs(syy),'b-');
legend({'Sxy','Sxx','Syy'});
xlim([0 50]);
xlabel('f (Hz)');
ylabel('cross spectra');

%plot the coherency and confidence limit
figure
plot(freq,cohere_coherency);
hold on
plot(freq,confidence,'r-');
plot(f,c2,'r-');
xlim([0 50]);
xlabel('f (Hz)');
ylabel('coherency');

%plot the mean phase
figure
plot(freq,cohere_phase);
hold on
plot(freq,confidence,'r-');
xlim([0 50]);
xlabel('f (Hz)');
ylabel('coherence phase');


%now calculate the degree of phase locking using the hilbert transform
lfp_mixamp_analytic=hilbert(lfp_mixamp);

%amplitude and phase
lfp_mixamp_amp  =abs(lfp_mixamp_analytic);
lfp_mixamp_phase=angle(lfp_mixamp_analytic);


%extract phase at time points of spiking
st_mixamp_phase=lfp_mixamp_phase(st_mixamp_binned==1);


disp(['R: ' num2str(cs_R(st_mixamp_phase))]);
disp(['Mean: ' num2str(cs_mean(st_mixamp_phase))]);
disp(['Variance: ' num2str(cs_std(st_mixamp_phase))]);
disp(['Test Uniform: ' num2str(cs_test_uniform(st_mixamp_phase)) ' ' uniform{(cs_test_uniform(st_mixamp_phase)<0.05)+1}]);



%% Part 2 Prerequisites
clear
close all

clear
close all hidden

%randomize
rand('state',sum(100*clock));

%add chronux files to path
addpath(genpath('chronux_fixed'));
addpath(genpath('supplied'));

uniform={'uniform','non-uniform'};
locked={'non-locked','locked'};


%% Part 2.1

%load data files function or method 'mscoherecoherencycpb' for input argument
load('lfp.mat','lfp_matrix','sf','time');
load('spikes.mat','spike_cell');

%plot lfps
figure
for i=1:size(lfp_matrix,1)
    plot(time,(lfp_matrix(i,:)-mean(lfp_matrix(i,:)))/std(lfp_matrix(i,:))+i*5);
    xlabel('t (ms)');
    hold on
end

%plot spikes
for i=1:size(lfp_matrix,1)
    plot(spike_cell{i},i*5,'k.');
    xlabel('t (ms)');
end



%% Part 2.2
close all

%calculate ISI distribution
isi=[];
for i=1:length(spike_cell)
    isi=[isi diff(spike_cell{i})];
    %or:
    %isi=[isi spike_cell{i}(2:end)-spike_cell{i}(1:end-1)];
end

%plot ISI distribution and plot an exponential function for comparison
figure
[h,x]=hist(isi,0:400);
h=h./max(h);
bar(x,h);
hold on;
l=30;
plot(x,exp(-l*x/1000),'r-','Linewidth',5);



%% Part 2.3
close all

%calculated power spectrum averaged over trials to identify major frequency components
x=[];
for i=1:size(lfp_matrix,1)
    [s,f]=pwelch(lfp_matrix(i,:),[],[],[],sf);
    x=[x; s'];
end

%plot power spectrum
figure;
plot(f',mean(x));
xlabel('f / Hz)')


%construct Butterworth filter, from 12-24 Hz
startf=12;
stopf=24;
order=6;
[b a]=butter(order,[startf stopf]*2/sf);
for i=1:size(lfp_matrix,1)
    lfp_matrix_filt(i,:)=filtfilt(b,a,lfp_matrix(i,:));
end


%plot filtered and unfiltered lfps
figure
for i=1:size(lfp_matrix,1)
    plot(time,(lfp_matrix(i,:)-mean(lfp_matrix(i,:)))/std(lfp_matrix(i,:))+i*5,'k-');
    hold on
    plot(time,(lfp_matrix_filt(i,:)-mean(lfp_matrix_filt(i,:)))/std(lfp_matrix_filt(i,:))+i*5);
    xlabel('t (ms)');
end

%plot spikes
for i=1:size(lfp_matrix,1)
    plot(spike_cell{i},i*5,'k.');
    xlabel('t (ms)');
end



%% Part 2.4
close all

%calculate the analytic signal for each trial of the LFP
for i=1:size(lfp_matrix_filt,1)
    %calculate hilbert transform of signal
    lfp_matrix_analytic(i,:)=hilbert(lfp_matrix_filt(i,:));
end

%amplitude and phase
lfp_matrix_amp  =abs(lfp_matrix_analytic);
lfp_matrix_phase=mod(angle(lfp_matrix_analytic),2*pi);

%extract phase at time points of spiking
for i=1:length(spike_cell)
    spikes_binned=convert2bin(spike_cell{i},time(1),time(end),1/sf*1000);
    spike_phases{i}=lfp_matrix_phase(i,spikes_binned==1);
end



%define a binned phase axis
phaseax=linspace(0,2*pi,25);

%plot cumulative phase distribution
figure
phasedist=histc([spike_phases{:}],phaseax);
%normalize distribution
phasedist=phasedist/sum(phasedist);
bar(phaseax,phasedist);
xlabel('\phi');
ylabel('count');
hold on

%print statistics of phase locking
disp(['Vector Strength R: ' num2str(cs_R([spike_phases{:}]))]);
disp(['Mean: ' num2str(cs_mean([spike_phases{:}]))]);
disp(['Variance: ' num2str(cs_std([spike_phases{:}]))]);
disp(['Test Uniform: ' num2str(cs_test_uniform([spike_phases{:}])) ' ' uniform{(cs_test_uniform([spike_phases{:}])<0.05)+1}]);



%fit a von Mise distribution to the data
[par,resid,J,sigma]=nlinfit(phaseax,phasedist,@vonMise,[2, 0.5]);
[his,errorhis]=nlpredci(@vonMise,phaseax,par,resid,'covar',sigma);

%and plot the fit
fh=fill([phaseax fliplr(phaseax )],...
    [his+errorhis; flipud(his-errorhis)]',...
    [0.4 0.4 0.4]);
set(fh,'EdgeColor',[0.4 0.4 0.4]);



%% Part 2.5 and 2.6
close all

%number of surrogates
n_surr=1000;

%vector holds vector strength R for each surrogate
surr_R=zeros(1,n_surr);

%calculate vector strength R for every surrogate
for surr_i=1:n_surr
    %create a surrogate
    shuff_spike_cell=create_isi_surrogate(spike_cell,time(1),time(end));
    
    %extract phase at time points of spiking
    for i=1:length(spike_cell)
        shuff_spike_binned=convert2bin(shuff_spike_cell{i},time(1),time(end),1/sf*1000);
        shuff_spike_phases{i}=lfp_matrix_phase(i,shuff_spike_binned==1);
    end
    
    %save vector strength
    surr_R(surr_i)=cs_R([shuff_spike_phases{:}]);
end

%plot surrogate distribution
[h,x]=hist(surr_R,0:0.001:1);
h=h./max(h);
bar(x,h);
xlabel('R');
ylabel('pdf');
hold on   


%overlay cumulative surrogate distribution
for i=1:length(x)
    hcum(i)=sum(h(1:i)/sum(h));
end
plot(x,hcum,'g-');

%overlay theoretical curve assuming Poisson
plot(x,chi2cdf(2*x.^2*length([shuff_spike_phases{:}]),2),'r');
xlim([0 0.3]);
legend({'p(r), ISI shuffle','CDF(R), ISI shuffle','CDF(R), Poisson'});

%Find the value of R where the surrogate distribution becomes significant
[~,pos]=find(hcum>.95,1,'first');
R_sig=pos*0.001;
disp(['Test sig. locked against surrogates: ' locked{(cs_R([spike_phases{:}])>R_sig)+1}]);

