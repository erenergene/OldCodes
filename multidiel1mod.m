%% multidiel1mod.m - modified version of multidiel1.m

clearvars
close all


%
%          na | n1 | n2 | ... | nM | nb
% left medium | L1 | L2 | ... | LM | right medium 
%   interface 1    2    3     M   M+1
%
% Usage: [Gamma1,Z1] = multidiel1(n,L,lambda,theta,pol)
%        [Gamma1,Z1] = multidiel1(n,L,lambda,theta)       (equivalent to pol='te')
%        [Gamma1,Z1] = multidiel1(n,L,lambda)             (equivalent to theta=0)
%
% n      = vector of refractive indices [na,n1,n2,...,nM,nb]
% L      = vector of optical lengths of layers [n1*l1,...,nM*lM], in units of lambda_0
% lambda = vector of free-space wavelengths at which to evaluate input impedance
% theta  = incidence angle from left medium (in degrees)
% pol    = 'tm' or 'te', for parallel/perpendicular polarizations
%
% Gamma1 = reflection response at interface-1 into left medium evaluated at lambda
% Z1     = transverse wave impedance at interface-1 in units of eta_a (left medium)
%
% notes: simplified version of MULTIDIEL for isotropic layers
% 
%        M is the number of layers (must be >=0)
%
%        optical lengths are L1 = n1*l1, etc., in units of a reference 
%        free-space wavelength lambda_0. If M=0, use L=[].
%
%        lambda is in units of lambda_0, that is, lambda/lambda_0 = f_0/f
%
%        reflectance = |Gamma1|^2, input impedance = Z1 = (1+Gamma1)./(1-Gamma1)
%
%        delta(i) = 2*pi*[n(i)*l(i)*cos(th(i))]/lambda
%
%        it uses SQRTE, which is a modified version of SQRT approriate for evanescent waves
%
%        see also MULTIDIEL, MULTIDIEL2

% Sophocles J. Orfanidis - 1999-2008 - www.ece.rutgers.edu/~orfanidi/ewa
load("spectra.mat",'spectra')
a = spectra{1,1};
b = spectra{1,2};
c = spectra{1,3};
d = spectra{1,4};
x_axis = a(:,1);
bluespectrum = a(:,2)*100
greenspectrum = b(:,2)*100
redspectrum = d(:,2)*100

figure(1)
lambda = linspace(0.4,0.68,281);
lambdarSiO = [0.0684043, 0.1162414, 9.896161];
lambdarSi = [0.301516485, 1.13475115, 1104];

BsiO = [0.6961663, 0.4079426, 0.8974794];
Bsi = [10.6684293, 0.0030434748, 1.54133408];

nsqrSi =sellmeier(Bsi,lambdarSi,lambda);
nsqrSiO =sellmeier(BsiO,lambdarSiO,lambda);

nrSi = (sqrt(nsqrSi)+conj(sqrt(nsqrSi)))/2;
nrSiO = (sqrt(nsqrSiO)+conj(sqrt(nsqrSiO)))/2;


theta=0;
L = linspace(0.08,0.14,281);
Z1 = [];
Gamma1 = [];

for i = 1:numel(lambda);
for j = 1:numel(L); 
[Gamma1(i,j),Z1(i,j)] = multidiels([1; nrSiO(1,i); nrSi(1,i)],L(j).*nrSiO(1,i),lambda(1,i));
end
end

[MLam, MThicc] = meshgrid(lambda,L);
Gamma = conj(Gamma1).*Gamma1.*100;
surgraph = surf(MLam,MThicc,Gamma,'EdgeColor','none');
xlim([0.4 0.68])
ylim([0.08 0.14])
cb = colorbar;

cb.Location = 'southoutside';
xlabel('Lambda (\mum)');
ylabel('L (\mum)');
zlabel('Reflectance (%)');
caxis([0 50]);

figure(2)   

hold on
Bi = 61;
Gi = 151;
Ri = 281;
IB = 1;
IG = 1;
IR = 1;

plot(L,IB.*Gamma(:,Bi)','b','LineWidth',2)
plot(L,IG.*Gamma(:,Gi)','g','LineWidth',2)
plot(L,IR.*Gamma(:,Ri)','r','LineWidth',2)
legend('Blue','Green','Red')
xlabel('L (\mum)','FontSize',16);
xlim([0.08 0.14])
ylabel('Reflectance (%)','FontSize',16');
hold off

figure(3)
hold on
Bi = 61;
Gi = 151;
Ri = 281;
IB = 1;
IG = 1;
IR = 1;

plot(lambda,IB.*Gamma(:,Bi)','b','LineWidth',2)
plot(lambda,IG.*Gamma(:,Gi)','g','LineWidth',2)
plot(lambda,IR.*Gamma(:,Ri)','r','LineWidth',2)

figure(4)

Gamma_R = IR.*Gamma(:,Ri)';
Gamma_G = IG.*Gamma(:,Gi)';
Gamma_B = IB.*Gamma(:,Bi)';



Genmatrix = [Gamma_R;Gamma_G;Gamma_B];
MaxGamma = max(Genmatrix);
norm_values = uint8(round((Genmatrix ./ MaxGamma).* 255))';
norm_values = reshape(norm_values,1,281,3);
for i=1:6
    norm_values = [norm_values;norm_values];
end

imshow(norm_values)
xlabel('L (\mum)','FontSize',16);
ylabel('Color','FontSize',16)
xlim([0 256])

figure(5)
hold on
plot(x_axis,bluespectrum,'b','LineWidth',2)
plot(x_axis,greenspectrum,'g','LineWidth',2)
plot(x_axis,redspectrum,'r','LineWidth',2)
xlabel('Wavelength (nm)')
ylabel('intensity')
hold off
% figure(4)
% RedA=1
% RedAvg=625;
% RedFWHM=16; 
% GaussRed = RedA.*exp(-((L-RedAvg).^2)/(2.*(RedFWHM).^2))
% plot(,GaussRed);





% max = max()




% figure(3)
% % 
% plot(lambda,Gamma(:,i)','LineWidth',2)







%view(0,90)


function [Gamma1,Z1] = multidiels(n,L,lambda,theta,pol)

if nargin==0, help multidiel1; return; end
if nargin<=4, pol='te'; end
if nargin==3, theta=0; end

if size(n,2)==1, n = n'; end 

M = length(n)-2;                                % number of slabs

if M==0, L = []; end                            % single interface, no slabs

theta = theta * pi/180;
                                                                
% costh = conj(sqrt(conj(1 - (n(1) * sin(theta) ./ n).^2)));    % old version 
                                                                
costh = sqrte(1 - (n(1) * sin(theta) ./ n).^2);                 % new version - 9/14/07

if pol=='te' | pol=='TE',
    nT = n .* costh;                            % transverse refractive indices
else
    nT = n ./ costh;                          % TM case, fails at 90 deg for left medium
end

if M>0,
    L = L .* costh(2:M+1);                      % n(i)*l(i)*cos(th(i))
end

r = -diff(nT) ./ (diff(nT) + 2*nT(1:M+1));      % r(i) = (n(i-1)-n(i)) / (n(i-1)+n(i))   

Gamma1 = r(M+1) * ones(1,length(lambda));       % initialize Gamma at right-most interface

for i = M:-1:1,
    delta = 2*pi*L(i)./lambda;                  % phase thickness in i-th layer
    z = exp(-2*j*delta);                          
    Gamma1 = (r(i) + Gamma1.*z) ./ (1 + r(i)*Gamma1.*z);
end

Z1 = (1 + Gamma1) ./ (1 - Gamma1);

end





