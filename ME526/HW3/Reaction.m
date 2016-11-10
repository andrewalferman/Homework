function [ dfr ] = Reaction( t, fC, kRate)
%Reaction system of first order differential equations for ME526.

dfr=zeros(3,1);

dfr(1) = kRate(2)*fC(2)*fC(3) - kRate(1)*fC(1);
dfr(2) = kRate(1)*fC(1) - kRate(2)*fC(2)*fC(3) - 2*kRate(3)*fC(2)*fC(2);
dfr(3) = 2*kRate(3)*fC(2)*fC(2);

end
