%% multidiel_OCN.m - Reflectance Simulations

clc
clearvars
close all

%Define Variables

lambda = linspace(0.4,0.68,1370); %wavelength: 400nm to 680 nm
L = linspace(0.08,0.14,1370); %thickness: 80 nm to 140 nm

%Define Variables for Calculating Gamma Matrix

lambdarSiO = [0.0684043, 0.1162414, 9.896161];
lambdarSi = [0.301516485, 1.13475115, 1104];

BsiO = [0.6961663, 0.4079426, 0.8974794];
Bsi = [10.6684293, 0.0030434748, 1.54133408];

nsqrSi =sellmeier(Bsi,lambdarSi,lambda);
nsqrSiO =sellmeier(BsiO,lambdarSiO,lambda);

nrSi = (sqrt(nsqrSi)+conj(sqrt(nsqrSi)))/2;
nrSiO = (sqrt(nsqrSiO)+conj(sqrt(nsqrSiO)))/2;

Z1 = [];
Gamma1 = [];

%Calculate Gamma Matrix (Si / SiO2 Reflectance values for changing L and lambda)

for i = 1:numel(lambda);
for j = 1:numel(L); 
[Gamma1(i,j),Z1(i,j)] = multidiels([1; nrSiO(1,i); nrSi(1,i)],L(j).*nrSiO(1,i),lambda(1,i));
end
end
[MLam, MThicc] = meshgrid(lambda,L);
Gamma = conj(Gamma1).*Gamma1;

%Plot Gamma Matrix

figure(1)

surgraph = surf(MLam,MThicc,Gamma,'EdgeColor','none');
title('Si/SiO_2 Reflectance Values')
xlim([0.4 0.68])
ylim([0.08 0.14])
cb = colorbar;

cb.Location = 'southoutside';
xlabel('Lambda (\mum)');
ylabel('L (\mum)');
zlabel('Reflectance');
caxis([0 0.5]);































%Reflectance Proof

l449 = 241;
l521 = 593;

plot(L,Gamma(l449,:),'b','LineWidth',2)
hold on
plot(L,Gamma(l521,:),'g','LineWidth',2)
xlabel('thickness')
ylabel('reflectance (%)')
legend('449 nm', '521 nm')

%Compared to https://www.researchgate.net/figure/Surface-reflectivity-versus-silicon-dioxide-layer-thickness_fig3_230952570
%Gamma Matrix is proven

