function ConvertGdf2Gdf()

load winny131_235.gdf;
% to be used by JPST
% ScriptReadCutGdf('winny131_235',[2,3],124,-1800,300,1,'Data14','Data15')


data = winny131_235;

data2 = data(find(data(:,1)==2),:);
data2(:,1) = 22;
data3 = data(find(data(:,1)==3),:);
data114 = data(find(data(:,1)==114),:);

concatdata = [data2; data3; data114];

[dtmp,idx] = sort(concatdata(:,2));

data = concatdata(idx,:);

save('winny131_23part.gdf', 'data', '-ascii')


