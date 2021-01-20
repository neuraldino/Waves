%gets phase of oscillations using xcorr with average OTC waveform
%eeg should be z-score normalized, double
%otc should be filtered (in theta range) and normalized
%phMod is the preferred modulatory phase
%maxlag should be about 2x more than cycle (theta 8Hz/2000Hz fs = 500
%uses peakdet
function [ph,maxXC] =  GetPhaseXC(eeg,otc,phMod,maxlag)

ph = nan;
maxXC = nan;

%get xcor
c = xcorr(eeg,otc,maxlag);
    
delta = (max(c) - min(c))/10; %minimum delta is 10x smaller than p-p of XCOR
    
[maxes mins] = peakdet(c,delta);
if isempty(maxes) || isempty(mins)
    return;
end

kmax = maxes(:,1);
kmin = mins(:,1);
    
%find closest maxima to the middle
maxR = kmax(kmax >= maxlag);
if isempty(maxR); return; end;
maxR = maxR(1);
maxL = kmax(kmax < maxlag);
if isempty(maxL); return; end;
maxL = maxL(end);

minR = kmin(kmin >= maxlag);
if isempty(minR); return; end;
minR = minR(1);
minL = kmin(kmin < maxlag);
if isempty(minL); return; end;
minL = minL(end);

dmaxR = maxR - maxlag;
dmaxL = maxlag - maxL;

dminR = minR - maxlag;
dminL = maxlag - minL;
    
[~,k] = min([dmaxR dmaxL dminR dminL]);

%closest maxima on right - find minima on left - subtract phase
%closest maxima on left - find minima on right - add phase
%closest minima on right - find maxima on left - add phase
%closest minima on left - find maxima on right - subtract phase    
if k == 1
    ph = (maxR-maxlag+1)/(maxR-minL+1);
    ph = ph * pi;
    ph = phMod - ph;
    maxXC = c(maxR);
elseif k == 2
    ph = (maxlag-maxL+1)/(minR-maxL+1);
    ph = ph * pi;
    ph = phMod + ph;
    maxXC = c(maxL);
elseif k == 3
    ph = (maxL-maxlag+1)/(maxL-minR+1);
    ph = ph * pi;
    ph = phMod + ph;
    maxXC = c(maxL);
else
    ph = (maxR-maxlag+1)/(maxR-minL+1);
    ph = ph * pi;
    ph = phMod - ph;
    maxXC = c(maxR);
end
    
%fix if higher than pi
if ph > pi; ph = ph-2*pi; end;