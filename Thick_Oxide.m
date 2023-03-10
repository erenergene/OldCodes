% Thick_Oxide.m - Thick (10 microns) Oxide Simulations

tic

clc; clearvars; close all;

% Define variables for input in multidiels function: 

L = linspace(0,10,2740); %SiO2 Thickness from 0 nm (Si) to 140 nm. 
lambda = linspace(0.4,0.68,2740); %Wavelength of LED from 400 nm to 680 nm. 
% Functions valtoindex_L & valtoindex_lambda are used to convert L or
% lambda value to MATLAB index

theta = 0; %incidence angle from left medium (in degrees)

%Below are B and C constants for Si and SiO2 to use in Sellmeier equation.
%B and C values taken from https://refractiveindex.info/

B_Si = [10.6684293 0.0030434748 1.54133408]; %B Constants for Si [B1, B2, B3]
B_SiO = [0.6961663 0.4079426 0.8974794]; %B Constants for SiO2 [B1, B2, B3]

C_Si = [0.301516485 1.13475115 1104]; %C Constants for Si [C1, C2, C3]
C_SiO = [0.0684043 0.1162414 9.896161]; %C Constants for SiO2 [C1, C2, C3]



nsqrSi =sellmeier(B_Si,C_Si,lambda); %Find refractive index values for Si at each wavelength
nsqrSiO =sellmeier(B_SiO,C_SiO,lambda); %Find refractive index values for SiO2 at each wavelength

nrSi = (sqrt(nsqrSi)+conj(sqrt(nsqrSi)))/2; %Si refractive index to input in multidiels
nrSiO = (sqrt(nsqrSiO)+conj(sqrt(nsqrSiO)))/2; %SiO2 refractive index to input in multidiels

% Calculate and display Gamma matrix from inputs above. Gamma(lambda,L) is a matrix for Si/SiO2
% reflectivity. The variables are light wavelength (lambda) and SiO2 thickness (L). 
% Usage: [Gamma,Z] = multidiels(n,L,lambda,theta,pol) Theta and pol are 0, so they are not included

Z1 = [];
Gamma1 = [];

for i = 1:numel(lambda)
for j = 1:numel(L)
[Gamma1(i,j),Z1(i,j)] = multidiels([1;nrSiO(1,i);nrSi(1,i)],L(j).*nrSiO(1,i),lambda(1,i));
end
end

[MLam, MThicc] = meshgrid(lambda,L);
Gamma = conj(Gamma1).*Gamma1; %Multiply Gamma with conjugate to get rid of imaginary component

figure(1)

[MLam, MThicc] = meshgrid(lambda,L);
Gamma = conj(Gamma1).*Gamma1; %Multiply Gamma with conjugate to get rid of imaginary component

surgraph = surf(MLam,MThicc,Gamma,'EdgeColor','none');
title('Si/SiO2 Reflectance')
xlim([0.4 0.68])
xticks([0.4 0.44 0.48 0.52 0.56 0.60 0.64 0.68])
xticklabels([0 0.0428 0.0857 0.128 0.1714 0.2142 0.2572 0.3])
ylim([0 0.3])
yticks([0 0.0428 0.0857 0.128 0.1714 0.2142 0.2572 0.3])
yticklabels([0.4 0.44 0.48 0.52 0.56 0.60 0.64 0.68])
cb = colorbar;

cb.Location = 'eastoutside';
xlabel('L (\mum)');
ylabel('Lambda (\mum)');
zlabel('Reflectance (%)');
caxis([0 0.5]);

load("spectra.mat",'spectra') %Load spectrum data
blue = spectra{1,1}; %LED Spectrum for B
green = spectra{1,2}; %LED Spectrum for G
red = spectra{1,4}; %LED Spectrum for R
bluespectrum = blue(:,2)*100;
bluespectrum = bluespectrum(251:1620); %Blue Spectrum from 400 to 680 nm
bluespectrum = interp(bluespectrum,2);
greenspectrum = green(:,2)*100;
greenspectrum = greenspectrum(251:1620);
greenspectrum = interp(greenspectrum,2);%Green Spectrum from 400 to 680 nm
redspectrum = red(:,2)*100;
redspectrum = redspectrum(251:1620);
redspectrum = interp(redspectrum,2);%Red Spectrum from 400 to 680 nm

