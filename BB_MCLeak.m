%% BB_MCLeak.m - Breadboard for multicolor leakage analysis

clc; clear; clearvars

% Leakage: 

%%
R_im = RLight_Tiff - (RLeak_for_BLight + RLeak_for_GLight);
figure(5)
imshow(R_im)

G_im = GLight_Tiff - (GLeak_for_RLight + GLeak_for_BLight);
figure(6)
imshow(G_im)

B_im = BLight_Tiff - (BLeak_for_RLight + BLeak_for_GLight);
figure(7)
imshow(B_im)
%%
% Combination after leakage correction

RGB_Combo_Unleaked = (R_im.*R_Mask) + (G_im.*G_Mask) + (B_im.*B_Mask);

RGB_Combo_Unleaked_Demosaic = demosaic(RGB_Combo_Unleaked,'rggb');
figure(8)
imshow(RGB_Combo_Unleaked_Demosaic)
imwrite(RGB_Combo_Unleaked_Demosaic,'RGB_Combo_Unleaked_Demosaic.tif')

% Calculating thicknesses using reflectences from eren's code. 
% This part of the code has two major problems:
% 1. The way RefRed_at_XnmO2 (reflectance at 'unknown' SiO2 thickness) is
% calculated is prone to errors when G_im (image under green light,
% adjusted for leakage of other light at dark) has very small values
% compared to G_Chan (green channel of image of 'unknown' SiO2 thickness
% under green light).
% 2. The way mean reflectance values are calculated does not account for zero values that may
% occur in the pixels of interest.
%%
I_inR = (R_im.*R_Mask)./ .4028;
I_inG = (G_im.*G_Mask)./ .3720;
I_inB = (B_im.*B_Mask)./ .3448;

% I_inR = (255*((R_im.*R_Mask)./max(max(R_im.*R_Mask))))./ 40.28;
% I_inG = (255*((G_im.*G_Mask)./max(max((G_im.*G_Mask))))./ 37.20;
% I_inB = (255*((B_im.*G_Mask)./max(max(B_im.*G_Mask))))./ 34.48;

% Normalise intensity (Added on 18 MAY 2022)
I_inRn = 255*(I_inR./max(max(I_inR)));
I_inGn = 255*(I_inG./max(max(I_inG)));
I_inBn = 255*(I_inB./max(max(I_inB)));
%% 
RefRed_at_XnmO2 = (255*(R_Chan./max(max(R_Chan))))./I_inRn;
RefGre_at_XnmO2 = (255*(G_Chan./max(max(G_Chan))))./I_inGn;
RefBlu_at_XnmO2 = (255*(B_Chan./max(max(B_Chan))))./I_inBn;
%%
MeanRefRed_at_XnmO2 = mean(mean(nonzeros(RefRed_at_XnmO2)));
MeanRefGre_at_XnmO2 = mean(mean(nonzeros(RefGre_at_XnmO2)));
MeanRefBlu_at_XnmO2 = mean(mean(nonzeros(RefBlu_at_XnmO2)));

MeanRefRed_at_XnmO2 = 0.12;
MeanRefGre_at_XnmO2 = 0.11;
MeanRefBlu_at_XnmO2 = 0.13;


load("reftocurve_data.mat")
esti_L = reftocurve(MeanRefRed_at_XnmO2,MeanRefGre_at_XnmO2,MeanRefBlu_at_XnmO2);

figure(9)

hold on
plot(lambda,Gamma(:,valtoindex_L(abs(esti_L))),'m--','LineWidth',2)           %Estimated nm thickness
plot(lambda,Gamma(:,valtoindex_L(abs(esti_L+0.001))),'c--','LineWidth',2)     %Estimated +1 nm thickness
plot(lambda,Gamma(:,valtoindex_L(abs(esti_L-0.001))),'y--','LineWidth',2)     %Estimated -1 nm thickness

plot(cw_r,MeanRefRed_at_XnmO2,'r.','MarkerSize',30)
plot(cw_g,MeanRefGre_at_XnmO2,'g.','MarkerSize',30)
plot(cw_b,MeanRefRed_at_XnmO2,'b.','MarkerSize',30)
xlabel('lambda (\mum)')
ylabel('Reflectance')
xlim([0.4 0.68])
ylim([0 0.45])
legend1 = sprintf('L = %0.2f nm', 1000*esti_L);
legend2 = sprintf('L = %0.2f nm', 1000*(esti_L+0.001));
legend3 = sprintf('L = %0.2f nm', 1000*(esti_L-0.001));
legend(legend1, legend2, legend3,'Ref at R','Ref at G','Ref at B','location','bestoutside')
fprintf('Estimated thickness is %f nm \n',esti_L*1000)

%%
% Leaktest Stats:
% Means of each nonzero pixel are taken for image taken under X colour (XLight_Tiff),
% means of X_im (image under X coloured light, adjusted for leakage of the other two colours of light at dark)
% are taken. For each colour:
% [(mean of non zero indeces of XLight_Tiff)-(mean of non zero indeces of X_im)]/(mean of non zero indeces of XLight_Tiff)
% is used to calculate leakage. This value is multiplied by 100 to get a
% percentage. 

R_Mean = mean(RLight_Tiff,2);
%R_Std = std(RLight_Tiff);
percentleak_R = 100*((mean(mean(nonzeros(RLight_Tiff)))-mean(mean(nonzeros(R_im))))/mean(mean(nonzeros(RLight_Tiff))));

G_Mean = mean(GLight_Tiff);
%G_Std = std(GLight_Tiff);
percentleak_G = 100*((mean(mean(nonzeros(GLight_Tiff)))-mean(mean(nonzeros(G_im))))/mean(mean(nonzeros(GLight_Tiff))));

B_Mean = mean(BLight_Tiff);
%B_Std = std(BLight_Tiff);
percentleak_B = 100*((mean(mean(nonzeros(BLight_Tiff)))-mean(mean(nonzeros(B_im))))/mean(mean(nonzeros(BLight_Tiff))));

fprintf('Leakege of green and blue light into red pixel is %f percent. \n',percentleak_R);
fprintf('Leakege of red and blue light into green pixel is %f percent. \n',percentleak_G);
fprintf('Leakege of red and green light into blue pixel is %f percent. \n',percentleak_B);

% Ellipsometry:
% https://www.jawoollam.com/resources/ellipsometry-tutorial/interaction-of-light-and-materials
% http://homes.nano.aau.dk/kp/Ellipsometry/main.pdf
% Thickness from reflectence
% https://opg.optica.org/ao/fulltext.cfm?uri=ao-48-5-985
% ehe