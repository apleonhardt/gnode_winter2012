function [M2,edges,b] = EX_psth(data,TimeUnitsMS,BinSizeMS)
% [b] = EX_psth(data,TimeUnitsMS,BinSizeMS)
%
%
% input
%  data    :   n x 1 array of 0/1 spike data
%
% output
%   b   :   handle for bar plot
%
%
% nawrot@neurobiologie.fu-berlin.de

% max time
Tmax=size(data,1)*TimeUnitsMS;
% number of trials
n=size(data,2);
% bin size in orignal time res
bin=floor(BinSizeMS/TimeUnitsMS);
% define histogram borders (left edges)
edges=0:bin:floor(Tmax/bin)*bin-bin;

% make histogram
M=sum(data(1:floor(Tmax/bin)*bin,:),2)/n;
M2=sum(reshape(M,bin,size(M,1)/bin),1);
% normalize hitogram to rate
M2=M2/BinSizeMS*1000;

% plot histogram
set(gca,'ylim',[0 ceil(max(M2)/10)*10])
set(gca,'xlim',[0 Tmax])
set(gca,'box','on')
ylabel('Rate  (1/s)')
xlabel('Time (ms)')
hold on
b=bar(edges,M2,'histc')
set(b,'edgecolor',[.7 .7 .7],'facecolor',[.7 .7 .7])
set(gca,'layer','top')

