% refsim.m - Reflectance Simulations (From Elisa?)

%% Clear and load files
clear
load('spectra.mat')
load('silicon.mat')

%% Set up wavelength
lambda=(400:0.001:700)';

%% Indices of refraction

n(:,1)=1*ones(1,length(lambda))'; %water
%n(:,2)=nitrideDispersion(lambda.*0.001);
%n2=silicaDispersion(lambda.*0.001);
n(:,2)=1.5*ones(1,length(lambda))';;
n(:,3)=1.333.*ones(1,length(lambda))';
%n(:,3)=(interp1(silicon(:,1),silicon(:,2),lambda.*0.001));
%n=1.5.*ones(1,length(lambda))'; 

%% Thickness and layers
thcknss=510;
M=3;
%% Reflection oefficients

for i=1:M-1
r(:,i)=(n(:,i+1)-n(:,i))./(n(:,i+1)+n(:,i));
end

%% Optical path length
L(:,1)=thcknss.*n(:,2);

%% Reflection

Gamma=r(:,M-1);

for i = (M-2):-1:1
    delta = 2*pi*L(:,i)./lambda;                  
    z = exp(-2*1i*delta);                          
    Gamma = ((r(:,i) + Gamma.*z) ./ (1 + r(:,i).*Gamma.*z));
    
end

%% Plots


% Reflectance vs wavelength
figure(5)
hold on
plot(lambda,abs(Gamma).^2,'r','linewidth',1.5)

%plot(Normalized,(Blue),'b','linewidth',1.5)
%plot(Normalized,(Green),'g','linewidth',1.5)
%plot(Normalized,(Red),'r','linewidth',1.5)
%plot(Normalized,(Amber),'y','linewidth',1.5)



%imnoise(I,'poisson')
box on
grid on
ylabel('Reflectance')
xlabel('Wavelength (nm)') 
set(gca,'FontSize',18)


