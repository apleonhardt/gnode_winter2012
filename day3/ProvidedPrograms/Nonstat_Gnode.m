
close all;
clear all;

h               = 1;
Tbase           = 1000;

binSize         = 1;
T               = binSize*ceil(Tbase/binSize);
NumberOfBins    = T/binSize;
nTrials         = 50;


backgroundrate = zeros(T,1);
%backgroundrate = backgroundrate + 10;
rateHigh        = 200;
rateLow         = 20;
endHigh         = 700;

coincrate       = 5;



%*************************
% stat in time
%*************************

if 0
backgroundrate(1:210)       = rateLow;
backgroundrate(211:endHigh) = rateLow;
backgroundrate(endHigh+1:1000)= rateLow;

 sp1Mat   = zeros(T,nTrials);
 sp1Mat   = spikeTrainInhomo(backgroundrate,T,h,nTrials,0);
  % counts per trial
 c = sum(sp1Mat(:,:));

filename ='statintime'; 
filename = 'Data0';
 [ti,tr]=find(sp1Mat);
 
 sptrmat = [ti tr];
 
 save Data0.mat sptrmat;

makePlot
end

if 0
%*************************    
% uncorrelated neurons
%*************************

%*************************
% non-stat in time
%*************************

backgroundrate(1:210)   = rateLow;
backgroundrate(211:endHigh) = rateHigh;
backgroundrate(endHigh+1:1000)= rateLow;

 sp1Mat   = zeros(T,nTrials);
 sp1Mat   = spikeTrainInhomo(backgroundrate,T,h,nTrials,0);
  % counts per trial
 c = sum(sp1Mat(:,:));

filename ='nonstatintime'; 
filename = 'Data1';
 [ti,tr]=find(sp1Mat);
 
 sptrmat = [ti tr];
 
 save Neuron1.mat sptrmat;

makePlot

backgroundrate(1:210)   = rateLow;
backgroundrate(211:endHigh) = rateHigh;
backgroundrate(endHigh+1:1000)= rateLow;

 sp1Mat   = zeros(T,nTrials);
 sp1Mat   = spikeTrainInhomo(backgroundrate,T,h,nTrials,0);
  % counts per trial
 c = sum(sp1Mat(:,:));

filename ='nonstatintime'; 
filename = 'Data2';
 [ti,tr]=find(sp1Mat);
 
 sptrmat = [ti tr];
 
 save Neuron2.mat sptrmat;

makePlot
end

if 1
    
    
    if 0 % simulate neurons
%*************************    
% correlated neurons
%*************************

%*************************
% non-stat in time
%*************************

rateLow = 20;
rateHigh = 50;

%------------------------------
% coincidences
%------------------------------

crate = 5;

coincrate(1:300)   = 0;
coincrate(301:400) = crate;
coincrate(401:1000)= 0;

 spcMat   = zeros(T,nTrials);
 spcMat   = spikeTrainInhomo(coincrate,T,h,nTrials,0);
 % coincidences per trial
 cc = sum(spcMat(:,:));
%------------------------------
% background spikes, neuron 1
%------------------------------
backgroundrate(1:210)   = rateLow;
backgroundrate(211:endHigh) = rateHigh - crate;
backgroundrate(endHigh+1:1000)= rateLow;

sp1Mat   = zeros(T,nTrials);
sp1Mat   = spikeTrainInhomo(backgroundrate,T,h,nTrials,0);

%------------------------------
% background spikes, neuron 2
%------------------------------
backgroundrate(1:210)   = rateLow;
backgroundrate(211:endHigh) = rateHigh - crate;
backgroundrate(endHigh+1:1000)= rateLow;

sp2Mat   = zeros(T,nTrials);
sp2Mat   = spikeTrainInhomo(backgroundrate,T,h,nTrials,0);

%------------------------------
% merge coincidences and background
%------------------------------


filename = 'Neuron1';
sp1cMat = sp1Mat + spcMat;
%makePlot(filename,sp1cMat,nTrials,T,1)
eval(['save ' filename '.mat sp1cMat'])


