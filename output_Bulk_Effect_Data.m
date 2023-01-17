% output_Bulk_Effect_Data.m - Outputs Bulk_Effect_Data.mat

clearvars

load("Osram_Data.mat")
Gamma = Gamma(1:2691,1:2691);
L = L(1:2691);
lambda = lambda(1:2691);
Osram_Led_Spec_NoInt = table2array(readtable("LED_Engin_Spectrum_Data.csv"));

for i=1:22
Osram_Led_Spec(:,i) = interp(Osram_Led_Spec_NoInt(:,i),3); 
end

Spec_Warm_White_2200K = Osram_Led_Spec(:,2)/(max(max(Osram_Led_Spec(:,2))));
Spec_Warm_White_3000K = Osram_Led_Spec(:,3)/(max(max(Osram_Led_Spec(:,3))));
Spec_Neutral_White_4000K = Osram_Led_Spec(:,4)/(max(max(Osram_Led_Spec(:,4))));
Spec_Cool_White_5500K = Osram_Led_Spec(:,5)/(max(max(Osram_Led_Spec(:,5))));
Spec_Cool_White_6500K = Osram_Led_Spec(:,6)/(max(max(Osram_Led_Spec(:,6))));
Spec_UVA_365nm = Osram_Led_Spec(:,7)/(max(max(Osram_Led_Spec(:,7))));
Spec_Violet_385nm = Osram_Led_Spec(:,8)/(max(max(Osram_Led_Spec(:,8))));
Spec_Violet_395nm = Osram_Led_Spec(:,9)/(max(max(Osram_Led_Spec(:,9))));
Spec_Violet_405nm = Osram_Led_Spec(:,10)/(max(max(Osram_Led_Spec(:,10))));
Spec_DeepBlue_436nm = Osram_Led_Spec(:,11)/(max(max(Osram_Led_Spec(:,11))));
Spec_RoyalBlue_453nm = Osram_Led_Spec(:,12)/(max(max(Osram_Led_Spec(:,12))));
Spec_DentalBlue_460nm = Osram_Led_Spec(:,13)/(max(max(Osram_Led_Spec(:,13))));
Spec_Cyan_500nm = Osram_Led_Spec(:,14)/(max(max(Osram_Led_Spec(:,14))));
Spec_PCLime = Osram_Led_Spec(:,15)/(max(max(Osram_Led_Spec(:,15))));
Spec_Green_517nm = Osram_Led_Spec(:,16)/(max(max(Osram_Led_Spec(:,16))));
Spec_Amber_593nm = Osram_Led_Spec(:,17)/(max(max(Osram_Led_Spec(:,17))));
Spec_PCAmber = Osram_Led_Spec(:,18)/(max(max(Osram_Led_Spec(:,18))));
Spec_Red_633nm = Osram_Led_Spec(:,19)/(max(max(Osram_Led_Spec(:,19))));
Spec_DeepRed_660nm = Osram_Led_Spec(:,20)/(max(max(Osram_Led_Spec(:,20))));
Spec_FarRed_740nm = Osram_Led_Spec(:,21)/(max(max(Osram_Led_Spec(:,21))));
Spec_InfraRed_850nm = Osram_Led_Spec(:,22)/(max(max(Osram_Led_Spec(:,22))));

L = linspace(0,0.3,2706); %SiO2 Thickness from 0 nm to 300 nm
lambda = linspace(0.35,1.1,2706); %wavelength from 350 nm to 1100 nm

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
[Gamma1_n_1_33(i,j),Z1_n_1_33(i,j)] = multidiels([1.33;nrSiO(1,i);nrSi(1,i)],L(j).*nrSiO(1,i),lambda(1,i));
end
end


[MLam, MThicc] = meshgrid(lambda,L);
Gamma_n_1_33 = conj(Gamma1_n_1_33).*Gamma1_n_1_33;
Gamma_n_1_33 = Gamma_n_1_33(1:2691,1:2691);

for i = 1:2691
Ref_Spec_WW_2200K = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Warm_White_2200K; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_WW_3000K = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Warm_White_3000K; 
Ref_Spec_NW_4000K = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Neutral_White_4000K;  
Ref_Spec_CW_5500K = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Cool_White_5500K; 
Ref_Spec_CW_6500K = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Cool_White_6500K;  
Ref_Spec_UVA_365nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_UVA_365nm;  
Ref_Spec_Violet_385nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Violet_385nm;  
Ref_Spec_Violet_395nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Violet_395nm; 
Ref_Spec_Violet_405nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Violet_405nm;  
Ref_Spec_DeepBlue_436nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_DeepBlue_436nm;  
Ref_Spec_RoyalBlue_453nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_RoyalBlue_453nm;  
Ref_Spec_DentalBlue_460nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_DentalBlue_460nm;  
Ref_Spec_Cyan_500nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Cyan_500nm;  
Ref_Spec_PCLime = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_PCLime; 
Ref_Spec_Green_517nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Green_517nm; 
Ref_Spec_Amber_593nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Amber_593nm; 
Ref_Spec_PCAmber = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_PCAmber;
Ref_Spec_Red_633nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_Red_633nm; 
Ref_Spec_DeepRed_660nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_DeepRed_660nm;
Ref_Spec_FarRed_740nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_FarRed_740nm; 
Ref_Spec_InfraRed_850nm = Gamma_n_1_33(i,valtoindex_L(0))'.*Spec_InfraRed_850nm; 
end 

