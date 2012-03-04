function PlotCCH(filename1,filename2,datatoplot,tautime,text,textylabel,datatoplot2)
% PlotCCH(filename1,filename2,datatoplot,tautime,text,textylabel,datatoplot2)
% Plots results of CalcCCH.m
% 
% (c) Sonja Gruen, 1999-2004
% 


% binning option not yet implemented

bar(tautime, datatoplot);
hold on
if ~isempty(datatoplot2)
    plot(tautime,datatoplot2,'r')
end
plot(tautime,zeros(size(tautime)), 'k--')
hold off
set(gca, 'Xlim', [-max(tautime) max(tautime)]);

xlabel('\tau (ms)')
ylabel([textylabel])

if strcmp(filename1,filename2) == 1
  title(['ACH (' text '); ' filename1 ])
  set(gca, 'Ylim', [0 max(datatoplot)/10])
else
  title(['CCH (' text '); ' filename1 ' vs ' filename2])
end
hold off
drawnow