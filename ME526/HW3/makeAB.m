function [ a, b ] = makeAB( C, k, h)
%makeAB returns the A and b matrix for the linearized solution to the 
%chemical kinetics problem in ME526 HW4

a = [(h*k(1)+1), -C(3)*h*k(2), -C(2)*h*k(2);...
    -h*k(1), (1+h*(k(2)*C(3)+4*k(3)*C(2))), C(2)*h*k(2);...
    0, -4*h*k(3)*C(2), 1];

b = [C(1)*(1-h*k(1));...
    C(2)+C(1)*h*k(1);...
    C(3)];


end