Ref_Spec_WW_2200K = Ref_Spec_WW_2200K(1:2691);
Ref_Spec_WW_3000K = Ref_Spec_WW_3000K(1:2691);
Ref_Spec_NW_4000K = Ref_Spec_NW_4000K(1:2691);
Ref_Spec_CW_5500K = Ref_Spec_CW_5500K(1:2691);
Ref_Spec_CW_6500K = Ref_Spec_CW_6500K(1:2691);
Ref_Spec_UVA_365nm = Ref_Spec_UVA_365nm(1:2691);
Ref_Spec_Violet_385nm = Ref_Spec_Violet_385nm(1:2691);
Ref_Spec_Violet_395nm = Ref_Spec_Violet_395nm(1:2691);
Ref_Spec_Violet_405nm = Ref_Spec_Violet_405nm(1:2691);
Ref_Spec_DeepBlue_436nm = Ref_Spec_DeepBlue_436nm(1:2691);
Ref_Spec_RoyalBlue_453nm = Ref_Spec_RoyalBlue_453nm(1:2691);
Ref_Spec_DentalBlue_460nm = Ref_Spec_DentalBlue_460nm(1:2691);
Ref_Spec_Cyan_500nm = Ref_Spec_Cyan_500nm(1:2691);
Ref_Spec_PCLime = Ref_Spec_PCLime(1:2691);
Ref_Spec_Green_517nm = Ref_Spec_Green_517nm(1:2691);
Ref_Spec_Amber_593nm = Ref_Spec_Amber_593nm(1:2691);
Ref_Spec_PCAmber = Ref_Spec_PCAmber(1:2691);
Ref_Spec_Red_633nm = Ref_Spec_Red_633nm(1:2691);
Ref_Spec_DeepRed_660nm = Ref_Spec_DeepRed_660nm(1:2691);
Ref_Spec_FarRed_740nm = Ref_Spec_FarRed_740nm(1:2691);
Ref_Spec_InfraRed_850nm = Ref_Spec_InfraRed_850nm(1:2691);

%%

for i=1:2691
    I_ref_WW_2200K_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_WW_2200K)./100;         
    I_ref_WW_3000K_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_WW_3000K)./100;     
    I_ref_NW_4000K_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_NW_4000K)./100;        
    I_ref_CW_5500K_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_CW_5500K)./100;
    I_ref_CW_6500K_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_CW_6500K)./100;
    I_ref_UVA_365nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_UVA_365nm)./100;
    I_ref_Violet_385nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_Violet_385nm)./100;
    I_ref_Violet_395nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_Violet_395nm)./100;
    I_ref_Violet_405nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_Violet_405nm)./100;
    I_ref_DeepBlue_436nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_DeepBlue_436nm)./100;
    I_ref_RoyalBlue_453nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_RoyalBlue_453nm)./100;
    I_ref_DentalBlue_460nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_DentalBlue_460nm)./100;
    I_ref_Cyan_500nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_Cyan_500nm)./100;
    I_ref_PCLime_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_PCLime)./100;
    I_ref_Green_517nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_Green_517nm)./100;
    I_ref_Amber_593nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_Amber_593nm)./100;
    I_ref_PCAmber_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_PCAmber)./100;
    I_ref_Red_633nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_Red_633nm)./100;
    I_ref_DeepRed_660nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_DeepRed_660nm)./100;
    I_ref_FarRed_740nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_FarRed_740nm)./100;
    I_ref_InfraRed_850nm_n_1_33(:,i) = sum(Gamma_n_1_33(:,i).*Ref_Spec_InfraRed_850nm./100);
end 

save 'Bulk_Effect_Data.mat','I_ref_WW_2200K_n_1_33','I_ref_WW_3000K_n_1_33','I_ref_NW_4000K_n_1_33','I_ref_CW_5500K_n_1_33','I_ref_CW_6500K_n_1_3','I_ref_UVA_365nm_n_1_33';'I_ref_Violet_385nm_n_1_33';'I_ref_Violet_395nm_n_1_33';' I_ref_Violet_405nm_n_1_33','I_ref_DeepBlue_436nm_n_1_33','I_ref_RoyalBlue_453nm_n_1_33','I_ref_DentalBlue_460nm_n_1_33','I_ref_Cyan_500nm_n_1_33','I_ref_PCLime_n_1_33','I_ref_Green_517nm_n_1_33','I_ref_Amber_593nm_n_1_33','I_ref_PCAmber_n_1_33','I_ref_Red_633nm_n_1_33','I_ref_DeepRed_660nm_n_1_33','I_ref_FarRed_740nm_n_1_33','I_ref_InfraRed_850nm_n_1_33';
% clearvars -except Gamma_n_1_33 L lambda
% save('Bulk_Effect_Data.mat')