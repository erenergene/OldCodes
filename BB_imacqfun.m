%% BB_imacqfun.m - Breadboard for function version of image acquisition

% function [redmat, gremat, blumat] = BB_imacqfun(redDir, greDir, bluDir)
function cell = BB_imacqfun(Direc)

% Direc = dirR;

% redDir = dirR
% greDir = dirG
% bluDir = dirB


%% Specify the folder where the files live.
myFolder = Direc
% myFolderR = redDir;
% myFolderG = greDir;
% myFolderB = bluDir;
%% Check to make sure that folder actually exists.  Warn user if it doesn't.
% if ~isfolder(myFolder)
%     errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder);
%     uiwait(warndlg(errorMessage));
%     myFolder = uigetdir(); % Ask for a new one.
%     if myFolder == 0
%          % User clicked Cancel
%          return;
%     end
% end

%% Specify the folder where the files live.
% myFolderR = redDir;
% myFolderG = greDir;
% myFolderB = bluDir;
%% Check to make sure that folder actually exists.  Warn user if it doesn't.
% if ~isfolder(myFolder)
%     errorMessage = sprintf('Error: The following folder does not exist:\n%s\nPlease specify a new folder.', myFolder);
%     uiwait(warndlg(errorMessage));
%     myFolder = uigetdir(); % Ask for a new one.
%     if myFolder == 0
%          % User clicked Cancel
%          return;
%     end
% end

%% Get a list of all files in the folder with the desired file name pattern.
% tic
filePattern = fullfile(myFolder, '*.mat'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    struc(:,:,k) = load(fullFileName);
end

% THISTIME = toc

%%

cell = (struct2cell(mat));
%%
% tic
% for i = 1:k
% matmat(:,:,i) = cell2mat(cell(:,:,:,i));
% end
% thatime = toc
%% UNCOMMENT BELOW

% %% Get a list of all files in the folder with the desired file name pattern.
% 
% filePatternR = fullfile(myFolderR, '*.mat'); % Change to whatever pattern you need.
% theFilesR = dir(filePatternR);
% for k = 1 : length(theFilesR)
%     baseFileNameR = theFilesR(k).name;
%     fullFileNameR = fullfile(theFilesR(k).folder, baseFileNameR);
%     fprintf(1, 'Now reading %s\n', fullFileNameR);
%     redmat(:,:,k) = load(fullFileNameR);
% end
% 
% %% Get a list of all files in the folder with the desired file name pattern.
% 
% filePatternG = fullfile(myFolderG, '*.mat'); % Change to whatever pattern you need.
% theFilesG = dir(filePatternG);
% for k = 1 : length(theFilesG)
%     baseFileNameG = theFilesG(k).name;
%     fullFileNameG = fullfile(theFilesG(k).folder, baseFileNameG);
%     fprintf(1, 'Now reading %s\n', fullFileNameG);
%     gremat(:,:,k) = load(fullFileNameG);
% end
% 
% %% Get a list of all files in the folder with the desired file name pattern.
% 
% filePatternB = fullfile(myFolderB, '*.mat'); % Change to whatever pattern you need.
% theFilesB = dir(filePatternB);
% for k = 1 : length(theFilesB)
%     baseFileNameB = theFilesB(k).name;
%     fullFileNameB = fullfile(theFilesB(k).folder, baseFileNameB);
%     fprintf(1, 'Now reading %s\n', fullFileNameB);  
%     blumat(:,:,k) = load(fullFileNameB);
% end
% 
% 
end