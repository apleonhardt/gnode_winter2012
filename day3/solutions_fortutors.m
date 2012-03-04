%% Solutions for Exercises of Gnode course 2012
% Excercises on Analysis of spike correlation in multi-channel recordings
% (3rd day)
% Sonja Gruen, March 2012
%
%
% set in Matlab the path to data and programs
% ./ProgramsSG
% ./Data
 
% --------------------------------
% The following matlab functions are provided to the students 
% to accelerate the exercises. 
%
% LoadData_Gnode.m:  load provided data sets 
% convert2bin.m:     convert a spike train given by a list 
%                    of spike times into a binned spike train 
% jointSjointP.m:    calculates the joint-p and joint-surprise 
%                    value needed in UE analysis
%

%--------------------
% select data sets
for jjj=1:9 % to analyze all data sets

if jjj==1
fName1 = 'Data5';
fName2 = 'Data6';
bin = 1;
Tslid = 100/bin; % total time: bin width*Tslid
end
if jjj==2
fName1 = 'Data5';
fName2 = 'Data6';
bin = 5;
Tslid = 100/bin; % total time: bin width*Tslid
end

if jjj==3
fName1 = 'Data7';
fName2 = 'Data8';
bin = 1;
Tslid = 100/bin; % total time: bin width*Tslid
end

if jjj==4
fName1 = 'Data12';
fName2 = 'Data13';
bin = 5;
Tslid = 100/bin; % total time: bin width*Tslid
end

if jjj==5
fName1 = 'Data14';
fName2 = 'Data15';
bin = 5;
Tslid = 100/bin; % total time: bin width*Tslid
end

if jjj==6
fName1 = 'Data23';
fName2 = 'Data24';
bin = 1;
Tslid = 100/bin; % total time: bin width*Tslid
end

if jjj==7
fName1 = 'Data20';
fName2 = 'Data21';
bin = 5;
Tslid = 100/bin; % total time: bin width*Tslid
end
if jjj==8
fName1 = 'Data20';
fName2 = 'Data22';
bin = 5;
Tslid = 100/bin; % total time: bin width*Tslid
end
if jjj==9
fName1 = 'Data21';
fName2 = 'Data22';
bin = 5;
Tslid = 100/bin; % total time: bin width*Tslid
end



% -----------------------------
[sptimes1,trialids1,ntrials1,T1]=LoadData_Gnode(fName1);
[sptimes2,trialids2,ntrials2,T2]=LoadData_Gnode(fName2);

if bin > 1
  % bin the data
  start = 0;
  stop=T1;
  clip =1;
    
  sp1Mat = [];
  sp2Mat = [];
  for ii=1:ntrials1
    tmpidx1 = find(trialids1 == ii);
    tmpout1=convert2bin(sptimes1(tmpidx1),start,stop,bin,clip);
    sp1Mat(:,ii) = tmpout1';
    
    tmpidx2 = find(trialids2 == ii);
    tmpout2=convert2bin(sptimes2(tmpidx2),start,stop,bin,clip);
    sp2Mat(:,ii) = tmpout2';
    
    clear tmpidx1 tmpidx2 tmpout1 tmpout2;
  end
  T1 = size(sp1Mat,1);
elseif bin ==1
    
    [sp1Mat,nbins,ntr] = Convert2ZeroOneMat(sptimes1,trialids1,T1,ntrials1);
    [sp2Mat,nbins,ntr] = Convert2ZeroOneMat(sptimes2,trialids2,T2,ntrials2);
    
end

 
  NumberOfBins = T1;
  nTrials = ntrials1;

%---------------------------------
% Basic single neuron analysis 
%
% @Tutors: 
%  
MakeAnalysisSingleNeuron(fName1)
MakeAnalysisSingleNeuron(fName2)

%----------------------------------
% Cross-correlogram:
% @Tutors: 
% students are supposed to implement the cross-correlation
% 
% Solution: see code in MakeCCH.m
%
MakeCCH(fName1, fName2, 50, 'rawpred')


%----------------------------------
% Unitary Event Analysis
%
% @Tutors: 
% students are supposed to implement the UE analysis.
%
% Solution: see code in UE_analysis_nonstat.m
% 
%Tslid = 100/bin; % total time: bin width*Tslid
siglevel = 0.05; % significance level
UE_analysis_nonstat(sp1Mat,fName1, sp2Mat,fName2, NumberOfBins,bin, nTrials,Tslid,siglevel);

end

%==========================================================================
% 
% Data also used in NWG-BCF course 'Analysis and Models
% in Neurophysiology', Exercises 
% 'Spike Trains And Correlation Measures' by Sonja Gruen (2003-2012)
%
%
% Filename & format & \# bins (ms) & comment \\
% ----------------
% Comment: joe153, no peak in CCH, but at one moment in time: 
% excess sync for bin=5
% Data5 & [sp tr] & 1801 & joe153, n1
% Data6 & [sp tr] & 1801 & joe153, n3
% ----------------
% comment: same rate profile as joe153, simulated indep data, 
% deviates from Poisson
% Data7 & [sp tr] & 1801 & g=7, joe153, n1, joe153OrigSim.eps\\
% Data8 & [sp tr] & 1801 & g=7, joe153, n3, , joe153OrigSim.eps\\
% ---------------
% comment: joe163, shows also in average sign # of coinc, but modulation of synch
% Data12 & [sp tr] & 1401 & joe163, n1, monkey data,  \\
% Data13 & [sp tr] & 1401 & joe163, n2, mokey data \\
%
% ---------------
% (see figure 1 in Riehle et al, 1997)
% Data14 & [sp tr] & 2101 & winny131_235 monkey data, n2\\
% Data15 & [sp tr] & 2101 & winny131_235 monkey data, n3\\
% 
% ---------------
% Comment: first analyze all pairs, then all three with UE; 
% play with binwidth (broader peak in CCH) 
% and the sliding window width
% (rate function: TheorRateFunctionData4.eps)
% Data20 & [sp tr] & 1751 & data14, n401\\
% Data21 & [sp tr] & 1751 & data14, n305\\
% Data22 & [sp tr] & 1751 & data14, n502\\
%
% ---------------
% comment: what whould happen if the oscillation not locked to trial 
% onset? -> expected number of coincidendes would need to be estimated
% on a trial-by-trial basis to avoid FPs! 
% (generating program: Nonstat.m)
% Data23 & [sp tr] & 1000 & ./Nonstat/Data23.eps, osci\\
% Data24 & [sp tr] & 1000 & ./Nonstat/Data24.eps, osci\\
%
%

