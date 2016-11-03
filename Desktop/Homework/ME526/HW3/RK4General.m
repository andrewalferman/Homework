function [ dy ] = RK4General( fy, init, h )
%RK4 Runge-Kutta4 Generalized

dyz = init;

kyOne=fy(dyz);
kyTwo=fy(dyz+kyOne*0.5*h);
kyThree=fy(dyz+kyTwo*0.5*h);
kyFour=fy(dyz+kyThree*h);
dy=dyz+(h/6)*(kyOne+2*kyTwo+2*kyThree+kyFour);

end
