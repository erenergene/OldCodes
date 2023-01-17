% fcnG.m - Image Acquisition From Directory Function Trials 

function [imsG] = fcnG(dirG)
% 
% matB = dir(dirB);
matG = dir(dirG);
% matR = dir(dirR);

% matB = (matB(3:end));
matG = (matG(3:end));
% matR = (matR(3:end));

% cellB = struct2cell(matB);
cellG = struct2cell(matG);
% cellR = struct2cell(matR);

% imsB = cellB(1,:);
imsG = cellG(1,:);
% imsR = cellR(1,:);
end