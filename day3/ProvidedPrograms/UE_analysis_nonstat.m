function UE_analysis_nonstat(sp1Mat,fName1, sp2Mat,fName2, NumberOfBins,binwidth, nTrials,Tslid,siglevel)
% UE_analysis_nonstat(sp1Mat,sp2Mat,NumberOfBins,nTrials,Tslid,siglevel):
% - simple implementation of the UE analysis of two neurons; no multiple shift 
% implemented, no surrogates, no binning (has to be done outside) (no error
% check) 
% - !!!! please refer to the relased UE implementation for series data analysis!!!!!!!!!!
% - Makes simple plots of UE results
% 
%
%
% input:
%       sp1Mat: spike data of neuron 1 in 0-1 matrix, per trial one column
%       fName1: name of data set 1
%       sp2Mat: spike data of neuron 2 in 0-1 matrix, per trial one column 
%       fName2: name of data set 2 
%       NumberOfBins: number of bins within a trial (number of rows)
%       binwidth: binwidth in ms
%       nTrials: number of trials in the data (number of cols)
%       Tslid: size (in nr of bins) of sliding window
%       siglevel: significance level 
%       
%
% Uses: jointSjointP.m
%
% (c) Sonja Gruen 2010
%
% Example:
%
%
%




% ----------------------------------
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

disp('Result of analysis of whole data:')
[S,jp]=jointSjointP(nemp,nexp);
disp(['nexp: ' num2str(nexp)])
disp(['nemp: ' num2str(nemp)])
disp(['jp: ' num2str(jp)])
disp(['S: ' num2str(S)])




%----------------------------------
% time dep Unitary events
%----------------------------------

% offset of shifting the sliding window
shiftWin = 1;


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

% extract raw coincidences
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
      ueMat(winIdx,:) = ccMat(winIdx,:);
    end

end

fac2rate = 1000/(nTrials*Tslid*binwidth);



% [spike time, trial id] 
 [tic1,trc1]=find(sp1Mat);
 [tic2,trc2]=find(sp2Mat);
 
 % [cc time, trial id]
 [ticc,trcc]=find(ccMat);
 
 % ue times and trials
 [tiue,true]=find(ueMat);
 
 %timeaxis = centerBinArr*binwidth;
 % for testing: 
 centerBinArr = centerBinArr*binwidth; 

 figure
 set(gcf, 'Units', 'centimeters', 'Position', [1 1 20 25]);
 
 subplot(5,1,1)
 % dot display
 plot(tic1*binwidth, trc1, '.', 'Markersize', 1)
 hold on
 plot(ticc*binwidth, trcc, 'co', 'Markersize', 7)
 plot(tiue*binwidth, true, 'rd', 'Markersize', 7)
 hold off
 title(['dot display,' fName1 ' , CC (blue), UE (red)'])
 ylabel('trial id')
 set(gca, 'Xlim', [0 NumberOfBins*binwidth], 'Ylim', [0 nTrials+1])
 
subplot(5,1,2)
plot(tic2*binwidth, trc2, '.', 'Markersize', 1)
hold on
plot(ticc*binwidth, trcc, 'co', 'Markersize', 7)
plot(tiue*binwidth, true, 'rd', 'Markersize', 7)
hold off
title(['dot display,' fName2 ' , CC (blue), UE (red)'])
 ylabel('trial id')
set(gca, 'Xlim', [0 NumberOfBins*binwidth], 'Ylim', [0 nTrials+1])

subplot(5,1,3)
hold on
plot(centerBinArr,nc1sum_arr(:,1)*fac2rate, 'g')
plot(centerBinArr,nc2sum_arr(:,1)*fac2rate, 'c')
hold off
grid on
ylabel('rate (Hz)')
title(['Firing rates, ' fName1 ' (green), ' fName2 ' (cyan)'])
set(gca, 'Xlim', [0 NumberOfBins*binwidth])

subplot(5,1,4)
plot(centerBinArr,nexpsum_arr(:,1)*fac2rate,'b')
hold on
plot(centerBinArr,nempsum_arr(:,1)*fac2rate, 'r')
hold off
grid on
ylabel('# coinc')
title(['n_{exp} (blue), n_{emp} (red)'])
set(gca, 'Xlim', [0 NumberOfBins*binwidth])

subplot(5,1,5)

plot(centerBinArr,S_arr(:,1),'k')
hold on
plot(centerBinArr, 1.2788 + zeros(size(S_arr(:,1)))','r.', 'Markersize',1)
plot(centerBinArr, -1.2788 + zeros(size(S_arr(:,1)))','r.', 'Markersize', 1)
plot(centerBinArr, 2 + zeros(size(S_arr(:,1)))','r--')
plot(centerBinArr, -2 + zeros(size(S_arr(:,1)))','r--')
hold off
set(gca, 'Ylim', [-3 3])
grid on
xlabel('time (ms)')
ylabel('S')
title('Significance')
set(gca, 'Xlim', [0 NumberOfBins*binwidth])















