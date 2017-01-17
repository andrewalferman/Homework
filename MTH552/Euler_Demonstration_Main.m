clear all
close all

% Main routine (driver) for Euler method demonstration
odefun = 'myode2'; %Specify name of user supplied
                   % function M-file with rhs of ode
t0 = 0; tfinal = 2; % Specify initial and final times
U0 = [1;2]; % Specify column vector of initial values
NSTEP=8400; % Specify number of steps.
           %Stepsize Delta_t = (tfinal-t0)/NSTEP.

convergenceacc = 1000;

TSPAN = [t0,tfinal];
[t,U] = eulerw17(odefun,TSPAN,U0,NSTEP);
[te,Ue] = eulerw17(odefun,TSPAN,U0,NSTEP*convergenceacc);

% plot numerical solution;
figure;
hold off;
plot(t,U(1,:),'b');

% If the IVP is the demonstration  IVP
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
    title(['NSTEP = ' num2str(NSTEP) ',  max. error = ' ...
            num2str(maxerr)])
end
 
% If the IVP is the IVP from Homework 1 problem 1
% u'' = -u, u(t0) = U0(1), u'(t0) = U0(2)
% plot the exact solution and find the maximum error
if odefun == 'myode2'
    uexact = Ue(1,1:convergenceacc:length(Ue));
    % Compute maximum error
    err = abs(uexact(:,length(uexact))-U(1,length(U)))
    % Plot exact solution
    hold on;
    plot(t,uexact,'r');
    xlabel(['red = exact sol., blue = numerical sol.']);
    title(['NSTEP = ' num2str(NSTEP) ',  Error at 2 = ' ...
            num2str(err)])
 end
