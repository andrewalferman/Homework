clear all
close all

% Main method (driver) for Euler method used to solve MTH552 Homework 2
% Problem 3.

% Specify name of function used to supply right hand side of equation
odefun = 'homework2';

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

% Set up parameters of the problem
tstart = 0;
tstop = 17.1;
NSTEP = 3000;

% Pack all requiared values and call the evaluator
TSPAN = [tstart,tstop];
params = [mu; muhat];
[t,U] = eulerw17(odefun, TSPAN, U0, NSTEP, params);

% plot numerical solution;
figure;
hold off;
plot(U(1,:),U(2,:),'b');
title(['NSTEP = ' num2str(NSTEP)])
