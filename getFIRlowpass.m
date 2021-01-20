function [ b, gd ] = getFIRlowpass( hcut,attenHz,attendB,eegFS )
%make FIR filter

%testing
%eegFS = 2000;
%lcut = 6;
%hcut = 10;
%attenHz = 2;
%attendB = 40;

nyq = round(eegFS/2);

Fpass = hcut / nyq;  % Passband Frequency
Fstop = (hcut + attenHz) / nyq;  % Stopband Frequency
Apass = 1;     % Passband Ripple (dB)
Astop = attendB;    % Stopband Attenuation (dB)
h = fdesign.lowpass('fp,fst,ap,ast', Fpass, Fstop, Apass, Astop);
Hd = design(h, 'kaiserwin');
b = Hd.Numerator;

[a,f] = grpdelay(b,1,eegFS/2,eegFS);
k = f <= hcut;
gd = fix(mean(a(k)));

