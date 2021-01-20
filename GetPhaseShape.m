%find phase of a sample in a signal based on the shape analysis
%first peaks are detected, then phase is found as a ratio between peaks
%otc - averaged signal
%N - sample to compute phase
%delta - shortest size to find peaks, usualy 10% of peak-peak
%OTC should be theta filtered
function phMod = GetPhaseShape(otc,N)

%[maxes,mins] = peakdet(otc,delta);
%mx = maxes(:,1);
%mi = mins(:,1);

mx = find((otc > [otc(1) otc(1:(end-1))]) & (otc >= [otc(2:end) otc(end)]));
mi = find((otc < [otc(1) otc(1:(end-1))]) & (otc <= [otc(2:end) otc(end)]));

%{
figure;
hold on;
plot(otc,'g');
plot(mx,otc(mx),'r.')
plot(mi,otc(mi),'b.')
%}

%find closest extreme
% = length(otc)/2;
[dmx,kmx] = min(abs(mx-N));
[dmi,kmi] = min(abs(mi-N));        
%min closer
if dmi <= dmx
    %min is right of center, find phase from left max and min
    %min is left of center, find phase bw min and right max
    miSel = mi(kmi);
    if miSel >= N
        maSel = mx(mx<N);
        if isempty(maSel); phMod = nan; return; end;
        maSel = maSel(end);
        phMod = (N-maSel+1) / (miSel-maSel+1);
        phMod = phMod * pi;
    else
        maSel = mx(mx>N);
        if isempty(maSel); phMod = nan; return; end;
        maSel = maSel(1);
        phMod = (maSel-N+1) / (maSel-miSel+1);
        phMod = phMod * (-pi);
    end
else %max closer
    %max is righ of center, find phase between min on left and max
    %max is left of center, find phase between max and right min
    maSel = mx(kmx);
    if N <= maSel
        miSel = mi(mi<N);
        if isempty(miSel); phMod = nan; return; end;
        miSel = miSel(end);
        phMod = (maSel-N+1) / (maSel-miSel+1);
        phMod = phMod * (-pi);
    else
        miSel = mi(mi>N);
        if isempty(miSel); phMod = nan; return; end;
        miSel = miSel(1);
        phMod = (N-maSel+1) / (miSel-maSel+1);
        phMod = phMod * pi;
    end
end

