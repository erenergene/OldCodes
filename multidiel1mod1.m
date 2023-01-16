%% multidiel1mod1.m - modified version of multidiel1.m

clear vars
close all

% multidiel1.m - simplified version of multidiel for isotropic layers
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

% KODU AL BASKA BI YERE YAPISTIR
% 
% POWERPOINT
% 
% ONCE ONCE DALGA BOYU LAMBDA/2N GOSTER ILK MINIMUM LAMBDA/4
% SIRAYLA HERSEYI ANLAT
% SPECTRUMLAR
% BUTUN KODLAR NASIL OLDU ANLAT
% GUI BISEY AYARLA ISIK INTENSITYSINI AYARLAMAK ICIN


load("spectra.mat",'spectra')
blue = spectra{1,1};
green = spectra{1,2};
yellow = spectra{1,3};
red = spectra{1,4};
x_axis = blue(:,1);
x_axis = x_axis(251:1620);
bluespectrum = blue(:,2)*100;
bluespectrum = bluespectrum(251:1620);
greenspectrum = green(:,2)*100;
greenspectrum = greenspectrum(251:1620);
redspectrum = red(:,2)*100;
redspectrum = redspectrum(251:1620);



figure(1) % Si/SiO2 Reflectance for thickness L = 0.08um to 0.14 um

lambda = linspace(0.4,0.68,1370);
lambdarSiO = [0.0684043, 0.1162414, 9.896161];
lambdarSi = [0.301516485, 1.13475115, 1104];

BsiO = [0.6961663, 0.4079426, 0.8974794];
Bsi = [10.6684293, 0.0030434748, 1.54133408];

nsqrSi =sellmeier(Bsi,lambdarSi,lambda);
nsqrSiO =sellmeier(BsiO,lambdarSiO,lambda);

nrSi = (sqrt(nsqrSi)+conj(sqrt(nsqrSi)))/2;
nrSiO = (sqrt(nsqrSiO)+conj(sqrt(nsqrSiO)))/2;


theta=0;
L = linspace(0.08,0.14,1370); %Thickness from 0.08 um to 0.14 um
Z1 = [];
Gamma1 = [];

for i = 1:numel(lambda);
for j = 1:numel(L); 
[Gamma1(i,j),Z1(i,j)] = multidiels([1; nrSiO(1,i); nrSi(1,i)],L(j).*nrSiO(1,i),lambda(1,i));
end
end

[MLam, MThicc] = meshgrid(lambda,L);
Gamma = conj(Gamma1).*Gamma1;
surgraph = surf(MLam,MThicc,Gamma,'EdgeColor','none');
title('Si/SiO2 Reflectance')
xlim([0.4 0.68])
ylim([0.08 0.14])
cb = colorbar;
cb.Location = 'southoutside';
xlabel('Lambda (\mum)');
ylabel('L (\mum)');
zlabel('Reflectance');
caxis([0 0.5]);

figure(2) %RGB Light Intensities

hold on
Bi = 297; % Blue wavelength = 460 nm
Gi = 736; % Green wavelength = 550 nm
Ri = 1370; % Red wavelength = 680 nm
IB = 1; %Intensity of Blue Light
IG = 1; %Intensity of Green Light
IR = 1; %Intensity of Red Light
ScB = 1; %?
ScG = 1; %?
ScR = 1; %?

plot(L,ScB.*IB.*Gamma(Bi,:),'b','LineWidth',2)
plot(L,ScG.*IG.*Gamma(Gi,:),'g','LineWidth',2)
plot(L,ScR.*IR.*Gamma(Ri,:),'r','LineWidth',2)

%distance between 2 peaks = λ/2n 
% n: refractive index = 1.3

