function [t,U] = eulerw17d(odefun,TSPAN,U0,NSTEP,method,A,b,c,mu)
% Function that calls forth a method and an ODE to solve and iterates over
% the solution.  Everything in this function uses constant stepsize. 

T0 = TSPAN(1); TFINAL = TSPAN(2);
dt = (TFINAL-T0)/NSTEP;
m = length(U0);
U = zeros(m,NSTEP+1);
U(:,1) = U0;
t = T0:dt:TFINAL;
if (strcmp(method,'RK4') || strcmp(method,'RK1'))
    for k = 1:NSTEP
        U(:,k+1) = RKexplicitstep(odefun,t(k),U(:,k),dt,A,b,c,mu);
    end
elseif strcmp(method,'ExplicitEuler')
    for k = 1:NSTEP
        U(:,k+1) = eulerstep(odefun,t(k),U(:,k),dt,mu);
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function U = eulerstep(odefun,t,U0,dt,mu)
% Takes one step of the foward Euler method
U = U0 + dt*feval(odefun,t,U0,mu);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function yprime = orbitODE(t,y,mu)
% Implements the ODE from Homework 2 Problem 3 as a first order system
muhat = 1.0 - mu;
D1 = ((y(1) + mu)^2 + y(2)^2)^1.5;
D2 = ((y(1) - muhat)^2 + y(2)^2)^1.5;
yprime = zeros(size(y));
yprime(1) = y(3);
yprime(2) = y(4);
yprime(3) = y(1) + 2*y(4) - muhat*((y(1)+mu)/D1) - mu*((y(1)-muhat)/D2);
yprime(4) = y(2) - 2*y(3) - (muhat*(y(2)/D1)) - (mu*(y(2)/D2));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function U = RKexplicitstep(odefun,t,U0,dt,A,b,c,mu)
% One step of a general explicit Runge Kutta method
% A is assumed to be strictly lower triangular
% b and c must be column vectors
%
r = length(b);
m = length(U0);
K = zeros(m,r);%matrix whose j-th column is K_j
K(:,1) = feval(odefun,t,U0,mu);
for j = 2:r
    Y = U0 + dt*K(:,1:j-1)*(A(j,1:j-1).');
     % Y = U0 + dt*sum_{l=1}^{j-1} a_{jl}K_l
    K(:,j) = feval(odefun,t + c(j)*dt, Y,mu);
end

U = U0 + dt*K*b;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function yprime = hw4p2(t,u,mu)
% ODE specific to problem 2 of homework 4
if (round(t,12) == 0 & round(u,12) == 0)
    yprime = 0;
else
    yprime = (2*t*u)/(t^2 + u^2);
end
end


