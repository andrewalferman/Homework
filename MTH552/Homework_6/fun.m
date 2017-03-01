function f=fun(x,y)
%derivatives for IVP 
global count;% counts how often fun is called
f = zeros(size(y));
f(1) = y(2);
f(2) = y(2)*(y(2)-1)/y(1);
count = count+1;