% newrefcalc.m - Manual calculations of reflectance (no multidiel)

%% clearvars
function Ref = newrefcalc(iptlambda,iptL)
%%
tic
load("OsramSim.mat","numval","Osram_lambda","nrSiO","nrSi")
toc

%% clearvars -except Osram_lambda nrSiO nrSi 
%%
iptlambda = 0.45
iptL = 0.12
lamindex = valtoindex(iptlambda,numval,Osram_lambda(1),Osram_lambda(end));
fprintf("Running lambda %.4f L %.4f",iptlambda,iptL)

%%

%%

nrSi = nrSi';
%%
nrSiO = nrSiO';


%%
r_12 = (1-nrSiO(lamindex))/(1+nrSiO(lamindex));
%%
r_23 = (nrSiO(lamindex)-nrSi(lamindex))/(nrSiO(lamindex)+nrSi(lamindex));
%%
phi = ((2*pi*iptL)/iptlambda) * nrSiO(lamindex);
%%
Ref = ( (r_12)^2 + (r_23)^2 + 2*r_12*r_23*cos(2*phi) ) / (1 + ((r_12)^2)*((r_23)^2) + 2*r_12*r_23*cos(2*phi));
%%
% n_air = sqrt(1+14926.44e-8./(1-19.36e-6./x.^2)+41807.57e-8./(1-7.434e-3./x.^2)) %%BORZSONYI 
% n_SiO2 = sqrt(1+0.6961663./(1-(0.0684043./x).^2)+0.4079426./(1-(0.1162414./x).^2)+0.8974794./(1-(9.896161./x).^2))
%%
end


%%



