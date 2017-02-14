clear all
close all

% Main routine (driver) for homework 3 RK4 method

% Specify name of user supplied function M-file with right hand side 
% of ODE
odefun = 'myode1';

% Specify the numerical method using a predetermined string with the name
% of the method
method = 'RK4';

% Specify initial and final time
t0 = 0; tfinal = 1;

% Specify column vector of initial values
U0 = [1;2];

% Specify number of steps. Stepsize Delta_t = (tfinal-t0)/NSTEP.
NSTEP=1000

% Create the range of solutions to solve for, which will be used in the
% numerical method to create a vector of all of the x values of the
% solution.
TSPAN = [t0,tfinal];

% Call the numerical method and obtain the solution vector for plotting.
[t,U] = eulerw17d(odefun,TSPAN,U0,NSTEP,method);
% [t,UE] = eulerw17d(odefun,TSPAN,U0,NSTEP,'ExplicitEuler');
% [t,UR] = eulerw17d(odefun,TSPAN,U0,NSTEP,'RK1');

% Plot the numerical solution.
figure;
hold on;
plot(t,U(1,:));
% plot(t,UE(1,:),'k');
% plot(t,UE(1,:),'m');

% If the IVP is the demonstration IVP
% u'' = -u, u(t0) = U0(1), u'(t0) = U0(2)
% Plot the exact solution and find the maximum error
if odefun == 'myode1'
    uexact = U0(1)*cos(t) + U0(2)*sin(t);
    % Compute maximum error
    maxerr = max(abs(uexact-U(1,:)))
    % Plot exact solution
    hold on;
    plot(t,uexact,'r');
    xlabel(['Red = Exact Sol., Blue = Numerical (RK4) Sol., '...
        'Black = Euler Sol., Magenta = RK1 Sol.']);
    title(['NSTEP = ' num2str(NSTEP) ', max. error = ' ...
            num2str(maxerr)])
end