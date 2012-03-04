function output=create_sine(tlength,srate,f,a,p)
%Creates sine signals of a specific frequency and amplitude.
%The phase of each trial can be specified, or random.
%
%call:    create_sine(Length,SamplingRate,Freq,Amp,*Phase)
%
%input:   Length
%           Length of signal in ms (floored compared to sample rate).
%         SamplingRate
%           Sampling rate of the signal.
%         Freq
%           Frequency of the sine wave in Hz.
%         Amplitude
%           Amplitude term of sine.
%         Phase = []
%           Relative phase of signal with respect to 0. If left empty, phases
%           are randomly chosen from a uniform distribution.
%
%return:  Vector with the resulting sine waveform.
%
%remarks: - 
%
%changes: 2010-02-24 Michael Denker

error(nargchk(4,5,nargin));

if nargin<5
    p=[];
end

%create empty LFP
output=[];

%randomize phases?
if isempty(p)
    p=rand(1,1)*2*pi;
end

%check if sampling frequency is satisfied
if srate<2*f
    error('create_sine: Sampling theorem not met - increase sampling frequency to >2*Freq');
end

%create time vector
t=0:1000/srate:tlength;

output=a*sin(2*pi*f/1000*t+p);