legend('Blue','Green','Red')
title('RGB Light Intensities')
xlabel('L (\mum)','FontSize',16);
ylabel('Reflectance','FontSize',16');
xlim([0.08 0.14])
hold off

figure(3) %Observed Color without correcting for LEDs

Gamma_R = IR.*Gamma(Ri,:);
Gamma_G = IG.*Gamma(Gi,:);
Gamma_B = IB.*Gamma(Bi,:);

hold on

Genmatrix = [Gamma_R;Gamma_G;Gamma_B];
MaxGamma = max(Genmatrix);
norm_values = uint8(round((Genmatrix ./ MaxGamma).* 255))';
norm_values = reshape(norm_values,1,1370,3);

for i=1:6
    norm_values = [norm_values;norm_values];
end

imshow(norm_values)
title('Observed Color Without Correcting for LEDs')
xlabel('L (\mum)','FontSize',16);
ylabel('Color','FontSize',16)
hold off

figure(4) %LED Light Intensities
hold on
plot(x_axis,ScB.*IB.*bluespectrum,'b','LineWidth',2)
plot(x_axis,ScG.*IG.*greenspectrum,'g','LineWidth',2)
plot(x_axis,ScR.*IR.*redspectrum,'r','LineWidth',2)
title('LED Light Intensities')
xlabel('Wavelength (nm)')
ylabel('Intensity')
hold off

figure(5) %Reflectance for different thicknesses & increasing wavelength
D1 = 1; %L = 0.08 um
D2 = 736; %L = 0.11 um
D3 = 1370; %L = 0.14 um

hold on
plot(lambda,IB.*Gamma(:,D1)','b','LineWidth',2)
plot(lambda,IG.*Gamma(:,D2)','g','LineWidth',2)
plot(lambda,IR.*Gamma(:,D3)','r','LineWidth',2)
title('Reflectance for different thicknesses & increasing wavelength')
xlabel('wavelength (um)')
ylabel('intensity')
legend('L = 80 nm', 'L = 110 nm' , 'L = 140 nm')
hold off

figure(6) %Reflectance at 0.08 um under red light
hold on 
plot(lambda,IB.*Gamma(D1,:),'b','LineWidth',2)
plot(lambda,redspectrum,'r','Linewidth',2)
plot(lambda,Gamma(D1,:)'.*redspectrum,'g','Linewidth',2 )
title('Reflectance at 0.08 um under red light')
xlabel('wavelength (nm)')
ylabel('intensity')
legend('Reflectance at thickness 0.08 uM','Red Spectrum','Product')

figure(7)

L = linspace(0.08,0.14,1370); %Observed Light Corrected for LEDs

I_refred = [];
I_refgreen = [];
I_refblue = [];

for i=1:1370
    I_refred(:,i) = sum(Gamma(:,i).*ScR.*IR.*redspectrum);
    I_refgreen(:,i) = sum(Gamma(:,i).*ScG.*IG.*greenspectrum);
    I_refblue(:,i) = sum(Gamma(:,i).*ScB.*IB.*bluespectrum);
end 

hold on
plot(L,I_refblue/100,'b','LineWidth',2)
plot(L,I_refgreen/100,'g','LineWidth',2)
plot(L,I_refred/100,'r','LineWidth',2)
title('Observed Light Corrected for LEDs')
legend('Blue','Green','Red')
xlabel('L (\mum)','FontSize',16);
ylabel('Reflectance','FontSize',16');
xlim([0.08 0.14])
hold off

figure(8) %Observed color corrected for LEDs
I_tot = cat(3, I_refred, I_refgreen, I_refblue)
% I_tot = [I_refred; I_refgreen; I_refblue];
% I_tot = reshape(I_tot, [1,1370,3])
I_totnorm = (I_tot./max(I_tot)).*255;
%NORMALIZATIONDA BIR SIKINTI OLABILIR: R = 1 B&G = 0.1 DE CALISMIYOR!!!!
%HEPSI = 1 ILE AYNI SONUC VERIYOR

for i = 1:6
    I_totnorm = [I_totnorm; I_totnorm];
end

imtot = uint8(round(I_totnorm));
imagesc(imtot)
set(gca,'YDir','normal')
ylim([1,30])
title('Observed Color Corrected for LEDs')
xlabel('Thickness')
xticks([1 196.5714 392.1429 587.7143 783.2857 978.8571 1174.4 1370])
xticklabels([0.08 0.0886 0.0971 0.1057 0.1143 0.1229 0.1314 0.14])

% I_rednorm = I_refred/max(max(I_refred))*255;
% I_totnormred = [I_rednorm zeros(size(I_rednorm)) zeros(size(I_rednorm))];
% I_totnormred = reshape(I_totnormred,[1,1370,3]);
% 
% imred = uint8(round(I_totnormred));
% imshow(imred)
% 
% figure(8)
% 
% I_refgreen = []
% for i=1:1370
%     I_refgreen(:,i) = sum(sum(Gamma(i,:)'.*greenspectrum));
% end
% 
% I_greennorm = I_refgreen/max(max(I_refgreen))*255;
% I_totnormgreen = [zeros(size(I_greennorm)) I_greennorm zeros(size(I_greennorm))];
% I_totnormgreen = reshape(I_totnormgreen,[1,1370,3]);
% for i = 1:6
%     I_totnormgreen = [I_totnormgreen; I_totnormgreen];
% end
% 
% imgreen = uint8(I_totnormgreen);
% imshow(imgreen)
% 
% figure(9)
% 
% I_refblue = []
% for i=1:1370
%     I_refblue(:,i) = sum(sum(Gamma(i,:)'.*bluespectrum));
% end
% 
% I_bluenorm = I_refblue/max(max(I_refblue))*255;
% I_totnormblue = [zeros(size(I_bluenorm)) zeros(size(I_bluenorm)) I_bluenorm];
% I_totnormblue = reshape(I_totnormblue,[1,1370,3]);
% for i = 1:6
%     I_totnormblue = [I_totnormblue; I_totnormblue];
% end
% 
% imblue = uint8(I_totnormblue);
% imshow(imblue)
% 
% figure(10)
% rgbim = imred+imgreen+imblue
% imshow(rgbim)




%  hold on
%  plot(L,Redref)
%  ylim([0 1])
% for d=1:1370
%     I_ref = Redref.*redspectrum
% end























