% totiff.m - Directory to image function 

function [ims] = totiff(direc)

direc = dirR
%%
mat = dir(direc);
mat = (mat(3:end));
%%
cell = struct2cell(mat);
%%
ims = cell(1,:);
%%


end