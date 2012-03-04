function output=cs_mean(input)
%Calculates the circular mean of the input data.
%
%call:    cs_mean(CircularData)
%
%input:   CircularData
%           Row vector containing data samples on the circle (in rad).
%           Alternatively, can be supplied as a matrix, where the function
%           works down on columns similar to the mean function.
%
%return:  Resulting circular mean if CircularData is a vector, or a row
%         vector of circular means if CircularData is a matrix.  If
%         CircularData is empty, returns NaN (consistent with mean function).
%
%remarks: -
%
%changes: 2010-02-24 Michael Denker

error(nargchk(1,1,nargin));

if isempty(input)
    output=NaN;
else
    output=angle(sum(exp(complex(0,1)*input)));
end
