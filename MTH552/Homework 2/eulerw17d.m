function [t,U] = eulerw17d(odefun,TSPAN,U0,NSTEP,method,params)
T0 = TSPAN(1); TFINAL = TSPAN(2);
dt = (TFINAL-T0)/NSTEP;
m = length(U0);
U = zeros(m,NSTEP+1);
U(:,1) = U0;
t = T0:dt:TFINAL;
if strcmp(method,'RK4')
    A = [0 0 0 0; 0.5 0 0 0; 0 0.5 0 0; 0 0 1 0];
    b = [1/6;1/3;1/3;1/6];
    c = [0;0.5;0.5;1];
    for k = 1:NSTEP
        U(:,k+1) = RKexplicitstep(odefun,t(k),U(:,k),dt,A,b,c,params);
    end
elseif strcmp(method,'ExplicitEuler')
    A = 0;
    b = 1;
    c = 0;
    for k = 1:NSTEP
        U(:,k+1) = eulerstep(odefun,t(k),U(:,k),dt);
    end
elseif strcmp(method,'RK1')
    A = 0;
    b = 1;
    c = 0;
    for k = 1:NSTEP
        U(:,k+1) = RKexplicitstep(odefun,t(k),U(:,k),dt,A,b,c);
    end    
end
% Series of if statements that will return the order of the RK method used
if round(sum(b),4) == 1.0000
    order = 1;
    if round(b.'*c,4) == 0.5000
        order = 2;
        if round(b.'*(c.^2),4) == round(1/3,4) && ...
           round(sum(b'.*sum(A'.*c)),4) == round(1/6,4)
            order = 3;
            if round(b.'*(c.^3),4) == 1/4 && ...
               round(sum(b'.*c'.*sum(A'.*c)),4) == 1/8 && ...
               round(sum(b'.*sum(A'.*c.^2)),4) == round(1/12,4) && ...
               round(sum(A.*b)*sum(A'.*c)',4) == round(1/24,4)
                order = 4;
            end
        end
    end
end
display(order)
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
function yprime = homework2(t,y)
% Implements ODE from Homework 2 Problem 3 as a first order system
yprime = zeros(size(y));
yprime(1) = y(5);
yprime(2) = y(6);
yprime(5) = y(7);
yprime(6) = y(8);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function U = RKexplicitstep(odefun,t,U0,dt,A,b,c,params)
% One step of a general explicit Runge Kutta method
% A is assumed to be strictly lower triangular
% b and c must be column vectors
%
r = length(b);
m = length(U0);
K = zeros(m,r);%matrix whose j-th column is K_j
K(:,1) = feval(odefun,t,U0);
for j = 2:r
    Y = U0 + dt*K(:,1:j-1)*(A(j,1:j-1).');
     % Y = U0 + dt*sum_{l=1}^{j-1} a_{jl}K_l
    K(:,j) = feval(odefun,t + c(j)*dt, Y);
end
U = U0 + dt*K*b;
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