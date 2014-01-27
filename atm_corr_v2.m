%%
%  author : Andy
%  Date : 2014-01-24
%%
clc
clear
method =1;
path ='C:\Users\atc327\Desktop\LST data set\L45 TM\';
FolderList=dir(path);
SavePath_N = sprintf('%soutput\\',path);
SavePath_S = sprintf('%sL6\\',path); 

% if ~exist(SavePath_N)   % create a folder if it is not exist
%     mkdir(SavePath_N)
% end
% if ~exist(SavePath_S)   % create a folder if it is not exist
%     mkdir(SavePath_S)
% end

for i = 3 %: length(FolderList)
    subfolder = FolderList(i).name;
    subpath = [path subfolder '\'];
    ImList=dir([subpath,'*.TIF']);
    
    MTL_file=dir([subpath,'*MTL.txt']);
    
    
    f3 = double(imread([subpath ImList(3).name]));    % Wavelength Band 3	0.63-0.69
    f4 = double(imread([subpath ImList(4).name]));     %Wavelength Band 4	0.77-0.90
    f6_1 = double(imread([subpath ImList(6).name]));
    f3 = double(f3(1475:2230,1845:2815,1));
    f4 = double(f4(1475:2230,1845:2815,1));
    f6_1 =double(f6_1(1475:2230,1845:2815,1));
   
    %% calculate NDVI
    NDVI = (f4-f3)./(f4+f3);
    if method ==1                                               % method Chavez('96)
        fid = fopen([subpath MTL_file.name]) ;
        index = fgetl(fid);
        while isempty(findstr(index,'SUN_ELEVATION'))
                index = fgets(fid);
        end
        cos_theta = cosd(90-str2num( index(20:end)));   %========================change============================%    
        day =   str2num(subfolder(14:16));                           %========================change============================%
        Eo3 =278.720;                                                                  %======================look table==========================%
        Eo4 = 165.460;                                                                 %======================look table==========================%

        [m3,n3,~] = size(f3);
        [m4,n4,~] = size(f4);

        a = 149.6*10^6;                                          % semi-major axis of the orbit
        ecc = 0.017;                                                  %eccentricity
        theta = day*360/365.25;
        d =a*(1-ecc^2)/(1+ecc*cosd(theta));

        Tz3 = 0.85;
        Tz4 = 0.91;

        L1_3 = 0.01*cos_theta*Tz3*Eo3/pi/d^2;
        L1_4 = 0.01*cos_theta*Tz4*Eo4/pi/d^2;
        Lm3 = sum(sum(f3<=0.0001));
        Lm4 = sum(sum(f4<=0.0001));
        Lp3 = Lm3-L1_3;
        Lp4 = Lm4-L1_4;
        % L_lambda (B6_1)
        DN = f6_1;
        L_max = 17.04;
        L_min = 0;
        QCAL_max = 255;
        QCAL_min = 0;
        L_lambda = ((L_max-L_min)/(QCAL_max-QCAL_min))*(DN-QCAL_min)+L_min;

         rho_sup3 = pi*(f3-Lp3)*d^2/(Eo3*cos_theta*Tz3);
         rho_sup4 = pi*(f4-Lp4)*d^2/(Eo4*cos_theta*Tz4);
         NDVI_c = (rho_sup4-rho_sup3)./(rho_sup4+rho_sup3);
         
        elseif method ==2                                 % method SMAC, Rhhman('94)

            f3_s = 1.0705*f3-0.0121;
            f4_s = 1.0805*f4-0.0047;
            NDVI_c = (f4_s-f3_s)./(f4_s+f3_s);
    end
     

     
     
     savename = sprintf('%s_NDVI.png',FolderList(i).name);
     figure, imagesc(NDVI)
%      saveas(gcf,[SavePath_N savename],'png')
%      close    
     
     savename_c = sprintf('%s_NDVI_cor_m%.2d.png',FolderList(i).name,method);
     figure, imagesc(NDVI_c)
%      saveas(gcf,[SavePath_N savename_c],'png')
%      close
     
% %%  calculate temperature   
%      
%     NDVI_min = 0.2;
%     NDVI_max = 0.5; 
% 
%     % normal one
%     Pv = ((NDVI-NDVI_min)/(NDVI_max-NDVI_min)).^2;
%     etm6 = 0.04*Pv+0.986;
%     % after atmosphere correction
%     Pv_c= ((NDVI_c-NDVI_min)/(NDVI_max-NDVI_min)).^2;
%     etm6_c = 0.04*Pv_c+0.986;
%     
%     K1 = 666.09;
%     K2 = 1282.71;
%     T = K2./log(K1./L_lambda+1);
% 
%     lambda = 11.5*10^-6;
%     lo = 1.438*10^-2;
%     S_t = T./(1+lambda*T./lo.*log(double(etm6)));
%     S_t_c = T./(1+lambda*T./lo.*log(double(etm6_c)));
   
%      savename = sprintf('%s_L6.png',FolderList(i).name);
%      figure,imagesc(S_t)
%      saveas(gcf,[SavePath_S savename],'png')
%      close     
%      savename_c = sprintf('%s_L6C_m%.2d.png',FolderList(i).name,method);
%      figure,imagesc(S_t_c)
%      saveas(gcf,[SavePath_S savename_c],'png')
%      close
%      

end