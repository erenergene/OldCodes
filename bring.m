%% bring.m - Get a list of all txt files in the current folder or subfolders of it as a tall array.

% function structmat = bring(direc)
%%
fds = fileDatastore(dirR,'ReadFcn', @(x)load(x),"FileExtensions",".mat")
tR = tall(fds)
%%
get = gather(tR)
%%
tic
for i = 1:4999
    newget(i) = gather(get(i))';
end
toc
% one = tR(1,1);
%%
getone = gather(tR(1,1));
%%

%%
strucone = table2struct(getone{1,1})
%%
onestrucone = strucone(1,1);
%%

for i = 1:4999

    mn = mean(mean(tR(i,1)));
end


%%
getone = gather(one);

%end























% for i = 1:4999
fprintf(1, 'Now reading file %.0f \n', i);
%% 

BIR = tR(1,1);
%%
GATBIR = gather(BIR)
%%
IKI = tR(2,1);
%%
GATIKI = gather(IKI)
% end
%%
gat1(i,:) = gather(pregat1);

%%
pregat2 = tR(2,1)
%%
gat2 = gather(pregat2)

%%


mattall = cell2mat(tR);
%%
meantall = mean(mattall)
%%
meantall = gather(meantall)



% mn = gather(mn);
%%


%%
for i = 1:5000

BIR = gather(tR(i));
gatbir(:,:,i) = BIR{i,1};

end
%%



%%

%%

hh = head(tR,10);


%%

pregat = tR(1,1)
%%
gatmat = pregat{1,1};

%%
gat = gather(pregat)
%%


%%
pre = preview(fds)
%%

%%
% fullFileNames = fds.Files

numFiles = length(fullFileNames)

% Loop over all files reading them in and plotting them.

for k = 1 : numFiles

    fprintf('Now reading file %.0f\n', k);

    % Now have code to read in the data using whatever function you want.

    % Now put code to plot the data or process it however you want...

end

% end