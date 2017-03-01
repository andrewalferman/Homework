close all
clear all

% driver for numerical experiments in homework 
%Need to specify h before running it.
%Change only parameter p when using different methods.
% Input parameters:
a = 0; % left side of integration interval
eta = [.5; -3]; % initial value (column vector)
p = 2; % parameter p of method. p=0: single step, p>0: multistep
h = 0.2
% end of input

global count ;%counter for evaluations of function f(x,y)
count = 0;

m = max(size(eta)); % number of equations
y = zeros(m,p+1); f=y; 
for j=1:p                    %initialize matrices y and f.
  y(:,j+1) = exsolhw3(a+j*h); %The (j+1)-th column of y contains y(a+j*h)
  f(:,j+1) = fun(a+j*h,y(:,j+1)); % compute f(a+j*h,y(a+j*h))
end                 
y(:,1) = eta; f(:,1) = fun(a,eta);

nstep = .2/h;
xn = a+p*h;
for k=1:5 %solve ode. Stop after nstep steps  to compute error
  for n=1:nstep
    [y,f] = method(xn,h,y,f); %compute solution at x+h
    xn = xn+h;
  end
  x(k) = xn-p*h; %x-value where error is computed.
  err(k) = norm(y(:,1) - exsolhw3(x(k))) %compute error
  c(k) = count; %function evaluations needed so far
end
z=[x' err' c'];
disp('      x       error   evaluations of f(x,y)')
disp(z)
