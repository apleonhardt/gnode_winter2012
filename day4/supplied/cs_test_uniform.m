function output=cs_test_uniform(input)
%Tests for the null hypothesis that a given angular input sample
%originates from a uniform distribution assuming that the mean of the
%distribution is not known.
%
%call:    cs_test_uniform(Input)
%
%input:   Input
%           Input distribution vector of angular data (in rad).
%
%return:  p-value for the test of the null hypothesis that the distribution
%         is uniformly distributed. For p<alpha, the null hypothesis must be
%         rejected (alpha = significance level).
%
%remarks: - Uses the correction for small sample sizes given by Mardia and Jupp.
%         - Returns 1 for if Input has less than two elements.
%
%changes: 2010-02-24 Michael Denker

error(nargchk(1,1,nargin));

if length(input)<1
    error('cs_test_uniform: Insufficient input data.');
end

n=length(input);

r=abs(sum(exp(complex(0,1)*input)))./length(input);

%calculate 2nR^2 - standard
%S=2*n*r^2;

%calculate (1-1/(2n))*2*n*R^2+nR^4/2
%see Mardia Jupp, good for small sample size, p. 95
S=(1-1/(2*n))*2*n*r^2+n*r^4/2;

%for n=1, the test cannot become significant
output=1-chi2cdf(S,2);