filename = 'Neuron2';
sp2cMat = sp2Mat + spcMat;
%makePlot(filename,sp2cMat,nTrials,T,2)
eval(['save ' filename '.mat sp2cMat'])


 % counts per trial
 c1 = sum(sp1cMat(:,:));
 c2 = sum(sp2cMat(:,:));
 
  
% cross-corr
maxlag = 200
figure
%hold on
for ii=1:nTrials
   
[cc,xc]=xcorr(sp1cMat(:,ii),sp2cMat(:,ii),maxlag);
if ii==1
 ccsum = cc;
else
ccsum = ccsum+cc;
end
end
plot(xc,ccsum)
drawnow

%hold off

    end % simulate neurons









end  % if
%*************************
%  latency variability
%*************************

if 0
sp1Mat   = zeros(T,nTrials);

rate1 = zeros(T,nTrials);
rate2 = zeros(T,nTrials);

LatencyJitter = 200;
randLat = round((rand(nTrials,1)-0.5)*LatencyJitter);

for i=1:nTrials

 backgroundrate(1:210+randLat(i,1))     = rateLow;
 backgroundrate(210+randLat(i,1)+1:endHigh) = rateHigh;
 backgroundrate(endHigh+1:T)                  = rateLow;
 sp1Mat(:,i)   = spikeTrainInhomo(backgroundrate,T,h,1,0);
  % counts per trial
 c(i) = sum(sp1Mat(:,i));
end
  
filename = 'latvar';
filename = 'Data2';
[ti,tr]=find(sp1Mat);
 
 sptrmat = [ti tr];
 
 save Data2.mat sptrmat;

makePlot
end


%*************************
%  rate variability
%*************************

if 1
nTrials = 50;
T = 1000;
Tn=T;
%ntrials = nTrials;
sp1Mat   = zeros(T,nTrials);

RateJitter = 100;

% random rates
%randRate   = (rand(nTrials,1)-0.5)*RateJitter;

% two rate states
randRate(1:2:nTrials,1) = 0;
randRate(2:2:nTrials,1) = -80;

for i=1:nTrials

 backgroundrate(1:210)         = rateLow;
 backgroundrate(210+1:endHigh) = rateHigh +randRate(i,1);
 backgroundrate(endHigh+1:T)   = rateLow;
 sp1Mat(:,i)   = spikeTrainInhomo(backgroundrate,T,h,1,0);

 % counts per trial
 c(i) = sum(sp1Mat(:,i));

end

filename = 'ratevar';
%filename = 'Data3';
[ti,tr]=find(sp1Mat);
 
 sptrmat = [ti tr];
 
 save Neuron3.mat sptrmat Tn nTrials;
 
 clear sptrmat;
 
 % second neuron, indep
 
 ntrials = nTrials;
sp1Mat   = zeros(T,nTrials);

RateJitter = 100;

% random rates
%randRate   = (rand(nTrials,1)-0.5)*RateJitter;

% two rate states
randRate(1:2:nTrials,1) = 0;
randRate(2:2:nTrials,1) = -80;

for i=1:nTrials

 backgroundrate(1:210)         = rateLow;
 backgroundrate(210+1:endHigh) = rateHigh +randRate(i,1);
 backgroundrate(endHigh+1:T)   = rateLow;
 sp1Mat(:,i)   = spikeTrainInhomo(backgroundrate,T,h,1,0);

 % counts per trial
 c(i) = sum(sp1Mat(:,i));

end

filename = 'ratevar';
%filename = 'Data3';
[ti,tr]=find(sp1Mat);
 
 sptrmat = [ti tr];
 
 save Neuron4.mat sptrmat Tn nTrials;
 


end





%*************************
% oscillatory non-stat in time
%*************************
if 0

f = 40;       %  Hz
a = 50;
b = 30;
t = [1:1:1000]/1000;
bb = 2*pi*f*t; 
backgroundrate = a+ b*sin(bb);
plot(t*1000,backgroundrate);

 sp1Mat   = zeros(T,nTrials);
 sp2Mat   = zeros(T,nTrials);
 %sp1Mat   = spikeTrainInhomo(backgroundrate,T,h,nTrials,0);

