%%
%  author : Andy
%  Date : 2014-02-05
%%
clc
clear

path ='C:\Users\atc327\Desktop\preprocessing\';
FolderList=dir(path);
SavePath_N = sprintf('%s_output\\',path);
SavePath_S = sprintf('%s_L6\\',path); 



for i = 5 %: length(FolderList)-2
    subfolder = FolderList(i).name;
    subpath = [path subfolder '\'];
    ImList=dir([subpath,'*.jpg']);

    
    f3 = double(imread([subpath ImList(1).name]));    % Wavelength Band 3	0.63-0.69
    f4 = double(imread([subpath ImList(2).name]));     %Wavelength Band 4	0.77-0.90
    f6_1 = double(imread([subpath ImList(3).name]));

   
    %% calculate NDVI
    NDVI = (f4-f3)./(f4+f3);

    %% calculate NDVI_c
    
    subpathc = [path subfolder '\LC+DOS\'];
    ImListc=dir([subpathc,'*.jpg']);

    f3c = double(imread([subpathc ImListc(1).name]));    % Wavelength Band 3	0.63-0.69
    f4c = double(imread([subpathc ImListc(2).name]));     %Wavelength Band 4	0.77-0.90
    f6_1c = double(imread([subpathc ImListc(3).name]));
    
    NDVI_c = (f4c-f3c)./(f4c+f3c);
     
     
     savename = sprintf('%s_NDVI.bmp',FolderList(i).name);
     figure, imagesc(NDVI)
     saveas(gcf,[SavePath_N savename],'bmp')
     close    
     
     savename_c = sprintf('%s_NDVI_cor.bmp',FolderList(i).name);
     figure, imagesc(NDVI_c)
     saveas(gcf,[SavePath_N savename_c],'bmp')
     close
     
%%  calculate temperature   
     
    NDVI_min = 0.2;
    NDVI_max = 0.5; 

    % normal one
    Pv = ((NDVI-NDVI_min)/(NDVI_max-NDVI_min)).^2;
    etm6 = 0.04*Pv+0.986;
    % after atmosphere correction
    Pv_c= ((NDVI_c-NDVI_min)/(NDVI_max-NDVI_min)).^2;
    etm6_c = 0.04*Pv_c+0.986;
    
     DN = f6_1;
     L_max = 15.3032;
     L_min = 1.2378;
     QCAL_max = 255;
     QCAL_min = 1;
     L_lambda = ((L_max-L_min)/(QCAL_max-QCAL_min))*(DN-QCAL_min)+L_min;
    
     DNc = f6_1c; 
     L_lambdac = ((L_max-L_min)/(QCAL_max-QCAL_min))*(DNc-QCAL_min)+L_min;
    
    
    
    K1 = 666.09;
    K2 = 1282.71;
    T = K2./log(K1./L_lambda+1);
    Tc = K2./log(K1./L_lambdac+1);

         
    lambda = 11.5*10^-6;
    lo = 1.438*10^-2;
    S_t = T./(1+lambda*T./lo.*log(double(etm6)));
    S_t_c = Tc./(1+lambda*Tc./lo.*log(double(etm6_c)));
   
     savename = sprintf('%s_L6.bmp',FolderList(i).name);
     figure,imagesc(S_t)
     saveas(gcf,[SavePath_S savename],'bmp')
     close     
     savename_c = sprintf('%s_L6c.bmp',FolderList(i).name);
     figure,imagesc(S_t_c)
     saveas(gcf,[SavePath_S savename_c],'bmp')
     close
     

end