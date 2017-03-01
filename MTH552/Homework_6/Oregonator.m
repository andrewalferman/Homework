function f=Oregonator(x,y)
%derivatives for IVP 
global count;% counts how often fun is called
k = [1.34 1.6e9 8e3 4e7 1.0];
f = zeros(size(y));
f(1) = -k(1)*y(1)*y(2) - k(3)*y(1)*y(3);
f(2) = -k(1)*y(1)*y(2) - k(2)*y(2)*y(3) + k(5)*y(5);
f(3) = k(1)*y(1)*y(2) - k(2)*y(2)*y(3) + k(3)*y(1)*y(3) - 2*k(4)*y(3)^2;
f(4) = k(2)*y(2)*y(3) - k(4)*y(3)^2;
f(5) = k(3)*y(1)*y(3) - k(5)*y(5);
count = count+1;