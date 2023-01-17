% multidielFin.m - Reflectance Simulations 

clearvars
close all

%Figure 1: Reflectance values with respect to wavelength and thickness 

lambda = linspace(0.4,0.68,1370); %define lambda from 400 nm to 680 nm
L = linspace(0.08,0.14,1370); % define thickness from 80 nm to 140 nm
theta=0; %incidence angle

%define constants for multidiels function
lambdarSiO = [0.0684043, 0.1162414, 9.896161];
lambdarSi = [0.301516485, 1.13475115, 1104];
BsiO = [0.6961663, 0.4079426, 0.8974794];
Bsi = [10.6684293, 0.0030434748, 1.54133408];
nsqrSi =sellmeier(Bsi,lambdarSi,lambda);
nsqrSiO =sellmeier(BsiO,lambdarSiO,lambda);
nrSi = (sqrt(nsqrSi)+conj(sqrt(nsqrSi)))/2;
nrSiO = (sqrt(nsqrSiO)+conj(sqrt(nsqrSiO)))/2;

%Calculate reflectance values
for i = 1:numel(lambda);
for j = 1:numel(L); 
[Gamma1(i,j),Z1(i,j)] = multidiels([1; nrSiO(1,i); nrSi(1,i)],L(j).*nrSiO(1,i),lambda(1,i));
end
end
[MLam, MThicc] = meshgrid(lambda,L);
Gamma = conj(Gamma1).*Gamma1;

%Plot reflectance as a function of thickness and wavelength
figure(1)
surgraph = surf(MLam,MThicc,Gamma,'EdgeColor','none');
xlim([0.4 0.68])
ylim([0.08 0.14])
cb = colorbar;
cb.Location = 'southoutside';
xlabel('Lambda (\mum)','FontSize',16);
ylabel('L (\mum)','FontSize',16);
zlabel('Reflectance (%)','FontSize',16);
title('Reflectance for wavelength 400-680 nm and thickness 80-140 nm')

%Figure 2: Reflectance values for RGB colors from thickness 0 nm to 1000nm

L = linspace(0,1,1370); %define thickness from 0 nm to 1000 nm

%Calculate reflectance values
for i = 1:numel(lambda);
for j = 1:numel(L); 
[Gamma1(i,j),Z1(i,j)] = multidiels([1; nrSiO(1,i); nrSi(1,i)],L(j).*nrSiO(1,i),lambda(1,i));
end
end
[MLam, MThicc] = meshgrid(lambda,L);
Gamma = conj(Gamma1).*Gamma1;
 
Bi = 297;  % Blue wavelength = 460 nm
Gi = 736;  % Green wavelength = 550 nm
Ri = 1370; % Red wavelength = 680 nm
IB = 1;    %Blue light intensity
IG = 0;    %Green light intensity
IR = 1;    %Red light intensity

%Plot reflectance values for RGB colors
figure(2)

hold on
plot(L,IB.*Gamma(Bi,:),'b','LineWidth',2)
plot(L,IG.*Gamma(Gi,:),'g','LineWidth',2)
plot(L,IR.*Gamma(Ri,:),'r','LineWidth',2)
legend('Blue','Green','Red')
xlabel('L (\mum)','FontSize',16);
ylabel('Reflectance (%)','FontSize',16');
title('Reflectance values for RGB colors')

%Figure 3: Calculate and plot reflectance values depending color wavelength
%from thickness 80 nm to 140nm

L = linspace(0.08,0.14,1370); 

%Calculate reflectance values
for i = 1:numel(lambda);
for j = 1:numel(L); 
[Gamma1(i,j),Z1(i,j)] = multidiels([1; nrSiO(1,i); nrSi(1,i)],L(j).*nrSiO(1,i),lambda(1,i));
end
end
[MLam, MThicc] = meshgrid(lambda,L);
Gamma = conj(Gamma1).*Gamma1;

%plot reflectance values depending on color wavelength from 80nm to 140nm
figure(3)

hold on
plot(L,IB.*Gamma(Bi,:),'b','LineWidth',2)
plot(L,IG.*Gamma(Gi,:),'g','LineWidth',2)
plot(L,IR.*Gamma(Ri,:),'r','LineWidth',2)
xlim([0.08 0.14])
legend('Blue','Green','Red')
xlabel('L (\mum)','FontSize',16);
ylabel('Reflectance (%)','FontSize',16');
title('Reflectance for thickness 80nm - 140nm')

%Define spectrum values for RGB LEDs

load("spectra.mat",'spectra')
a = spectra{1,1};
b = spectra{1,2};
c = spectra{1,3};
d = spectra{1,4};
x_axis = a(:,1);
x_axis = x_axis(251:1620);
bluespectrum = a(:,2)*100; 
bluespectrum = bluespectrum(251:1620); %Blue LED Spectrum
greenspectrum = b(:,2)*100;
greenspectrum = greenspectrum(251:1620); %Green LED Spectrum
redspectrum = d(:,2)*100;
redspectrum = redspectrum(251:1620); %Red LED Spectrum

%Plot spectrum intensity values with respect to wavelength

figure(4)
hold on
plot(x_axis,IB.*bluespectrum,'b','LineWidth',2)
plot(x_axis,IG.*greenspectrum,'g','LineWidth',2)
plot(x_axis,IR.*redspectrum,'r','LineWidth',2)
xlabel('Wavelength (nm)')
ylabel('intensity')
title('RGB LED Spectrum Values')
hold off


%Figure 5: Calculate and plot reflectance values vs thickness after spectrum values 
%are implemented

L = linspace(0.08,0.14,1370); %Define thickness from 80 nm to 140 nm

I_refred = [];
I_refgreen = [];
I_refblue = [];

for i=1:1370
    I_refred(:,i) = sum(Gamma(:,i).*IR.*redspectrum);
    I_refgreen(:,i) = sum(Gamma(:,i).*IG.*greenspectrum);
    I_refblue(:,i) = sum(Gamma(:,i).*IB.*bluespectrum);
end 

figure(5)
hold on
plot(L,I_refblue,'b','LineWidth',2)
plot(L,I_refgreen,'g','LineWidth',2)
plot(L,I_refred,'r','LineWidth',2)
xlabel('Thickness (nm)')
ylabel('Reflectance')
title('Reflectance Values After Spectra are Implemented')
%Figure 6: Display image for RGB ligth from thickness 80nm to 140nm

%Combine RGB reflectance values and normalize
I_tot = cat(3, I_refred, I_refgreen, I_refblue);
I_totnorm = (I_tot./max(I_tot)).*255;

%NORMALIZATIONDA BIR SIKINTI OLABILIR: R = 1 B&G = 0.1 DE CALISMIYOR!!!!
%HEPSI = 1 ILE AYNI SONUC VERIYOR

for i = 1:6
    I_totnorm = [I_totnorm; I_totnorm];
end
imtot = uint8(round(I_totnorm));

%Display image observed after normalization

uifigure(6)
imagesc(imtot)
set(gca,'YDir','normal')
ylim([1,30])
xlabel('Thickness')
xticks(linspace(1,1370,7));
xticklabels(linspace(0.08,0.14,7));
title('Produced Image')




