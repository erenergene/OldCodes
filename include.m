%% include.m - include folders in the path

% Apache V2 License - Copyright (c) 2020 Amin Yahyaabadi - aminyahyaabadi74@gmail.com
% https://github.com/aminya/Dispatch.m

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function include(method, varargin)
    % include function
    %
    % # Arguments:
    % `include(method::String, [folders::Array{String}/Cell{Char}])`
    %
    %  - method: can be `"all","all_exclude","specific","GUI_all","GUI_specific"`
    %  - folders (optional):
    %   - if method is `"all_exclude"`: pass the folder names that should be excluded
    %   - if method is `"specific"`: pass the folder names that should be included
    %
    %  Folders specified in the 2nd argument can have a relative as well as absolute path.
    %
    % # Example run_include
    % Choose the method, and run the function.
    % ```matlab
    % include("all");
    % ```
    %
    % Pass a 2nd output to include/exclude specific folders if you chose "all_exclude" or "specificFolders"
    % ```matlab
    % include("specific", ["src", "examples"]); % or include("specific", {'src', 'examples'});
    % ```


    switch method

        %% To include all
        case "all"

            addpath(pwd);   % add root folder

            % add subfolders
            folders=dirFolder(pwd);
            for i=1:length(folders)
                addpath(genpath(folders{i}))
            end

            disp("Folders of current working and their subfolders are added to the path");

        %% To include all excluding some folders
        case "all_exclude"

            % folders to be excluded
            excludedFolders = varargin{1};

            addpath(pwd);   % add root folder

            folders=dirFolder(pwd); % all folders

            % folders to be included
            includedFolders=folders(~ismember(folders,excludedFolders));

            for  i=1:length(includedFolders)
                addpath(genpath(includedFolders{i}))
            end

            disp("Folders of current working and their subfolders excluding those specified are added to the path");

        %% To include specific folders
        case "specific"

            includedFolders = varargin{1};

            addpath(pwd); % add root folder

            for i=1:length(includedFolders)
                addpath(genpath(includedFolders{i}))
            end

            disp("Sepecified folders and their subfolders are added to the path");

        %% To include all under a folder with GUI
        case "GUI_all"
            rootDir = uigetdir(pwd, 'Select a folder');

            addpath(rootDir); % add root folder

            % add subfolders
            folders=dirFolder(rootDir);
            for i=1:length(folders)
                addpath(genpath(folders{i}))
            end

            disp("selected folders and their subfolders are added to the path");

        %% To include specific folders with GUI
        case "GUI_specific"
        % press cancel if you are finished with adding

            rootDir=1;

            while 1 % continue until user press cancel
                rootDir = uigetdir(pwd, 'Select a folder');
                if rootDir==0
                    break;
                else
                    addpath(genpath(rootDir));
                end
            end

            disp("Selected folders and their subfolders are added to the path");

    end

end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [folders] = dirFolder(parentDir)
    % get folder names in a directory

    % modified from https://www.mathworks.com/matlabcentral/answers/166629-is-there-any-way-to-list-all-folders-only-in-the-level-directly-below-a-selected-directory#comment_624696

    all    = dir(parentDir); %list of all files and folders
    names    = {all.name};
    % seperating folders indeces
    idxFolder = [all.isdir] & ~strcmp(names, '.') & ~strcmp(names, '..');

    % Extract only those that are directories.
    folders = names(idxFolder);
end