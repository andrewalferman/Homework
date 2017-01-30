% Main routine (driver) for Euler method demonstration
odefun = 'myode1';  %Specify name of user supplied
                    % function M-file with rhs of ode
t0 = 0; tfinal = 2*pi; % Specify initial and final times
U0 = [-1;3]; % Specify column vector of initial values
NSTEP=200;  % Specify number of steps.
            %Stepsize Delta_t = (tfinal-t0)/NSTEP.

            
TSPAN = [t0,tfinal];
[t,U] = eulerw17(odefun,TSPAN,U0,NSTEP);

% plot numerical solution;
figure;
hold off;
plot(t,U(1,:));

% If the IVP is the demonstration IVP
% u'' = -u, u(t0) = U0(1), u'(t0) = U0(2)
% plot the exact solution and find the maximum error
if odefun == 'myode1'
    uexact = U0(1)*cos(t) + U0(2)*sin(t);
    % Compute maximum error
    maxerr = max(abs(uexact-U(1,:)))
    % Plot exact solution
    hold on;
    plot(t,uexact,'r');
    xlabel(['red = exact sol., blue = numerical sol.']);
    title(['NSTEP = ' num2str(NSTEP) ', max. error = ' ...
            num2str(maxerr)])
end