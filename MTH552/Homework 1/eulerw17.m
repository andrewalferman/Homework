function [t,U] = eulerw17(odefun, TSPAN, U0, NSTEP, params)
T0 = TSPAN(1); TFINAL = TSPAN(2);
dt = (TFINAL-T0)/NSTEP;
m = length(U0);
U = zeros(m,NSTEP+1);
U(:,1) = U0;
t = T0:dt:TFINAL;
for k = 1:NSTEP
    U(:,k+1) = eulerstep(odefun,t(k),U(:,k),dt, params);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function U = eulerstep(odefun,t,U0,dt, params)
U = U0 + dt*feval(odefun,t,U0);
if odefun == 'homework2'
    mu = params(1);
    muhat = params(2);
    U(1) = U0(1) + dt*U0(5) + 0.5*(dt^2)* U0(7);
    U(2) = U0(2) + dt*U0(6) + 0.5*(dt^2)* U0(8);
    U(3) = ((U(1) + mu)^2 + U(2)^2)^1.5;
    U(4) = ((U(1) - muhat)^2 + U(2))^1.5;
    U(7) = U(1) + 2*U(6) - muhat*((U(1)+mu)/U(3)) - mu*((U(1)-muhat)/U(4));
    U(8) = U(2) - 2*U(5) - muhat*U(2)/U(3) - mu*U(2)/U(4);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function yprime = myode1(t,y)
% Implements ODE y''= -y as a first order system
yprime = zeros(size(y));
yprime(1) = y(2);
yprime(2) = -y(1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function yprime = myode2(t,y)
% Implements ODE from Homework 1 problem 1 as a first order system
yprime = zeros(size(y));
yprime(1) = y(2);
yprime(2) = -y(2)*t^2 - y(1)^2 + t^6 +3*t^4 + 6*t;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function yprime = homework2(t,y)
% Implements ODE from Homework 2 Problem 3 as a first order system
yprime = zeros(size(y));
yprime(1) = y(5);
yprime(2) = y(6);
yprime(5) = y(7);
yprime(6) = y(8);
end
