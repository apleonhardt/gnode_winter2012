function output=cs_var(input)
%Calculates the circular variance of the input data.
%Definition of variance is S=1-R, where R is the vector strength.
%
%call:    cs_var(CircularData)
%
%input:   CircularData
%           Row vector containing data samples on the circle (in rad).
%           Alternatively, can be supplied as a matrix, where the function
%           works down on columns similar to the mean function.
%
%return:  Resulting circular variance if CircularData is a vector, or a row
%         vector of circular variances if CircularData is a matrix.  If
%         CircularData is empty, returns NaN (consistent with var function).
%
%remarks: -
%
%changes: 2010-02-24 Michael Denker

error(nargchk(1,1,nargin));

if isempty(input)
    output=NaN;
else
    output=1-abs(sum(exp(complex(0,1)*input))./length(input));
end
