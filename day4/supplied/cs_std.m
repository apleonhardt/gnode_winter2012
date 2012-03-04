function output=cs_std(input)
%Calculates the circular standard deviation  of the input data.
%Definition of variance is s=sqrt(-2*log(R)), where R is the vector strength.
%
%call:    cs_std(CircularData)
%
%input:   CircularData
%           Row vector containing data samples on the circle (in rad).
%           Alternatively, can be supplied as a matrix, where the function
%           works down on columns similar to the mean function.
%
%return:  Resulting circular standard deviation if CircularData is a
%         vector, or a row vector of circular standard deviations if
%         CircularData is a matrix. If CircularData is empty, returns NaN
%         (consistent with std function).
%
%remarks: -
%
%changes: 2010-02-24 Michael Denker

error(nargchk(1,1,nargin));

if isempty(input)
    output=0;
else
    output=sqrt(-2*log(abs(sum(exp(complex(0,1)*input))./length(input)) ));
end
