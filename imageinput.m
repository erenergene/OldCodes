% imageinput.m - Get image files as .mat files -including time difference

clearvars

[R_Tiff_Name,R_Tiff_Path] = uigetfile('*.mat','Red Stack'); %Import Unknown Thickness: Red Image
if isequal(R_Tiff_Name,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(R_Tiff_Name,R_Tiff_Path)]);
   R_Stack_pre = load(strcat(R_Tiff_Path, R_Tiff_Name));
end

[G_Tiff_Name,G_Tiff_Path] = uigetfile('*.mat','Green Stack'); %Import Unknown Thickness: Green Image
if isequal(G_Tiff_Name,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(G_Tiff_Name,G_Tiff_Path)]);
   G_Stack_pre = load(strcat(G_Tiff_Path, G_Tiff_Name));
end

[B_Tiff_Name,B_Tiff_Path] = uigetfile('*.mat','Blue Stack'); %Import Unknown Thickness: Blue Image
if isequal(B_Tiff_Name,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(B_Tiff_Name,B_Tiff_Path)]);
   B_Stack_pre = load(strcat(B_Tiff_Path, B_Tiff_Name));
end

tic

 clearvars -except R_Stack_pre B_Stack_pre G_Stack_pre 
%%

R_Stack = struct2cell(R_Stack_pre);
G_Stack = struct2cell(G_Stack_pre);
B_Stack = struct2cell(B_Stack_pre);

Rims = R_Stack(1:2:end);
Rtimes =R_Stack(2:2:end);
Gims = G_Stack(1:2:end);
Gtimes = G_Stack(2:2:end);
Bims = B_Stack(1:2:end);
Btimes = B_Stack(2:2:end);

[rows, cols] = size(cell2mat(Rims(1)));
nfiles = length(Rims);
%%
R_im_mat = uint16(rand(rows,cols,nfiles));
G_im_mat = uint16(rand(rows,cols,nfiles));
B_im_mat = uint16(rand(rows,cols,nfiles));
%%
for i = 1:nfiles
   R_im_mat(:,:,i) = cat(3,cell2mat(Rims(i)));
   G_im_mat(:,:,i) = cat(3,cell2mat(Gims(i)));
   B_im_mat(:,:,i) = cat(3,cell2mat(Bims(i)));
end

%% time difference

Rtime = cell2mat(Rtimes)
Rtime = double(Rtime)
Gtime = cell2mat(Gtimes)
Gtime = double(Gtime)
Btime = cell2mat(Btimes)
Btime = double(Btime)



%%
toc