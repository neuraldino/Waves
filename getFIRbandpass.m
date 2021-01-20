function [ b, gd ] = getFIRbandpass( lcut,hcut,attenHz,attendB,eegFS )
%make FIR filter

%testing
%eegFS = 2000;
%lcut = 6;
%hcut = 10;
%attenHz = 2;
%attendB = 40;

nyq = round(eegFS/2);

%make bandpass
Fstop1 = (lcut - attenHz)  / nyq;  % First Stopband Frequency
Fpass1 = lcut  / nyq;  % First Passband Frequency
Fpass2 = hcut / nyq;  % Second Passband Frequency
Fstop2 = (hcut + attenHz) / nyq;  % Second Stopband Frequency
Astop1 = attendB;    % First Stopband Attenuation (dB)
Apass  = 1;     % Passband Ripple (dB)
Astop2 = attendB;    % Second Stopband Attenuation (dB)
h = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', Fstop1, Fpass1, ...
                 Fpass2, Fstop2, Astop1, Apass, Astop2);
Hd = design(h, 'kaiserwin');   
b = Hd.Numerator;

%group delay
[a,f] = grpdelay(b,1,nyq,eegFS);
k = f >= lcut & f <= hcut;
gd = fix(mean(a(k)));


