%% multidiel_fin_algo_v1.m - Reflectance Simulations with algorithm

clc; clearvars; close all;

% Define variables for input in multidiels function: 

L = linspace(0,0.14,501); %SiO2 Thickness from 0 nm (Si) to 140 nm. 
lambda = linspace(0.3,0.8,501); %Wavelength of LED from  nm to 680 nm. 
% Functions valtoindex_L & valtoindex_lambda are used to convert L or
% lambda value to MATLAB index

theta = 0; %incidence angle from left medium (in degrees)

%Below are B and C constants for Si and SiO2 to use in Sellmeier equation.

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
surgraph = surf(MLam,MThicc,Gamma,'EdgeColor','none');
title('Si/SiO2 Reflectance')
xlim([0.3 0.8])
xticks([0.3 0.3625 0.425 0.4875 0.55 0.6125 0.675 0.7375 0.8])
xticklabels([0 0.02 0.04 0.06 0.08 0.10 0.12 0.14])
ylim([0 0.14])
yticks([0 0.02 0.04 0.06 0.08 0.10 0.12 0.14])
yticklabels([0.4 0.44 0.48 0.52 0.56 0.60 0.64 0.68])
cb = colorbar;

cb.Location = 'eastoutside';
xlabel('L (\mum)');
ylabel('Lambda (\mum)');
zlabel('Reflectance (%)');
caxis([0 0.5]);

% COMPARISON
% Reflectivity from Gamma matrix at wavelengths 449 nm and 521 nm & thicknesses 72 nm, 77 nm, and 
% 82 nm are compared to figures 3 & 4 in https://www.researchgate.net/figure/Surface-reflectivity-versus-silicon-dioxide-layer-thickness_fig3_230952570