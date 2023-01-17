% BB_thic.m - Breadboard for thickness estimation

RefRed = 0.12;
RefGreen = 0.11;
RefBlue = 0.13;
RefRed = [cw_r RefRed]; %Reflectance Point at Red
RefGreen = [cw_g RefGreen]; %Reflectance Point at Green
RefBlue = [cw_b RefBlue]; %Reflectance Point at Blue

figure(1)

hold on
plot(lambda,Gamma(:,valtoindex_L(0.072)),'c--','LineWidth',2)
plot(lambda,Gamma(:,valtoindex_L(0.077)),'m--','LineWidth',2)
plot(lambda,Gamma(:,valtoindex_L(0.0842)),'y--','LineWidth',2)
plot(RefRed(1),RefRed(2),'r.','MarkerSize',30)
plot(RefGreen(1),RefGreen(2),'g.','MarkerSize',30)
plot(RefBlue(1),RefBlue(2),'b.','MarkerSize',30)
xlim([0.4 0.68])
ylim([0 0.3])
legend('L = 72 nm', 'L = 77 nm', 'L = 82 nm','Ref at R','Ref at G','Ref at B')

for i = 1:1370
Diff_at_B(:,i) = abs(RefBlue - Gamma(valtoindex_lambda(cw_b),i));
Diff_at_G(:,i) = abs(RefGreen - Gamma(valtoindex_lambda(cw_g),i));
Diff_at_R(:,i) = abs(RefRed - Gamma(valtoindex_lambda(cw_r),i));
L_Diff(i,:) = [Diff_at_B(2,i) Diff_at_G(2,i) Diff_at_R(2,i)];
end
avg_L_Diff = mean(L_Diff,2);
Est_L = find(avg_L_Diff == min(avg_L_Diff));