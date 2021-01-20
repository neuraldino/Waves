%get phase distance p2-p1
function phDis = GetPhaseDistSign(p2,p1)

%clc
%p1 = -pi/2+0.1;
%p2 = pi/2;

phDis = min((2 * pi) - abs(p1 - p2), abs(p1 - p2));
   
%sign
s = 1;
if (p1-p2 >= 0 && p1-p2 <= pi) || (p1-p2 <= -pi && p1-p2 >= -2*pi)
    s = -1;
end

phDis = phDis*s;

%disp(phDis);
  