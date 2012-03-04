function [sptimes,trialids,ntrials,T]=LoadData_Gnode(filename)
% [sptimes,trialids,ntrials,T]=LoadData(filename)
% Program to read data files in mat-format that contain
% one, required variable 'sptrmat'
% that contains two columns, 
% the first contains spike times in trial (in ms) 
% the second the corresponding trial ids
% e.g. 
% sptrmat([1:10 60:70],:)
% ans =
%     17     1
%     41     1
%     64     1
%     80     1
%    105     1
%    190     1
%    195     1
%    219     1
%    220     1
%    227     1
%    882     1
%     31     2
%     47     2
%     61     2
%     93     2
%    121     2
%    223     2
%    227     2
%    236     2
%    243     2
%    258     2
%
% output:
%   sptimes : column vector with spike times in ms,
%             in each trial the spike time starts at
%             0ms again;
%             length of vector corresponds to the total
%             number of spikes in all trials.
%   trialids: column vector with trial ids of the
%             spike times given in sptimes; same length.
%   ntrials : number of trials
%         T : trial duration in ms
%
%
% Uses : [sptimes,trialids, ntrials] = Convert2SpTr(filename);
%
%
%
%
% (c) SG, 1999-2004
%  updated for NWG-course 2004
%  29./30.Sept 2004
%
%**************************************************************************



switch filename
     case {'Data0' 'Data1','Data2','Data3'}
        %******************************************************************
        %
        % various simulated non-stationarities
        % Data1, Data2, Data3   : T = 1000;
        %
        %******************************************************************
      
        eval(['load ' filename]);
        T        = 1000; % in ms
        sptimes  = sptrmat(:,1);     % in ms
        trialids = sptrmat(:,2);
        ntrials  = max(sptrmat(:,2));
        
    case {'Data4'}
        %******************************************************************
        %
        % theoretical rate curve
        % Data4 : T = 2000;
        %
        %******************************************************************
        
        eval(['load ' filename]);
        T        = 2000; % in ms 
        sptimes  = sptrmat(:,1);     % in ms
        trialids = sptrmat(:,2);
        ntrials  = max(sptrmat(:,2));
        
    case {'Data5','Data6','Data7','Data8','Data9','Data10','Data11'} 
        %******************************************************************
        %
        % Gamma data: joe153
        % Data5, Data6          : T = 1801;
        % Gamma data, simul (rate as joe153)
        % Data7, Data8          : T = 1801;
        % Gamma data, simul, stationary:
        % Data9, Data10, Data11: T = 1801;
        %
        %******************************************************************
       
        eval(['load ' filename]);
        T        = 1801;
        sptimes  = sptrmat(:,1);     % in ms
        trialids = sptrmat(:,2);
        ntrials  = max(sptrmat(:,2));
        
    case {'Data12','Data13'}
        
        %******************************************************************
        %
        % data: joe163
        %        
        % Data12 and Data13 contain each the spiking activity 
        % of one neuron, but both were recorded in parallel !
        %     
        % Data12, Data13        : T = 1401;
        %
        %******************************************************************
        
        [sptimes,trialids, ntrials] = Convert2SpTr(filename);
        T = 1401;
        
    case {'Data14','Data15'}
        
        % ********************************************************************
        %         
        % data: winny131_235
        %
        % Data14 and Data15 contain each the spiking activity 
        % of one neuron, but both were recorded in parallel !
        %     
        %
        % coverted from gdf to a matrix containing spiketimes conversion
        % by:
        %
        % ScriptReadCutGdf('winny131_235',[2,3],124,-1800,300,1,'Data14','Data15')
        %  in /home/gruen/teaching/NWGcourse03/TrialConcept/GDF2SpiketimeTrialid
        % T= 2101
        %
        % ********************************************************************
        
        
        eval(['load ' filename]);
        sptimes  = sptrmat(:,1);     % in ms
        trialids = sptrmat(:,2);
        ntrials  = max(sptrmat(:,2));
        T        = 2101;
        
    case {'Data16','Data17'}
                
        % *****************************************************************
        % Simulated data!
        % Data16 and Data17 contain each the spiking activity 
        % of one neuron, but both were recorded in parallel 
        %
        % ScriptReadCutGdf('data12_n401_n305',[401,305],703,-150,1100,1,'Data16','Data17'); 
        % T=1251;
        % load data12_n401_n305.gdf
        % data12_n401_n305(find(data12_n401_n305==401))=4
        % data12_n401_n305(find(data12_n401_n305==305))=3
        % save -ascii data12_n4_n3.gdf data12_n401_n305
        % now: data12_n4_n3.gdf with neuronids: 4,3 
        %******************************************************************
        
        eval(['load ' filename]);
        sptimes  = sptrmat(:,1);     % in ms
        trialids = sptrmat(:,2);
        ntrials  = max(sptrmat(:,2));
        T        = 1251;
        
    case {'Data18','Data19','Data20','Data21','Data22'}
                
        %******************************************************************
        % Simulated data!
        %
        % Data18 and Data19 contain each the spiking activity 
        % of one neuron, but both were recorded in parallel 
        %
        % ScriptReadCutGdf('data13_n401_n305',[401,305],703,-150,1600,1,'Data18','Data19'); % T=1751;
        % now: data13_n4_n3.gdf with neuronids: 4,3
        %******************************************************************
        
        
        %******************************************************************
        % Simulated data!
        %
        % Data20, Data21, Data22 contain each the spiking activity 
        % of one neuron, but all three were recorded in parallel 
        %
        % ScriptReadCutGdf('data14',[401,305],703,-150,1600,1,'Data20','Data21');  
        % T=1751;
        % ScriptReadCutGdf('data14',[305,502],703,-150,1600,1,'Data21','Data22');  
        % T=1751;
        % now data14new.gdf, with neuron ids 4,3,5
        %******************************************************************
        
        eval(['load ' filename]);
        sptimes  = sptrmat(:,1);     % in ms
        trialids = sptrmat(:,2);
        ntrials  = max(sptrmat(:,2));
        T        = 1751;
        
    case {'Data23','Data24'}
        %******************************************************************
        %
        % osci data
        % Data23, Data24        : T = 1000;
        %
        %******************************************************************
        
        T = 1000;
        [sptimes,trialids, ntrials] = Convert2SpTr(filename);
    
    otherwise
        indicator = findstr(filename, 'Neuron');

        if indicator == 1  % new data files, generated in Nonstat_Gnode.m
          eval(['load ' filename]);
          disp(filename)
          sptimes  = sptrmat(:,1);     % in ms
          trialids = sptrmat(:,2);
          
          keyboard
          % ntrials: contained in file
          % T : contained in file
          % e.g. save Neuron3.mat sptrmat T nTrials;
        end    
        
end

