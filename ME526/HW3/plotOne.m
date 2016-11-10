
clear
clc
close all

ph = linspace(0,2*pi,10000);
sig = @(phi)exp(1i*phi);
funcs = {@(phi) 0, @(phi) ((3+sig(phi))/16), @(phi) 3/16*(1+3*sig(phi))};
theta = {'0','1/4','3/4'};
clr = {'r.','k.','b.'};
Leg={};

for n = 1:length(funcs)
    fn = funcs{n};    
    if n>1
        rslt = zeros(length(ph),2);
        for k = 1:length(ph)
            rslt(k,:) = roots([fn(ph(k)), 1 ,1-sig(ph(k))]);
        end
        
        plot(real(rslt(:,1)),imag(rslt(:,1)),clr{n})
        hold on
        plot(real(rslt(:,2)),imag(rslt(:,2)),clr{n})
        
    else
        rslt = zeros(length(ph),1);
        for k = 1:length(ph)
            rslt(k) = roots([fn(ph(k)), 1 ,1-sig(ph(k))]);
        end
        
        plot(real(rslt),imag(rslt),clr{n})
        hold on
        
    end
    Leg{n} = strcat('\theta = ',theta{n});
    grid on
    
end
legend(Leg)
axis([-5, 5, -3, 3])
xlabel('\lambda_{R} * \Delta t')
ylabel('\lambda_{I} * \Delta t')
title('Region of stability')




