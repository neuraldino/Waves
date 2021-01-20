%get phase distance between ph and phMod (modulatory phase)
function phDis = GetPhaseDist(ph,phMod)

phDis = zeros(size(ph));
for i = 1:length(ph)
   p = ph(i);
   phDis(i) = min((2 * pi) - abs(p - phMod), abs(p - phMod));
end