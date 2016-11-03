%% ME526 HW3 problems 3 and four.  Solving coupled Rate equations.
clear
clc
close all

% Setting up the problem. Problem 3
kRate = [0.04, 10.0, 1500.0]; %Rate constants
C_i = [0.9, 0.1, 1e-5]; %Initial conditions (Concentration)
h = 0.003; %timestep
tf = 3000; %finish time (s)
t = 0; %Start time
tarray = t:h:tf; %Array of times

dC_One = @(fC) kRate(2)*fC(2)*fC(3) - kRate(1)*fC(1);
dC_Two = @(fC) kRate(1)*fC(1) - kRate(2)*fC(2)*fC(3) - 2*kRate(3)*fC(2)*fC(2);
dC_Three = @(fC) 2*kRate(3)*fC(2)*fC(2);

farray = @(cond) [dC_One(cond), dC_Two(cond), dC_Three(cond)];

cRange = zeros(length(tarray),3);
cRange(1,:) = C_i;

% RK4 function portion.

tarray = tarray';

disp('RK4 time to steady state solution: ')
tic

for k = 2:length(tarray)
    cRange(k,:) = RK4General(farray, cRange(k-1,:),h);   
end

toc

subplot(1,2,1)
Leg= {};
for k = 1:3
    plot(tarray,cRange(:,k));
    hold on
    Leg{k} = sprintf('C_{%i}',k);
end

legend(Leg)
title('RK4 method')
xlabel('time (s)')
ylabel('Concentration')
ylim([1e-5, 2])
xlim([1e-5,3e3])
grid on

% ODE23s Solver portion

disp('ODE23s time to steady state solution: ')
tic

[T,Y] = ode23s(@(t,y) Reaction(t,y,kRate), [t,tf], C_i);

toc

subplot(1,2,2)
for k = 1:3
    plot(T,Y(:,k));
    hold on
end

legend(Leg)
title('ODE23 method')
xlabel('time (s)')
ylabel('Concentration')
ylim([1e-5, 2])
xlim([1e-5,3e3])
grid on

%Do loglog plots for concentration
T(1) = 1e-5;
tarray(1) = 1e-5;

figure
subplot(1,2,1)
for k = 1:3
    loglog(tarray,cRange(:,k));
    hold on
end

legend(Leg)
title('RK4 method')
xlabel('time (s)')
ylabel('Concentration')
ylim([1e-5, 2])
xlim([1e-5,3e3])
grid on

subplot(1,2,2)
for k = 1:3
    loglog(T,Y(:,k));
    hold on
end

legend(Leg)
title('ODE23 method')
xlabel('time (s)')
ylabel('Concentration')
ylim([1e-5, 2])
xlim([1e-5,3e3])
grid on

%% Problem 4
% Row vectors instead of column vectors this time will make it easier to 
% insert the result into the solution matrix.

h = [0.003, 0.015]; %timestep

figure
for n = 1:2
    
    tarray = t:h(n):tf; 
    cR = zeros(3,length(tarray));
    cR(:,1) = C_i';

    fprintf('Linearized implicit time to steady state solution at h = %.3f:\n',h(n))
    tic

    for k = 2:length(tarray)
        [A,b] = makeAB(cR(:,k-1),kRate,0.5*h(n));
        cR(:,k) = A\b;
    end

    toc
    
    subplot(1,2,n)
    for k = 1:3
        plot(tarray,cR(k,:));
        hold on
    end

    legend(Leg)
    title(strcat('Linearized implicit \Deltat = ',num2str(h(n))))
    xlabel('time (s)')
    ylabel('Concentration')
    ylim([1e-5, 2])
    xlim([1e-5,3e3])
    grid on
end


