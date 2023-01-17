% nPlotting.m - Refractive Index plotting for Si & SiO2

clearvars 

lambda = linspace(0.4,0.68,500);
lambdarSiO = [0.0684043, 0.1162414, 9.896161];
lambdarSi = [0.301516485, 1.13475115, 1104];

B_SiO2 = [0.6961663, 0.4079426, 0.8974794];
B_Si = [10.6684293, 0.0030434748, 1.54133408];

nsqr_Si =sellmeier(B_Si,lambdarSi,lambda);
nsqr_SiO2 = sellmeier(B_SiO2,lambdarSi,lambda);

nr_Si = (sqrt(nsqr_Si)+conj(sqrt(nsqr_Si)))/2;
nr_SiO2 = (sqrt(nsqr_SiO2)+conj(sqrt(nsqr_SiO2)))/2;

figure(1)
plot(lambda,nr_Si,'LineWidth',2)
title('Refractive index for Silicon')

figure(2)
plot(lambda,nr_SiO2,'LineWidth',2)
title('Refractive index for Silicon Oxide')