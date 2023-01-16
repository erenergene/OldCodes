% Talltest.m - Tall Array Calculation trials 

tic
clc; clearvars; close all;
fprintf('Beginning to run %s.m ...\n', mfilename);
addpath(genpath(pwd))
numval = 2740;
%% START NEW IMAGE LOAD
dirfold = uigetdir("C:\Tepegoz\iRiS_Kinetics_Github\experiments\Images","Select Folder for RGB Images");
dispdir = extractAfter(dirfold,"C:\Tepegoz\iRiS_Kinetics_Github\experiments\Images\")
disp(['User selected ', dispdir]);
%%
preChip_no = extractAfter(dispdir,5)
Chip_no = extractBefore(preChip_no,'_')
preExposure = extractAfter(preChip_no,numel(Chip_no)+1)
Exposure = extractBefore(preExposure,'ms')
preFPS = extractAfter(preExposure,numel(Exposure)+3)
FPS = extractBefore(preFPS,'FPS')
preImgCount = extractAfter(preFPS,numel(FPS)+4)
ImgCount = extractBefore(preImgCount,'IMG')
Camera = extractAfter(preImgCount,numel(ImgCount)+4)
%
dirbefore = extractBefore(dirfold,'_CHIP')
dirafter = extractAfter(dirfold,'es\_')
dirB = append(dirfold,'\B_',dirafter)
dirG = append(dirfold,'\G_',dirafter)
dirR = append(dirfold,'\R_',dirafter)

% clearvars -except dirR dirG dirB;
%%
% ds = datastore("C:\Tepegoz\iRiS_Kinetics_Github\ahu.mat",'Type','tall')

% RSTACK = fcn(dirR)
%%

fdsR = fileDatastore(dirR,"ReadFcn",@MyReadFcn);
fdsG = fileDatastore(dirG,"ReadFcn",@MyReadFcn);
fdsB = fileDatastore(dirB,"ReadFcn",@MyReadFcn);
%%

tR = tall(fdsR)
tG = tall(fdsG)
tB = tall(fdsB)


% a = fdsR.Files
%%
% fdsR.Selected = {"data"}
%%


% tR.avg = mean(tR)

% ds = datastore(dirR,'tall')
% clearvars -except dirR
% A = rand(100,100);
% save ahu.mat