for i=1:nTrials
 sp1Mat(:,i)   = spikeTrainInhomo(backgroundrate,T,h,1,0);
 sp2Mat(:,i)   = spikeTrainInhomo(backgroundrate,T,h,1,0);
end


% counts per trial
c = sum(sp1Mat(:,:));

filename ='oscinonstatintime1'; 
filename = 'Data23';
 [ti,tr]=find(sp1Mat);
 sptrmat = [ti tr];
 save Data22.mat sptrmat;
 makePlot

filename ='oscinonstatintime2'; 
filename = 'Data24';
 [ti,tr]=find(sp2Mat);
 sptrmat = [ti tr];
 save Data24.mat sptrmat;
 makePlot

end




if 0      % pair UE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make UE analysis


% we need as input
% zero-one matrices of the spiking activities
% with naming
% sp1Mat sp2Mat and NumberOfBins nTrials

if 1 % use data from NWG-course

  % Data20 & [sp tr] & 1751 & data14, n401\\
  % Data21 & [sp tr] & 1751 & data14, n305\\
  % Data22 & [sp tr] & 1751 & data14, n502\\

  %% Example: joe (handshake)
  [sptimes1,trialids1,ntrials1,T1]=LoadData_Gnode('Data5');
  [sptimes2,trialids2,ntrials2,T2]=LoadData_Gnode('Data6');
  
  % bin data
  bin = 5;
  start = 0;
  stop=T1;
  clip =1;
  output=convert2bin(sptimes1,start,stop,bin,clip)
  
  sp1Mat = [];
  sp2Mat = [];
  for ii=1:ntrials1
    tmpidx1 = find(trialids1 == ii);
    tmpout1=convert2bin(sptimes1(tmpidx1),start,stop,bin,clip)
    sp1Mat(:,ii) = tmpout1';
    
    tmpidx2 = find(trialids2 == ii);
    tmpout2=convert2bin(sptimes2(tmpidx2),start,stop,bin,clip)
    sp2Mat(:,ii) = tmpout2';
    
    clear tmpidx1 tmpidx2 tmpout1 tmpout2;
  end
  T1 = size(sp1Mat,1);
  NumberOfBins = T1;
  
  %[sp1Mat,nbins,ntr] = Convert2ZeroOneMat(sptimes1,trialids1,T1,ntrials1);

  %[sp2Mat,nbins,ntr] = Convert2ZeroOneMat(sptimes2,trialids2,T2,ntrials2);


%MakeCCH('Data5', 'Data6', 50)
%MakeCCH('Data21', 'Data22', 50)
%MakeCCH('Data23', 'Data24', 50)
MakeAnalysisSingleNeuron('Data5')
MakeAnalysisSingleNeuron('Data6')

%NumberOfBins = nbins;
nTrials = ntrials1;
NumberOfBins = T1;

end % data from NWG-course







%% ----------------------------------
% Unitary events, assuming stationarity
%----------------------------------

% expected number of coincidences
nspike_pertrial_n1 = sum(sp1Mat);
nspike_pertrial_n2 = sum(sp2Mat);

p_pertrial_n1 = nspike_pertrial_n1/NumberOfBins;
p_pertrial_n2 = nspike_pertrial_n2/NumberOfBins;

nexp = sum(p_pertrial_n1(1,:).*p_pertrial_n2(1,:)*NumberOfBins);

nemp = 0;

for ii=1:nTrials
   nemp = nemp + sum(sp1Mat(:,ii).*sp2Mat(:,ii));
end

[S,jp]=jointSjointP(nemp,nexp)



%% ----------------------------------
% time dep Unitary events
%----------------------------------

% offset of shifting the sliding window
shiftWin = 1;
% sliding window width
Tslid = 20;     %100;

% calculate number of Tslids fitting in given number of bins (nbins)
nTslid = floor(1+ ((NumberOfBins-Tslid)/shiftWin));
% initialize window index matrix
winLimMat = zeros(nTslid,2);

S_arr     = zeros(nTslid,1);
nexp_arr = zeros(nTslid,1);
nemp_arr = zeros(nTslid,1);
nc1_arr  = zeros(nTslid,1);
nc2_arr  = zeros(nTslid,1);
centerBinArr = [];

