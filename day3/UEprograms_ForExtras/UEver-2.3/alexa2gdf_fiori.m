function [mat,n_list,n_trial] = alexa2gdf(file_arr,trial_type,output_file)
% origin: alexa2gdf(file_arr, trial_type), coversion from Alexas format to gdf
% transformed for Fiori Data in alexa2gdf_fiori 	AR  22.8.97
% ***************************************************************
% *                                                             *
% * Usage:                                                      *
% *        file_arr:	array of strings of the spike filenames *
% *			to be put together into gdf format	*
% *								*
% *        trial_type:	optional, default all trials (no error	*
% *			code yet in the file			*
% *                     or: give type of trial, e.g. correct	*
% *			    trials are of trial_type 7		*
% *			if output_file given, it has to be	*
% *			given, at least as an 			*
% *			empty array=all files 			*
% *                                                             *
% *	   output_file: optional; if not given, then the	*
% *			behaviorfilename is taken; both		*
% *			with extension .gdf			*
% *								*
% *        input data: the structure of the data in the 	*
% *			 spike files (to be read): 		*
% *			per row one trial, time (in 0.1ms)	*
% *			starts from 0 in each trial		*
% *								*
% *		       the corresponding behavior file will	*
% *			be read automatically. It contains	*
% *			11 cols, which contain per trial (along the col)
% *			1. trialnr				*
% *			2. correct / error trial		*
% *			   7=correct, 5=no response, and more	* 
% *	Fiori:		3. type of trial: 1 - 42		*
% *			 	corresponds to the 6 movement directions
% *				in combination with prior information
% *				see trialtypes_Fiori.txt for types
% *			4. - 10. times (in 0.1 ms from start of trial)
% *			4. pre delay (time between end of last  *
% *			   trial and initiation of new trial)	*
% *		 	5. PS					*
% *			6. RS					*
% *			7. RT					*
% *			8. MT					*
% *			9. RW (Reward)				*
% *		 	10.ET (end of trial)			*
% *			11. number of spikes (Which???)		*
% *								*
% *                                                  		*
% *                                                             *
% *        output data: > optional:				*
% *			 mat	:   first col  : event ids	*
% *				    second col : time (in ms)	*
% *			 n_list  : list of neuron id in mat	*
% *			 n_trial : number of trials included	* 
% *                                           			*
% *          		> file of name behaviorfilename.gdf	*
% *			  or of the given output_file.gdf	*
% *			  containing  the gdf-matrix		*
% *								*
% *		event codes: 					*
% *		0-6 : neuron id					*
% *        							*
% *    modification for Fiori:     AR,   22.8.1997		*
% *     Monkey : joe                                            *
% *	       in mvt direction: 1    2    3    4    5    6	*
% *	700 : ST (correct)	701, 702, 703, 704, 705, 706	*
% *	500 : ST (error =5)	501, 502, 503, 504, 505, 506	*
% *	1000: ST (if no selec) 1001,1002,1003,1004,1005,1006	*
% *	11  : PS		111, 112, 113, 114, 115, 116	*
% *	12  : RS		121, 122, 123, 124, 125, 126	*
% *	13  : RT		131, 132, 133, 134, 135, 136	*
% *	14  : MT		141, 142, 143, 144, 145, 146	*
% *	19  : RW		191, 192, 193, 194, 195, 196	*
% *	20  : ET		201, 202, 203, 204, 205, 206	*
% *								*
% *                                                             *
% * See Also:                                                   *
% *       read_gdf.m		                                *
% *                                                             *
% * Uses:                                                       *
% *       copy()		                                *
% *                                                             *
% * History:                                                    *
% *	    (1) modified version for Fiori data			*
% *		AR, 22.8.1997
% *         (0) first version                                   *
% *            SG, 10.3.1997                                    * 
% *                                                             *
% *                                                             *
% *                          diesmann@biologie.uni-freiburg.de  *
% *                          gruen@hbf.huji.ac.il               *
% *                                                             *
% ***************************************************************

% ***************************************************************
% * example:  Fiori Data
% *
% * gdf_mat = alexa2gdf_fiori(['joe1053';'joe1054';'joe1057'], 7, 'joe105-347')
% *
% ***************************************************************

disp('alexa2gdf ...');

if nargin == 0
 disp('Give input parameters: '),
 disp(' array of filenames, type of trial (optional), output filename (optional)');
 return
end
         
num_str	= size(file_arr);
n_files	= num_str(1);
name_len= num_str(2);

N_NEURON	= n_files;
NEURON_LIST	= [];

filename = file_arr(1,:);
behaviorfilename = filename(1:name_len-1);
thedirectory = '/home/gruen/Data/Papst/';	% change directory if necessary
eval(['load ' thedirectory behaviorfilename ]); 	% matrix N
 behavior=N; clear N;

% ***********************************************
% *						*
% * take only the selected trials		*
% * default: take all				*
% *						*
% ***********************************************

if nargin == 1
 IDX_SEL_TRIAL 	= find(behavior(:,2));
 disp('... taking all trials ...');	
elseif nargin > 1
 if isempty(trial_type)
  IDX_SEL_TRIAL = find(behavior(:,2)); 
  disp('... taking all trials ...');
 else
  IDX_SEL_TRIAL = find(behavior(:,2)==trial_type); 
  disp(['...taking trials of type ' int2str(trial_type)]);
 end
end

N_SEL_TRIAL   	= length(IDX_SEL_TRIAL);


% ***********************************************
% *						*
% * find type of PS-RS stimulus configuration  	*
% * movement direction   1 - 6			*
% *						*
% ***********************************************


	if any(behavior(:,3)==1)		% complete infomation
		stimulusconf=1:6;
	elseif any(behavior(:,3) ==7)		% no information
		stimulusconf=7:12;
	elseif any(behavior(:,3) ==13)		% two target information
		stimulusconf=[13 14 17 18 21 22];
	elseif any(behavior(:,3) ==15)		% two target information
		stimulusconf=[24 15 16 19 20 23];
	elseif any(behavior(:,3) ==25)		% three target information
		stimulusconf=[25 26 27 34 35 36];
	elseif any(behavior(:,3) ==28)		% three target information
		stimulusconf=[39 28 29 30 37 38];
	elseif any(behavior(:,3) ==31)		% three target information
		stimulusconf=[41 42 31 32 33 40];
	end 	



% ***********************************************
% *						*
% * define IDs for different movement directions*
% * independent of PS-RS stimulus configuration	*
% *						*
% ***********************************************

% make trial start dependent on the selection - correct/error
% here now only correct ones

if trial_type == 7
 TYPES_ST_ID	= [701,702,703,704,705,706];
 Start_ID	= 700 ;
elseif trial_type == 5
 TYPES_ST_ID	= [501,502,503,504,505,506];
 Start_ID	= 500;
else
 TYPES_ST_ID	= [1001,1002,1003,1004,1005,1006];
 Start_ID	= 1000;
end

TYPES_PS_ID	= [111,112,113,114,115,116];
TYPES_RS_ID	= [121,122,123,124,125,126];
TYPES_RT_ID	= [131,132,133,134,135,136];
TYPES_MT_ID	= [141,142,143,144,145,146];
TYPES_RW_ID	= [191,192,193,194,195,196];
TYPES_ET_ID	= [201,202,203,204,205,206];

ST_ID		= zeros(size(behavior(:,3)));
PS_ID		= zeros(size(behavior(:,3)));
RS_ID		= zeros(size(behavior(:,3)));
RT_ID		= zeros(size(behavior(:,3)));
MT_ID		= zeros(size(behavior(:,3)));
RW_ID		= zeros(size(behavior(:,3)));
ET_ID		= zeros(size(behavior(:,3)));

for i=1:6
 tmp_PS_idx	= find(behavior(:,3)==stimulusconf(i));
 ST_ID(tmp_PS_idx)= copy(TYPES_ST_ID(i),1,length(tmp_PS_idx));
 PS_ID(tmp_PS_idx)= copy(TYPES_PS_ID(i),1,length(tmp_PS_idx));
 RS_ID(tmp_PS_idx)= copy(TYPES_RS_ID(i),1,length(tmp_PS_idx));
 RT_ID(tmp_PS_idx)= copy(TYPES_RT_ID(i),1,length(tmp_PS_idx));
 MT_ID(tmp_PS_idx)= copy(TYPES_MT_ID(i),1,length(tmp_PS_idx));
 RW_ID(tmp_PS_idx)= copy(TYPES_RW_ID(i),1,length(tmp_PS_idx));
 ET_ID(tmp_PS_idx)= copy(TYPES_ET_ID(i),1,length(tmp_PS_idx));
 clear tmp_PS_idx;
end

% ***********************************************
% *						*
% * Calculate cumulative times of		* 
% *  start of trial and end of trial		*
% *						*
% ***********************************************

CUM_T_ST  	= cumsum(behavior(IDX_SEL_TRIAL,4));
CUM_T_ET	= cumsum(behavior(IDX_SEL_TRIAL,10));
CUM_T		= CUM_T_ST + [0;CUM_T_ET(1:length(CUM_T_ET)-1)];


%
% initialize gdf_mat as row matrix
% do avoid multiple transforms
%
gdf_mat = zeros(2,10);
last = 1;

% ************************************************
% ************************************************
% *						**
% * looping over files == neurons		** 
% *						**
% ************************************************
% ************************************************

for i=1:n_files

 filename = file_arr(i,:);
 eval(['load ' thedirectory filename]);		% matrix spi1s
 NEURON_LIST(i) = eval(filename(name_len)); 
 
 disp(['...putting data of ' filename ' into gdf_mat ']);

 % ***********************************************
 % *						*
 % * loop over trials				* 
 % *						*
 % ***********************************************

 for j=1:N_SEL_TRIAL

  % *********************************************
  % *						*
  % *  find index where spikes are		*
  % *						*
  % *********************************************

    ii = find(spi1s(IDX_SEL_TRIAL(j),:));


  % *********************************************
  % *						*
  % *  put spike times with trial offset	*
  % *						*
  % *********************************************


   % disp ('putting spikes in gdf_mat ...');

    gdf_mat(2,last:last+length(ii)-1) = ...
		 spi1s(IDX_SEL_TRIAL(j),ii) + ...
			     CUM_T(j);

  % *********************************************
  % *						*
  % *  put neuron id, taken from last string	*
  % *	of filename				*
  % *						*
  % *********************************************

   % disp(' putting neuron id in gdf_mat ...');

    gdf_mat(1,last:last+length(ii)-1) = ...
     copy(eval(filename(name_len)),1,length(ii));


 % **********************************************
 % *						*
 % * update index of last event			*
 % *						*
 % **********************************************

 last = last+length(ii);




 % ************************************************
 % *						**
 % * putting behavioral events:			**
 % *  during the trials ONLY of the last file	** 
 % *						**
 % ************************************************

 if i == n_files


  % ***********************************************
  % *						*
  % *  put ST (start of trial)			*
  % *						*
  % ***********************************************


   % disp (' putting trial start ids ...');
    
    gdf_mat(2,last) = CUM_T(j);
    gdf_mat(1,last) = Start_ID;

    last = last + 1;

  % ***********************************************
  % *						*
  % *  put start of trial with ID with type of PP	*
  % *						*
  % ***********************************************

    gdf_mat(2,last) = CUM_T(j); 
    gdf_mat(1,last) = ST_ID(IDX_SEL_TRIAL(j));

    last = last + 1;
  
  % ***********************************************
  % *						*
  % *  put PS with ID=11			*
  % *						*
  % ***********************************************

   % disp (' putting PS in gdf_mat ...');

    gdf_mat(2,last) = ...
		behavior(IDX_SEL_TRIAL(j),5)+ ...
				 CUM_T(j);
    gdf_mat(1,last) = 11;

    last = last + 1;
 
  % ***********************************************
  % *						*
  % *  put PS with ID with type of PP		*
  % *						*
  % ***********************************************

    gdf_mat(2,last) = ...
		behavior(IDX_SEL_TRIAL(j),5)+ ...
				 CUM_T(j); 

    gdf_mat(1,last) = PS_ID(IDX_SEL_TRIAL(j));

    last = last + 1;

  % ***********************************************
  % *						*
  % *  put RS with ID=12			*
  % *						*
  % ***********************************************

   % disp(' putting RS in gdf_mat ...');

    gdf_mat(2,last) = behavior(IDX_SEL_TRIAL(j),6)+ ...
				 CUM_T(j);
    gdf_mat(1,last) = 12;

    last = last + 1;

  % ***********************************************
  % *						*
  % *  put RS with ID with type of PP		*
  % *						*
  % ***********************************************

    gdf_mat(2,last) = behavior(IDX_SEL_TRIAL(j),6)+ ...
				 CUM_T(j);

    gdf_mat(1,last) = RS_ID(IDX_SEL_TRIAL(j));

    last = last + 1;

  % ***********************************************
  % *						*
  % *  put RT with ID=13			*
  % *						*
  % ***********************************************

   % disp(' putting RT in gdf_mat ...');

    gdf_mat(2,last) = behavior(IDX_SEL_TRIAL(j),7)+ ...
				 CUM_T(j);
    gdf_mat(1,last) = 13;
      
    last = last + 1;

  % ***********************************************
  % *						*
  % *  put RT with ID with type of PP		*
  % *						*
  % ***********************************************

    gdf_mat(2,last) = behavior(IDX_SEL_TRIAL(j),7)+ ...
				 CUM_T(j);

    gdf_mat(1,last) = RT_ID(IDX_SEL_TRIAL(j));
    
    last = last + 1;

  % ***********************************************
  % *						*
  % *  put MT with ID=14			*
  % *						*
  % ***********************************************

   % disp(' putting MT in gdf_mat ...');

    gdf_mat(2,last) = behavior(IDX_SEL_TRIAL(j),8)+ ...
				 CUM_T(j);
    gdf_mat(1,last) = 14;

    last = last + 1;

  % ***********************************************
  % *						*
  % *  put MT with ID with type of PP		*
  % *						*
  % ***********************************************

    gdf_mat(2,last) = behavior(IDX_SEL_TRIAL(j),8)+ ...
				 CUM_T(j);
    gdf_mat(1,last) = MT_ID(IDX_SEL_TRIAL(j));

    last = last + 1;

  % ***********************************************
  % *						*
  % *  put reward (RW) with ID=19 		*
  % *						*
  % ***********************************************

   % disp(' putting RW in gdf_mat ...');

    gdf_mat(2,last) = behavior(IDX_SEL_TRIAL(j),9)+ ...
				CUM_T(j);
    gdf_mat(1,last) = 19;

    last = last + 1;

  % ***********************************************
  % *						*
  % *  put reward with ID with type of PP	*
  % *						*
  % ***********************************************
    
    gdf_mat(2,last) = behavior(IDX_SEL_TRIAL(j),9)+ ...
				 CUM_T(j);

    gdf_mat(1,last) = RW_ID(IDX_SEL_TRIAL(j));

    last = last + 1;

  % ***********************************************
  % *						*
  % *  put end of trial (ET) with ID=20 	*
  % *						*
  % ***********************************************

   % disp(' putting ET in gdf_mat ...');

    gdf_mat(2,last) = behavior(IDX_SEL_TRIAL(j),10)+ ...
				CUM_T(j);
    gdf_mat(1,last) = 20;

    last = last + 1;

  % ***********************************************
  % *						*
  % *  put end of trial  with ID of type of PP	*
  % *						*
  % ***********************************************
    
    gdf_mat(2,last) = behavior(IDX_SEL_TRIAL(j),10)+ ...
				 CUM_T(j);

    gdf_mat(1,last) = ET_ID(IDX_SEL_TRIAL(j));

    last = last + 1;




  end		% if i == n_files 

 end		% of trial loop

end		% of file loop



% ***********************************************
% *						*
% * convert to 1 ms resolution:			*
% *  original data are in 0.1ms			*
% *						*
% ***********************************************

  gdf_mat(2,:)= gdf_mat(2,:)*0.1;		


% ***********************************************
% *						*
% * sort according to the time			*
% *						*
% ***********************************************

 [time_sort, idx_sort] = sort(gdf_mat(2,:));
 gdf_mat  = floor(gdf_mat(:,idx_sort));



% ***********************************************
% *						*
% * write to file: behaviorfilename.gdf		*
% *	 					*
% ***********************************************

 if nargin == 3
  write_name = [output_file '.gdf'];
 else
  write_name = [behaviorfilename '.gdf'];
 end

 disp(['...writing gdf data to file ' write_name]); 
% fid=fopen(write_name, 'w');
 fid=fopen(['/home/gruen/Data/Papst/' write_name], 'w');
 fprintf(fid, '%12d %12d\n', gdf_mat);
 fclose(fid);
 disp([' file closed ']);


% ***********************************************
% *						*
% * 	generate output matrix			*
% *	 					*
% ***********************************************


if nargout == 1
  mat = gdf_mat';
elseif nargout == 2
 mat 	= gdf_mat';
 n_list = NEURON_LIST;
elseif nargout == 3
 mat 	= gdf_mat';
 n_list = NEURON_LIST;
 n_trial= N_SEL_TRIAL;
end

clear;

%------------------------------------------------------------------
% end
%------------------------------------------------------------------


