%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function U = RKexplicitstep(odefun,t,U0,dt, A, b, c)
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
end
