clear;
close all;
clc;
format long e;
meshpoints = linspace(0,2*pi,1000);
theta = {'0', '1/4', '3/4'};
Leg = {};
funcs = {@(lam,sig) 1+lam+sig, @(lam,sig) (1+3*lam/4)/(1-lam/4)+sig,...
    @(lam,sig) (1+lam/4)/(1-3*lam/4)+sig};

% loop over phi
for k = 1 : length(meshpoints)
    % define the polynomial
    C = [1/2, 1, 1 - complex(cos(phi), sin(phi))];
    % find roots
    R(1 : 2,i) = roots(C);
end

hold on;
axis([-3 * pi/2, pi/2, -3 * pi/2, 3 * pi/2]);
plot(R(1, :),'m.')
plot(R(2, :),'k.')
grid;
xlabel('?_R ?')
ylabel('?_I ?')
title('RK2 Stability Curve')