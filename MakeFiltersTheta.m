clear all;close all;clc;

eegFS = 2000;
nyq = eegFS / 2;

attenHz = 1; %attenuation bandwidth (between Fstop1 and Fpass1)  
attendB = 40;

%define bands
bandWidth = 2;

bandCenters = 5:0.5:10;
bandST = bandCenters-bandWidth/2;
bandED = bandCenters+bandWidth/2;

bands = [bandST; bandED]';

Nbands = size(bands,1);

fn = 'filtersTheta_fs2000_40dB_1HzTB_2HzWidth_5_05_10.mat';

%stores filters
filtersTheta = cell(Nbands,1);
groupDelaysTheta = cell(Nbands,1);

for s = 1:Nbands
    
    disp(s);
    
    lcut = bands(s,1);
    hcut = bands(s,2);

    if (lcut-attenHz) < 1  %if lowcut is under 1Hz, make lowpass instead
        Fpass = hcut / nyq;  % Passband Frequency
        Fstop = (hcut + attenHz) / nyq;  % Stopband Frequency
        Apass = 1;     % Passband Ripple (dB)
        Astop = attendB;    % Stopband Attenuation (dB)
        h = fdesign.lowpass('fp,fst,ap,ast', Fpass, Fstop, Apass, Astop);
        Hd = design(h, 'kaiserwin');
   else
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
    end
    
    b = Hd.Numerator;
  
    filtersTheta{s} = b;

    %group delays
    [a,f] = grpdelay(b,1,eegFS/2,eegFS);
    k = f >= lcut & f <= hcut;
    gd = fix(mean(a(k)));
    groupDelaysTheta{s} = gd;
        
end

save(fn,'filtersTheta','eegFS','bands','attenHz','attendB','groupDelaysTheta');


