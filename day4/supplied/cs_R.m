function output=cs_R(input)
%Calculates the vector strength of a vector of circular data.
%
%call:    cs_R(CircularData)
%
%input:   CircularData
%           Row vector containing data samples on the circle (in rad).
%           Alternatively, can be supplied as a matrix, where the function
%           works down on columns similar to the mean function.
%
%return:  Resulting vector strength if CircularData is a vector, or a row
%         vector of vector strengths if CircularData is a matrix.  If
%         CircularData is empty, returns NaN.
%
%remarks: -
%
%changes: 2010-02-24 Michael Denker

error(nargchk(1,1,nargin));

if isempty(input)
    output=NaN;
else
    output=abs(sum(exp(complex(0,1)*input)))/length(input);
end
