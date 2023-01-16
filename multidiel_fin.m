%% multidiel_fin.m - Reflectance Simulations 

clc 
clearvars
close all

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

%For Polymer and Spots use ref index of glass = 1.5

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
IB = 1; %Intensity in of Blue Light
IG = 1; %Intensity in of Green Light
IR = 1; %Intensity in of Red Light
ScB = 1; %?
ScG = 1; %?
ScR = 1; %?

plot(L,ScB.*IB.*Gamma(Bi,:),'b','LineWidth',2)
plot(L,ScG.*IG.*Gamma(Gi,:),'g','LineWidth',2)
plot(L,ScR.*IR.*Gamma(Ri,:),'r','LineWidth',2)

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

real_redspectrum = zeros(1370,1370)

for i = 1:1370
real_redspectrum = Gamma(i,:)'.*redspectrum;
real_greenspectrum = Gamma(i,:)'.*greenspectrum;
real_bluespectrum = Gamma(i,:)'.*bluespectrum;
end

real_redspectrum = Gamma(1,:)'.*redspectrum;
real_greenspectrum = Gamma(1,:)'.*greenspectrum;
real_bluespectrum = Gamma(1,:)'.*bluespectrum;

figure(6) %Reflectance at 0.08 um under red light
hold on 
plot(lambda,IB.*Gamma(D1,:),'b','LineWidth',2)
plot(lambda,redspectrum,'r','Linewidth',2)
plot(lambda,real_redspectrum,'g','Linewidth',2 )
title('Reflectance at 0.08 um under red light')
xlabel('wavelength (nm)')
ylabel('intensity')
legend('Reflectance at thickness 0.08 uM','Red Spectrum','Product')

figure(7) %Reflectance at 0.08 um under green light
hold on 
plot(lambda,IB.*Gamma(D1,:),'b','LineWidth',2)
plot(lambda,greenspectrum,'r','Linewidth',2)
plot(lambda,real_greenspectrum,'g','Linewidth',2 )
title('Reflectance at 0.08 um under green light')
xlabel('wavelength (nm)')
ylabel('intensity')
legend('Reflectance at thickness 0.08 uM','Green Spectrum','Product')

figure(8) %Reflectance at 0.08 um under blue light
hold on 
plot(lambda,IB.*Gamma(D1,:),'b','LineWidth',2)
plot(lambda,bluespectrum,'r','Linewidth',2)
plot(lambda,real_bluespectrum,'g','Linewidth',2 )
title('Reflectance at 0.08 um under blue light')
xlabel('wavelength (nm)')
ylabel('intensity')
legend('Reflectance at thickness 0.08 uM','Blue Spectrum','Product')

% Take integral
% 
% integral of red light
% 
% 
% redint = trapz(lambda, real_redspectrum);
% greenint = trapz(lambda, real_greenspectrum);
% blueint = trapz(lambda,real_bluespectrum);
% 
% for i = D1:D3
%     redint(i) = trapz(lambda,real_redspectrum(i))
%     greenint(i) = trapz(real_greenspectrum(i))
%     blueint(i) = trapz(real_bluespectrum(i))
% end

figure(9)

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
ylabel('Reflectance','FontSize',16);
xlim([0.08 0.14])
hold off

figure(10) %Observed color corrected for LEDs
I_tot = cat(3, I_refred, I_refgreen, I_refblue)
I_totnorm = (I_tot./max(I_tot)).*255;

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

figure(11) %Color for 120 nm

I_120 = imtot(:,914,:)

for i = 1:6
    I_120 = [I_120 I_120];
end

imagesc(I_120)


