% BB_Osram_Analysis.m - Breadboard for Osram LED Analysis

clc; clearvars; close all;

load("Osram_Data.mat")

Osram_Led_Spec_NoInt = table2array(readtable("LED_Engin_Spectrum_Data.csv"));

for i=1:22
Osram_Led_Spec(:,i) = interp(Osram_Led_Spec_NoInt(:,i),3); 
end

Osram_lambda = Osram_Led_Spec(:,1);
Spec_Warm_White_2200K = Osram_Led_Spec(:,2);
Spec_Warm_White_3000K = Osram_Led_Spec(:,3);
Spec_Neutral_White_4000K = Osram_Led_Spec(:,4);
Spec_Cool_White_5500K = Osram_Led_Spec(:,5);
Spec_Cool_White_6500K = Osram_Led_Spec(:,6);
Spec_UVA_365nm = Osram_Led_Spec(:,7);
Spec_Violet_385nm = Osram_Led_Spec(:,8);
Spec_Violet_395nm = Osram_Led_Spec(:,9);
Spec_Violet_405nm = Osram_Led_Spec(:,10);
Spec_DeepBlue_436nm = Osram_Led_Spec(:,11);
Spec_RoyalBlue_453nm = Osram_Led_Spec(:,12);
Spec_DentalBlue_460nm = Osram_Led_Spec(:,13);
Spec_Cyan_500nm = Osram_Led_Spec(:,14);
Spec_PCLime = Osram_Led_Spec(:,15);
Spec_Green_517nm = Osram_Led_Spec(:,16);
Spec_Amber_593nm = Osram_Led_Spec(:,17);
Spec_PCAmber = Osram_Led_Spec(:,18);
Spec_Red_633nm = Osram_Led_Spec(:,19);
Spec_DeepRed_660nm = Osram_Led_Spec(:,20);
Spec_FarRed_740nm = Osram_Led_Spec(:,21);
Spec_InfraRed_850nm = Osram_Led_Spec(:,22);


figure(1)
hold on
plot(Osram_lambda,Spec_UVA_365nm,'LineWidth',2, 'Color', '#DAA8FF')
plot(Osram_lambda,Spec_Violet_385nm,'LineWidth',2,'Color','#BE6CFB')
plot(Osram_lambda,Spec_Violet_395nm,'LineWidth',2,'Color','#A62EFF')
plot(Osram_lambda,Spec_Violet_405nm,'LineWidth',2,'Color','#9D00DC')
plot(Osram_lambda,Spec_DeepBlue_436nm,'LineWidth',2,'Color','#001787')
plot(Osram_lambda,Spec_RoyalBlue_453nm,'LineWidth',2,'Color','#0022C6')
plot(Osram_lambda,Spec_DentalBlue_460nm,'LineWidth',2,'Color','#657FFF')
plot(Osram_lambda,Spec_Cyan_500nm,'LineWidth',2,'Color','#70FFFF')
plot(Osram_lambda,Spec_PCLime,'LineWidth',2,'Color','#68FFC6')
plot(Osram_lambda,Spec_Green_517nm,'LineWidth',2,'Color','#0AE700')
plot(Osram_lambda,Spec_Amber_593nm,'LineWidth',2,'Color','#FF7E00')
plot(Osram_lambda,Spec_PCAmber,'LineWidth',2,'Color','#FF9E43')
plot(Osram_lambda,Spec_Red_633nm,'LineWidth',2,'Color','#FF2B2B')
plot(Osram_lambda,Spec_DeepRed_660nm,'LineWidth',2,'Color','#E90000')
plot(Osram_lambda,Spec_FarRed_740nm,'LineWidth',2,'Color','#A60000')
plot(Osram_lambda,Spec_InfraRed_850nm,'LineWidth',2,'Color','#5B1B1B')
xlim([0.35 1])
xlabel('Wavelength (\mum)')
title('OSRAM LEDs (Colored)')
legend('Ultraviolet (365 nm)','Violet (385 nm)','Violet (395 nm)','Violet (405 nm)','Deep Blue (436 nm)', ...
    'Royal Blue (453 nm)','Dental Blue (460 nm)','Cyan (500 nm)','PC Lime','Green (517 nm)','Amber (593 nm)', ...
    'PC Amber','Red (633 nm)','Deep Red (660 nm)','Far Red (740 nm)','Infrared (850 nm)')

figure(2)
hold on
plot(Osram_lambda,Spec_Warm_White_2200K,'LineWidth',2, 'Color' , '#FFC372' )
plot(Osram_lambda,Spec_Warm_White_3000K,'LineWidth',2, 'Color' , '#FFD7A2')
plot(Osram_lambda,Spec_Neutral_White_4000K,'LineWidth',2, 'Color' , '#ECEAE7')
plot(Osram_lambda,Spec_Cool_White_5500K,'LineWidth',2, 'Color', '#D6E8E8')
plot(Osram_lambda,Spec_Cool_White_6500K,'LineWidth',2, 'Color', '#DEF8F8')
xlim([0.35 0.8])
xlabel('Wavelength (\mum)')
title('OSRAM LEDs (White)')
legend('Warm White 2200K','Warm White 3000K','Neutral White 4000K','Cool White 5500K','Cool White 6500K')
%%

