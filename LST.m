% LST test

clc
clear
path = 'C:/Users/atc327/Desktop/LST data set/extract/';
folder_list = dir(path);
for i = 3:length(folder_list)
impath = sprintf('%s%s/',path,folder_list(i).name);   
imlist = dir([impath '*.TIF']);


f3 = imread([impath  imlist(3).name]);
f4 = imread([impath  imlist(4).name]);
f6_1 = imread([impath  imlist(6).name]);

f3 = double(f3(1475:2230,1845:2815,1));
f4 = double(f4(1475:2230,1845:2815,1));
f6_1 =double(f6_1(1475:2230,1845:2815,1));
%% step 1
NDVI = (f4-f3)./(f4+f3);
f3_s = 1.0705*f3-0.0121;
f4_s = 1.0805*f4-0.0047;
NDVI_s = (f4_s-f3_s)./(f4_s+f3_s);

savepath = 'C:/Users/atc327/Desktop/LST data set/output img/';
savename = sprintf('%s_NDVI.png',folder_list(i).name);
savename_s = sprintf('%s_NDVI_cor.png',folder_list(i).name);
imagesc(NDVI)
saveas(gcf,[savepath savename],'png')
close
imagesc(NDVI_s)
saveas(gcf,[savepath savename_s],'png')
close
end

% NDVI_min = 0.2;
% NDVI_max = 0.5; 
% figure,imagesc(NDVI)
% figure,imagesc(NDVI_s)
% 
% 
% 
% Pv = ((NDVI-NDVI_min)/(NDVI_max-NDVI_min)).^2;
% etm6 = 0.04*Pv+0.986;
% 
% %% step 2
% DN = f6_1;
% L_max = 17.04;
% L_min = 0;
% QCAL_max = 255;
% QCAL_min = 0;
% 
% L_lambda = ((L_max-L_min)/(QCAL_max-QCAL_min))*(DN-QCAL_min)+L_min;
% 
% 
% %% step 3
% 
% K1 = 666.09;
% K2 = 1282.71;
% T = K2./log(K1./L_lambda+1);
% 
% %% step 4
% lambda = 11.5*10^-6;
% lo = 1.438*10^-2;
% S_t = T./(1+lambda*T./lo.*log(double(etm6)));
% 
% 
% 
% figure,imagesc(S_t)