for i = 1:numel(redspectrum)
Ref_spec_red = Gamma(i,valtoindex_L(0))'.*redspectrum; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_spec_green = Gamma(i,valtoindex_L(0))'.*greenspectrum; %Reflectivity spectrum for green at 0 nm (R_g) 
Ref_spec_blue = Gamma(i,valtoindex_L(0))'.*bluespectrum; %Reflectivity spectrum for blue at 0 nm (R_b)
end 

reflectivity_curve_0nm = Gamma(:,valtoindex_L(0));

%Find FWHM of new multiplied images
halfMaxb = (min(Ref_spec_blue) + max(Ref_spec_blue)) / 2;
index1b = find(Ref_spec_blue >= halfMaxb, 1, 'first');
index2b = find(Ref_spec_blue >= halfMaxb, 1, 'last');
fwhmb = index2b-index1b + 1;
fwhmxb = lambda(index2b) - lambda(index1b);

halfMaxg = (min(Ref_spec_green) + max(Ref_spec_green)) / 2;
index1g = find(Ref_spec_green >= halfMaxg, 1, 'first');
index2g = find(Ref_spec_green >= halfMaxg, 1, 'last');
fwhmg = index2g-index1g + 1;
fwhmxg = lambda(index2g) - lambda(index1g);

halfMaxr = (min(Ref_spec_red) + max(Ref_spec_red)) / 2;
index1r = find(Ref_spec_red >= halfMaxr, 1, 'first');
index2r = find(Ref_spec_red >= halfMaxr, 1, 'last');
fwhmr = index2r-index1r + 1;
fwhmxr = lambda(index2r) - lambda(index1r);

%Find center wavelength of I_Out
cw_b = (lambda(index2b)+lambda(index1b))/2;
cw_g = (lambda(index2g)+lambda(index1g))/2;
cw_r = (lambda(index2r)+lambda(index1r))/2;

Ref_at_0nm_R = Gamma(valtoindex_lambda(cw_r),valtoindex_L(0));
Ref_at_0nm_G = Gamma(valtoindex_lambda(cw_g),valtoindex_L(0));
Ref_at_0nm_B = Gamma(valtoindex_lambda(cw_b),valtoindex_L(0));
Ref_at_120nm_R = Gamma(valtoindex_lambda(cw_r),valtoindex_L(0.12));
Ref_at_120nm_G = Gamma(valtoindex_lambda(cw_g),valtoindex_L(0.12));
Ref_at_120nm_B = Gamma(valtoindex_lambda(cw_b),valtoindex_L(0.12));

%%

figure(2)