for i = 1:2706
Ref_Spec_WW_2200K = Gamma(i,valtoindex_L(0))'.*Spec_Warm_White_2200K; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_WW_3000K = Gamma(i,valtoindex_L(0))'.*Spec_Warm_White_3000K; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_NW_4000K = Gamma(i,valtoindex_L(0))'.*Spec_Neutral_White_4000K; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_CW_5500K = Gamma(i,valtoindex_L(0))'.*Spec_Cool_White_5500K; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_CW_6500K = Gamma(i,valtoindex_L(0))'.*Spec_Cool_White_6500K; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_UVA_365nm = Gamma(i,valtoindex_L(0))'.*Spec_UVA_365nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_Violet_385nm = Gamma(i,valtoindex_L(0))'.*Spec_Violet_385nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_Violet_395nm = Gamma(i,valtoindex_L(0))'.*Spec_Violet_395nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_Violet_405nm = Gamma(i,valtoindex_L(0))'.*Spec_Violet_405nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_DeepBlue_436nm = Gamma(i,valtoindex_L(0))'.*Spec_DeepBlue_436nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_RoyalBlue_453nm = Gamma(i,valtoindex_L(0))'.*Spec_RoyalBlue_453nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_DentalBlue_460nm = Gamma(i,valtoindex_L(0))'.*Spec_DentalBlue_460nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_Cyan_500nm = Gamma(i,valtoindex_L(0))'.*Spec_Cyan_500nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_PCLime = Gamma(i,valtoindex_L(0))'.*Spec_PCLime; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_Green_517nm = Gamma(i,valtoindex_L(0))'.*Spec_Green_517nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_Amber_593nm = Gamma(i,valtoindex_L(0))'.*Spec_Amber_593nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_PCAmber = Gamma(i,valtoindex_L(0))'.*Spec_PCAmber; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_Red_633nm = Gamma(i,valtoindex_L(0))'.*Spec_Red_633nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_DeepRed_660nm = Gamma(i,valtoindex_L(0))'.*Spec_DeepRed_660nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_FarRed_740nm = Gamma(i,valtoindex_L(0))'.*Spec_FarRed_740nm; %Reflectivity spectrum for red at 0 nm (R_r) 
Ref_Spec_InfraRed_850nm = Gamma(i,valtoindex_L(0))'.*Spec_InfraRed_850nm; %Reflectivity spectrum for red at 0 nm (R_r) 
end 

%%

I_ref_WW_2200K = [];
I_ref_WW_3000K = []; 
I_ref_NW_4000K = []; 
I_ref_CW_5500K = [];
I_ref_CW_6500K = [];
I_ref_UVA_365nm = [];
I_ref_Violet_385nm = [];
I_ref_Violet_395nm = [];
I_ref_Violet_405nm = [];
I_ref_DeepBlue_436nm = [];
I_ref_RoyalBlue_453nm = [];
I_ref_DentalBlue_460nm = [];
I_ref_Cyan_500nm = [];
I_ref_PCLime = [];
I_ref_Green_517nm = [];
I_ref_Amber_593nm = [];
I_ref_PCAmber = [];
I_ref_Red_633nm = [];
I_ref_DeepRed_660nm = [];
I_ref_FarRed_740nm = [];
I_ref_InfraRed_850nm = [];

%%

for i=1:2706
    
    I_ref_WW_2200K(:,i) = sum(Gamma(:,i)'.*Ref_Spec_WW_2200K);          %Multiply reflectance with I_Out for every thickness and sum to find total reflected intensity
%     I_ref_WW_3000K(:,i) = sum(Gamma(:,i).*Ref_Spec_WW_3000K);      %Multiply reflectance with I_Out for every thickness and sum to find total reflected intensity
%     I_ref_NW_4000K(:,i) = sum(Gamma(:,i).*Ref_Spec_NW_4000K);        %Multiply reflectance with I_Out for every thickness and sum to find total reflected intensity
%     I_ref_CW_5500K(:,i) = sum(Gamma(:,i).*Ref_Spec_CW_5500K);
%     I_ref_CW_6500K(:,i) = sum(Gamma(:,i).*Ref_Spec_CW_6500K);
%     I_ref_UVA_365nm(:,i) = sum(Gamma(:,i).*Ref_Spec_UVA_365nm);
%     I_ref_Violet_385nm(:,i) = sum(Gamma(:,i).*Ref_Spec_Violet_385nm);
%     I_ref_Violet_395nm(:,i) = sum(Gamma(:,i).*Ref_Spec_Violet_395nm);
%     I_ref_Violet_405nm(:,i) = sum(Gamma(:,i).*Ref_Spec_Violet_405nm);
%     I_ref_DeepBlue_436nm(:,i) = sum(Gamma(:,i).*Ref_Spec_DeepBlue_436nm);
%     I_ref_RoyalBlue_453nm(:,i) = sum(Gamma(:,i).*Ref_Spec_RoyalBlue_453nm);
%     I_ref_DentalBlue_460nm(:,i) = sum(Gamma(:,i).*Ref_Spec_DentalBlue_460nm);
%     I_ref_Cyan_500nm(:,i) = sum(Gamma(:,i).*Ref_Spec_Cyan_500nm);
%     I_ref_PCLime(:,i) = sum(Gamma(:,i).*Ref_Spec_PCLime);
%     I_ref_Green_517nm(:,i) = sum(Gamma(:,i).*Ref_Spec_Green_517nm);
%     I_ref_Amber_593nm(:,i) = sum(Gamma(:,i).*Ref_Spec_Amber_593nm);
%     I_ref_PCAmber(:,i) = sum(Gamma(:,i).*Ref_Spec_PCAmber);
%     I_ref_Red_633nm(:,i) = sum(Gamma(:,i).*Ref_Spec_Red_633nm);
%     I_ref_DeepRed_660nm(:,i) = sum(Gamma(:,i).*Ref_Spec_DeepRed_660nm);
%     I_ref_FarRed_740nm(:,i) = sum(Gamma(:,i).*Ref_Spec_FarRed_740nm);
%     I_ref_InfraRed_850nm(:,i) = sum(Gamma(:,i).*Ref_Spec_InfraRed_850nm);
end 