siglevel = 0.05;  % percent

% raw coincidences
ccMat = [];
for jj=1:nTrials
   ccMat(:,jj) = sp1Mat(:,jj).*sp2Mat(:,jj); 
end
% initiate matrix for UE coincidences
ueMat = zeros(size(ccMat));

for ii=1:nTslid                   % sliding window loop
    %disp(['Tslid nr: ' num2str(ii)])
    % generate Tslid indices around each center bin
    winIdx = [ii*shiftWin:1:(ii*shiftWin)+Tslid-1];
    % put window index limits in matrix for plotting
    winLimMat(ii+1,:) = [ii*shiftWin,(ii*shiftWin)+Tslid-1];
    % bin index of center bin
    centerBin    = winIdx(floor(Tslid/2));
    centerBinArr = [centerBinArr, centerBin];
    
    
    
    for jj=1:nTrials
        nc1_arr(ii,jj) = sum(sp1Mat(winIdx,jj));
        nc2_arr(ii,jj) = sum(sp2Mat(winIdx,jj));
        
        nexp_arr(ii,jj) = (nc1_arr(ii,jj)/Tslid)*(nc2_arr(ii,jj)/Tslid)*Tslid;
        nemp_arr(ii,jj) = sum(sp1Mat(winIdx,jj).*sp2Mat(winIdx,jj));
    end
    
    % spike counts, all trials
    nc1sum_arr(ii,1) = sum(nc1_arr(ii,:));
    nc2sum_arr(ii,1) = sum(nc2_arr(ii,:));
    
    % sums of exp and emp, all trials
    nexpsum_arr(ii,1) = sum(nexp_arr(ii,:));
    nempsum_arr(ii,1) = sum(nemp_arr(ii,:));
    
    [S_arr(ii,1),jp_arr(ii,1)] = jointSjointP(nempsum_arr(ii,1),nexpsum_arr(ii,1));
    
    % extract UE coincidences
    if jp_arr(ii,1) <= siglevel
        disp(['here, Tslid:' num2str(jj)])
      ueMat(winIdx,:) = ccMat(winIdx,:);
    end

end

fac2rate = 1000/(nTrials*Tslid);

figure
subplot(5,1,1)

% [spike time, trial id] 
 [tic1,trc1]=find(sp1Mat);
 [tic2,trc2]=find(sp2Mat);
 
 % [cc time, trial id]
 [ticc,trcc]=find(ccMat);
 
 % ue times and trials
 [tiue,true]=find(ueMat);

 
 % dot display
 plot(tic1, trc1, '.', 'Markersize', 1)
 hold on
 plot(ticc, trcc, 'co', 'Markersize', 7)
 plot(tiue, true, 'rd', 'Markersize', 7)
 hold off

subplot(5,1,2)
plot(tic2, trc2, '.', 'Markersize', 1)
hold on
plot(ticc, trcc, 'co', 'Markersize', 7)
plot(tiue, true, 'rd', 'Markersize', 7)
hold off

subplot(5,1,3)
%plot(backgroundrate, 'k')
hold on
%plot(coincrate,'r')
plot(centerBinArr,nc1sum_arr(:,1)*fac2rate, 'g')

plot(centerBinArr,nc2sum_arr(:,1)*fac2rate, 'c')
hold off
grid on

subplot(5,1,4)

plot(centerBinArr,nexpsum_arr(:,1)*fac2rate,'b')
hold on
plot(centerBinArr,nempsum_arr(:,1)*fac2rate, 'r')
hold off
grid on

subplot(5,1,5)

plot(centerBinArr,S_arr(:,1),'k')
hold on
plot(centerBinArr, 1.2788 + zeros(size(S_arr(:,1)))','r-')
plot(centerBinArr, -1.2788 + zeros(size(S_arr(:,1)))','r-')
plot(centerBinArr, 2 + zeros(size(S_arr(:,1)))','r--')
plot(centerBinArr, -2 + zeros(size(S_arr(:,1)))','r--')
hold off
set(gca, 'Ylim', [-3 3])
grid on

end % UE
















