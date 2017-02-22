function z = exsolhw3(x)
%exsolhw3(x) returns exact solution of IVP for homework problem 3
% in a column vector
tmp = 3*exp(-8*x);
z = [(1+tmp)/8; -tmp];