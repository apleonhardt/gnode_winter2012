function [l]=EX_dotdisplay(data,TimeUnitsMS)
% [l]=EX_dotdisplay(data,TimeUnitsMS)
%
% input 
% data  :   full 0/1 spike matrix with dimensions rows x cols: 
%           time x trial OR time x channel
% TimeUnitsMS   :   resoluton of spike matrix relative to milliseconds MS   
%
% output   
% l     :   array of line handles; use l to set line specs such as color
%
%
% assumes: figure open, axes defined
%
% c Martin Nawrot
%

t=(1:size(data,1))*TimeUnitsMS;
Tmax=size(data,1)*TimeUnitsMS;
n=size(data,2);


set(gca,'ylim',[0.5 n+0.5])
set(gca,'xlim',[0 Tmax])
set(gca,'box','on')
ylabel('Trials')
xlabel('Time (ms)')
hold on

[x,y]=find(data);
l=line([x x]',[y-.25 y+.25]','color','k','linewidth',0.5);
