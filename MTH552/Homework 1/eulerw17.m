function [t,U] = eulerw17(odefun, TSPAN ,U0,NSTEP);
T0 = TSPAN(1); TFINAL = TSPAN(2);
dt = (TFINAL-T0)/NSTEP;
m = length(U0);
U = zeros(m,NSTEP+1);
U(:,1) = U0;
t = T0:dt:TFINAL;
for k = 1:NSTEP
    U(:,k+1) = eulerstep(odefun,t(k),U(:,k),dt);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function U = eulerstep(odefun,t,U0,dt)
U = U0 + dt*feval(odefun,t,U0);
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