hold on
plot(L,Gamma(valtoindex_lambda(0.46),:),'b','LineWidth',2) %Reflectivity curve at 460 nm (blue)
plot(L,Gamma(valtoindex_lambda(0.53),:),'g','LineWidth',2) %Reflectivity curve at 530 nm (green)
plot(L,Gamma(valtoindex_lambda(0.625),:),'r','LineWidth',2) %Reflectivity curve at 625 nm (red)
legend('Blue','Green','Red')
title('RGB Light Reflectivity')
xlabel('L (\mum)','FontSize',16);
ylabel('Reflectivity (%)','FontSize',16');
xlim([0 10])
hold off
%%
figure(3) %Wavelength vs Reflectance for different thicknesses

L_0um = valtoindex_L(0); %SiO2 Thickness at 0 um 
L_5um = valtoindex_L(5); %SiO2 Thickness at 5 um
L_10um = valtoindex_L(10); %SiO2 Thickness at 10 um 

hold on
plot(lambda,Gamma(:,L_0um),'r','LineWidth',2)
plot(lambda,Gamma(:,L_5um),'g','LineWidth',2)
plot(lambda,Gamma(:,L_10um),'b','LineWidth',2)
xlim([0.4 0.68])
xlabel('Wavelength \mum)')
ylabel('Reflectance (%)')
title('Wavelength vs Reflectance for different thicknesses')
legend('L = 0 um', 'L = 5 um', 'L = 10 um')

for i = 1:2740
Ref_spec_red = Gamma(i,valtoindex_L(0))'.*redspectrum; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_spec_green = Gamma(i,valtoindex_L(0))'.*greenspectrum; %Reflectivity spectrum for green at 0 nm (R_g) 
Ref_spec_blue = Gamma(i,valtoindex_L(0))'.*bluespectrum; %Reflectivity spectrum for blue at 0 nm (R_b)
end 

reflectivity_curve_0nm = Gamma(:,valtoindex_L(0)); %Reflectivity curve at 0 nm (used above)

figure(4)
hold on
plot(lambda,reflectivity_curve_0nm,'k-','LineWidth',2) %Reflectivity curve at 0 nm 
plot(lambda,redspectrum,'r','Linewidth',2) %Red spectrum before multiplication
plot(lambda,greenspectrum,'g','Linewidth',2) %Green spectrum before multiplication
plot(lambda,bluespectrum,'b','Linewidth',2) %Blue spectrum before multiplication
plot(lambda,Ref_spec_red,'r','Linewidth',2) %Red spectrum after multiplication
plot(lambda,Ref_spec_green,'g','Linewidth',2) %Green spectrum after multiplication
plot(lambda,Ref_spec_blue,'b','Linewidth',2) %Blue spectrum after multiplication
xlabel('Wavelength (nm)')
xlim([0.4 0.68])
ylabel('Reflectivity')
title('Reflectivity Curve for Silicon at 0 nm (no oxide)')
legend('Reflectivity Curve for Silicon at 0 nm','Red Spectrum','Green Spectrum','Blue Spectrum','location','north')
%%
%Find FWHM of new multiplied images
halfMaxb = (min(Ref_spec_blue) + max(Ref_spec_blue)) / 2;
index1b = find(Ref_spec_blue >= halfMaxb, 1, 'first');
index2b = find(Ref_spec_blue >= halfMaxb, 1, 'last');
fwhmb = index2b-index1b + 1;
fwhmxb = lambda(index2b) - lambda(index1b);

halfMaxg = (min(Ref_spec_green) + max(Ref_spec_green)) / 2;
index1g = find(Ref_spec_green >= halfMaxg, 1, 'first');
index2g = find(Ref_spec_green >= halfMaxg, 1, 'last');
fwhmg = index2g-index1g + 1;
fwhmxg = lambda(index2g) - lambda(index1g);

halfMaxr = (min(Ref_spec_red) + max(Ref_spec_red)) / 2;
index1r = find(Ref_spec_red >= halfMaxr, 1, 'first');
index2r = find(Ref_spec_red >= halfMaxr, 1, 'last');
fwhmr = index2r-index1r + 1;
fwhmxr = lambda(index2r) - lambda(index1r);

%Find center wavelength of I_Out
cw_b = (lambda(index2b)+lambda(index1b))/2;
cw_g = (lambda(index2g)+lambda(index1g))/2;
cw_r = (lambda(index2r)+lambda(index1r))/2;

%Find reflectance values at center wavelength
Ref_at_blue = reflectivity_curve_0nm(valtoindex_lambda(cw_b)); %Reflectivity at blue (455 nm)
Ref_at_green = reflectivity_curve_0nm(valtoindex_lambda(cw_g)); %Reflectivity at green (521.2 nm)
Ref_at_red = reflectivity_curve_0nm(valtoindex_lambda(cw_r)); %Reflectivity at red (634.2 nm)



% %Find intersection points of reflectivity curve and RGB spectrum
% 
% intsct_b1 = find(bluespectrum >= reflectivity_curve_0nm, 1, 'first');
% intsct_b2 = find(bluespectrum >= reflectivity_curve_0nm, 1, 'last');
% intsct_g1 = find(greenspectrum >= reflectivity_curve_0nm, 1, 'first')
% intsct_g2 = find(greenspectrum >= reflectivity_curve_0nm, 1, 'last')
% intsct_r1 = find(redspectrum >= reflectivity_curve_0nm, 1, 'first')
% intsct_r2 = find(redspectrum >= reflectivity_curve_0nm, 1, 'last')
%%
figure(7)

I_refred = []; %Reflected Intensity for red
I_refgreen = []; %Reflected Intensity for green
I_refblue = []; %Reflected Intensity for blue

for i=1:2739
    I_refred(:,i) = sum(Gamma(:,i).*Ref_spec_red);          %Multiply reflectance with I_Out for every thickness and sum to find total reflected intensity
    I_refgreen(:,i) = sum(Gamma(:,i).*Ref_spec_green);      %Multiply reflectance with I_Out for every thickness and sum to find total reflected intensity
    I_refblue(:,i) = sum(Gamma(:,i).*Ref_spec_blue);        %Multiply reflectance with I_Out for every thickness and sum to find total reflected intensity
end 
hold on
plot(L,I_refblue/100,'b','LineWidth',2)
plot(L,I_refgreen/100,'g','LineWidth',2)
plot(L,I_refred/100,'r','LineWidth',2)
title('Reflected Intensity (I_O_u_t) for RGB')
legend('Blue','Green','Red')
xlabel('L (\mum)','FontSize',16);
ylabel('Reflected Intensity (I_O_u_t)','FontSize',16);
hold off
%%
close all
L = linspace(0,10,2740);
dydx_R = diff(I_refred(:))./diff(L(:));
dydx_G = diff(I_refgreen(:))./diff(L(:));
dydx_B = diff(I_refblue(:))./diff(L(:));


L = L(1:2739);
figure(8)
hold on
plot(L,dydx_R,'r','LineWidth',2)
plot(L,dydx_G,'g','LineWidth',2)
plot(L,dydx_B,'b','LineWidth',2)
xlabel('L (\mum)','FontSize',16);
ylabel('dR/dL','FontSize',16);
title('change in reflected intensity over thickness','FontSize',20)
%%
close all
lambda = linspace(0.4,0.68,2740);

dydx_Rlam = diff(I_refred(:))./diff(lambda(:));
dydx_Glam = diff(I_refgreen(:))./diff(lambda(:));
dydx_Blam = diff(I_refblue(:))./diff(lambda(:));
lambda = lambda(1:2739)
figure(8)
hold on
plot(lambda,dydx_R,'r','LineWidth',2)
plot(lambda,dydx_G,'g','LineWidth',2)
plot(lambda,dydx_B,'b','LineWidth',2)
xlabel('wavelength (\mum)','FontSize',16);
ylabel('dR/d\lambda','FontSize',16);
title('change in reflected intensity over wavelength','FontSize',20)
%%
figure(10) %Simulated color for 0-300 nm
I_tot = cat(3, I_refred, I_refgreen, I_refblue);
I_totnorm = uint16(I_totnorm)
I_totnorm = (I_tot./max(I_tot)).*255;

for i = 1:6
    I_totnorm = [I_totnorm; I_totnorm];
end

imtot = uint8(round(I_totnorm));
imagesc(imtot)
set(gca,'YDir','normal')
ylim([1,30])
title('Simulated Color Si-SiO_2')
xlabel('Thickness')
xticks([valtoindex_L(0) valtoindex_L(0.05) valtoindex_L(0.10) valtoindex_L(0.15) valtoindex_L(0.20) valtoindex_L(0.25) valtoindex_L(0.30)])
xticklabels([0 0.05 0.10 0.15 0.20 0.25 0.30])

