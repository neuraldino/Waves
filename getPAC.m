%get PAC - example
clear; close all; clc;

%load filters
load('filtersTheta_fs2000_40dB_1HzTB_2HzWidth_5_05_10.mat');
Ntheta = length(filtersTheta);
load('filtersGamma_fs2000_40dB_4HzTB_20HzWidth_20_2_180.mat');
Ngamma = length(filtersGamma);

%Analytical windows
eegFS = 2000;
winLenSec = 30; %seconds
stepLenSec = 10; %seconds
winLen = winLenSec*eegFS; %in samples
stepLen = stepLenSec*eegFS; %in samples

edges = linspace(-pi,pi,21); %edges for histogram calculation
numsurrogate = 400;
shifts = round(rand(1,numsurrogate)*(winLen-2*eegFS) + eegFS);

%load eeg
load([drMAT fn]);

%theta filter - apply first
thetaF = cell(Ntheta,1);
%can be done in parallel
for the = 1:Ntheta
    b = filtersTheta{the};
    %th = filter(b,1,vx);
    th = filter(b,1,eeg);
    gd = groupDelaysTheta{the};
    th = [th(gd+1:end) zeros(1,gd)];
    thetaF{the} = angle(hilbert(th));
end

    
Nwin = floor((length(eeg)-winLen)/stepLen);

%results
resMn = zeros(Ngamma,Ntheta,Nwin);
resAn = zeros(Ngamma,Ntheta,Nwin);
resMnNorm = zeros(Ngamma,Ntheta,Nwin);

%GAMMA
for gam = 1:Ngamma
        
    b = filtersGamma{gam};
    ga = filter(b,1,eeg);
    gd = groupDelaysGamma{gam};
    ga = [ga(gd+1:end) zeros(1,gd)];
    gamma = abs(hilbert(ga));
        
    mnGam = cell(1,Ntheta);
    mnNormGam = cell(1,Ntheta);
    anGam = cell(1,Ntheta);
        
    %THETA
    %can be done in paralell
    for the = 1:Ntheta

        theta = thetaF{the};

        mn = zeros(1,Nwin);
        an = zeros(1,Nwin);
        mnNorm = zeros(1,Nwin);

        %through all windows
        for wI = 1:Nwin

            st = (wI-1)*stepLen;
            ed = st + winLen;

            amp = double(gamma(st:ed));
            phase = double(theta(st:ed));

            [MI, MInorm] = getmisur(amp,phase,edges,shifts);

            z = amp .* exp(1i*phase);
            mean_angle = angle(mean(z));

            mn(wI) = MI;
            an(wI) = mean_angle;
            mnNorm(wI) = MInorm;
        end %windows

        mnGam{the} = mn;
        anGam{the} = an;
        mnNormGam{the} = mnNorm;

    end %theta

    %convert to matrix
    for the = 1:Ntheta
        resMn(gam,the,1:Nwin) = mnGam{the};
        resAn(gam,the,1:Nwin) = anGam{the};
        resMnNorm(gam,the,1:Nwin) = mnNormGam{the};
    end

end %gamma
    
    