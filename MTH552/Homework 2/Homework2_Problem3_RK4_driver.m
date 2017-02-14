clear all
close all

% Main routine (driver) for homework 2 problem 3 using the RK4 method

% Specify name of user supplied function M-file with right hand side 
% of ODE
odefun = 'homework2';

% Specify the numerical method using a predetermined string with the name
% of the method
method = 'RK4';

% Specify initial and final time
t0 = 0; tfinal = 17.1;

% Set up the given parameters
mu = 0.012277471;
muhat = 1 - mu;

% Set up the initial conditions
% Note that u5 = u1', u6 = u2', u7 = u1", and u8 = u2"
u1 = 0.994;
u2 = 0.0;
d3 = ((u1 + mu)^2 + u2^2)^1.5;
d4 = ((u1 - muhat)^2 + u2^2)^1.5;
u5 = 0.0;
u6 = -2.001585106379082522405378622224;
u7 = u1 + 2*u6 - muhat*((u1+mu)/d3) - mu*((u1-muhat)/d4);
u8 = u2 - 2*u5 - muhat*u2/d3 - mu*u2/d4;

% Pack up the initial conditions
U0 = [u1;u2;d3;d4;u5;u6;u7;u8];
params = [mu; muhat];

% Specify number of steps. Stepsize Delta_t = (tfinal-t0)/NSTEP.
NSTEP=3000000

% Create the range of solutions to solve for, which will be used in the
% numerical method to create a vector of all of the x values of the
% solution.
TSPAN = [t0,tfinal];

% Call the numerical method and obtain the solution vector for plotting.
[t,U] = eulerw17d(odefun,TSPAN,U0,NSTEP,method,params);

% Plot the numerical solution.
figure;
hold on;
plot(U(1,:),U(2,:));
% plot(t,UE(1,:),'k');
% plot(t,UE(1,:),'m');

% If the IVP is the demonstration IVP
% u'' = -u, u(t0) = U0(1), u'(t0) = U0(2)
% Plot the exact solution and find the maximum error
if strcmp(odefun,'myode1')
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