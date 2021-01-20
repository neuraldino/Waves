function [ b, gd ] = getFIRhighpass( lcut,attenHz,attendB,eegFS )
%make FIR filter

%testing
%eegFS = 2000;
%lcut = 6;
%hcut = 10;
%attenHz = 2;
%attendB = 40;

nyq = round(eegFS/2);

%make highpass
Fpass = lcut / nyq;  % Passband Frequency
Fstop = (lcut - attenHz) / nyq;  % Stopband Frequency
Apass = 1;     % Passband Ripple (dB)
Astop = attendB;    % Stopband Attenuation (dB)
h = fdesign.highpass('fst,fp,ast,ap', Fstop, Fpass, Astop, Apass);
Hd = design(h, 'kaiserwin');

b = Hd.Numerator;
[a,f] = grpdelay(b,1,eegFS/2,eegFS);
k = f >= lcut;
gd = fix(mean(a(k)));


