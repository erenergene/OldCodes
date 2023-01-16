%% newrefcalc.m - Manual simulations of reflectance (no multidiel)

clearvars
load("OsramSim.mat")
%%
for i = 1:numval
    for j = 1:numval
        Simulated_Ref(i,j) = newrefcalc(Osram_lambda(i),L(j));
    end
end
%%
nrSi = nrSi';
nrSiO = nrSiO';
%%
L = L'
%%
r_12 = (nair-nrSiO)./(nair+nrSiO);
%%
r_23 = (nrSiO-nrSi)./(nrSiO+nrSi);
%%
phi = (((2*pi.*L)./Osram_lambda) .* (nrSiO));
%%
Ref = ( (r_12).^2 + (r_23).^2 + 2.*r_12.*r_23.*cos(2.*phi) ) / (1 + ((r_12).^2).*((r_23).^2) + 2.*r_12.*r_23.*cos(2.*phi));