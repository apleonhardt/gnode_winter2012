function y=vonMise(A,x)
%A normalized von Mise distribution.
%
%call:    y=vonMise(A,x)
%
%input:   A
%           a 1x2 vector, where A(1) is the parameter kappa (analogous to 1/standard 
%           deviation) and A(2) is the parameter a (peak position) of the von Mise
%           distribution 
%                   P(x)=(e^(kappa cos(x-a)))/(2piI_0(kappa))
%         x
%           x value(s).
%
%return:  y value of the von Mise ditribution for each element of x.
%
%remarks: - cf. mathworld.wolfram.com
%
%changes: 2010-02-24 Michael Denker


y=exp(A(2)*cos(x-A(1)))/2/pi/besselj(0,A(2));

y=y./sum(y);
