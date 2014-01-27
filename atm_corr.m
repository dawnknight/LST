clc
clear
path ='C:\Users\atc327\Desktop\LST data set\L45 TM\';
FolderList=dir(path);

rlist=dir([path,'*.txt']);
for i = 3 %: length(folderlist)-1
    subfolder = FolderList(i).name;
    subpath = [path subfolder '\'];
    ImList=dir([subpath,'*.TIF']);
    
    TxtList=dir([subpath,'*.txt']);
    
    
    f3 = double(imread([subpath ImList(3).name]));    % Wavelength Band 3	0.63-0.69
    f4 = double(imread([subpath ImList(4).name]));     %Wavelength Band 4	0.77-0.90
    f6_1 = double(imread([subpath ImList(6).name]));
    f3 = double(f3(1475:2230,1845:2815,1));
    f4 = double(f4(1475:2230,1845:2815,1));
    f6_1 =double(f6_1(1475:2230,1845:2815,1));
    rfid = fopen([path rlist.name]);
    
    fid = fopen([subpath TxtList(2).name]) ;
    index = fgetl(fid);
    while isempty(findstr(index,'SUN_ELEVATION'))
            index = fgets(fid);
    end
    cos_theta = cosd(90-str2num( index(20:end)));   %========================change============================%    
    day =   str2num(subfolder(14:16));                           %========================change============================%
    
    
    fid = fopen([subpath TxtList(2).name]) ;
    index = fgetl(fid);
%     while isempty(findstr(index,' RADIANCE_MULT_BAND_3 '))
%             index = fgets(fid);
%     end 
%     num3 =  0.66;
%     idx = (num3-0.25)/0.01+5;
%     line3 = readline( [path rlist.name] ,idx);
    Eo3 =278.720;                                                                                       %========================change============================%
    fid = fopen([subpath TxtList(2).name]) ;
    index = fgetl(fid);
%     while isempty(findstr(index,' RADIANCE_MULT_BAND_4 '))
%             index = fgets(fid);
%     end 
%     num4 =    0.83; 
%     idx = (num4-0.25)/0.01+5;
%     line4 = readline( [path rlist.name] ,idx);
    Eo4 = 165.460;   
  
    [m3,n3,~] = size(f3);
    [m4,n4,~] = size(f4);
    a = 149.6*10^6;  % semi-major axis of the orbit
    ecc = 0.017;          %eccentricity
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
% 
%     DN3 = f3;
%     DN4 = f4;
%     L_max3 = 234.4;
%     L_min3 = -5.0;
%     L_max4 = 241.1;
%     L_min4 = -5.1;
%     QCAL_max = 255;
%     QCAL_min = 0;
% 
%     L_lambda3 = ((L_max3-L_min3)/(QCAL_max-QCAL_min))*(DN3-QCAL_min)+L_min3;
%     L_lambda4 = ((L_max4-L_min4)/(QCAL_max-QCAL_min))*(DN4-QCAL_min)+L_min4;
%     rho_sup3 = pi*(L_lambda3-Lp3)*d^2/(Eo3*cos_theta*Tz3);
%     rho_sup4 = pi*(L_lambda4-Lp4)*d^2/(Eo4*cos_theta*Tz4);
    DN = f6_1;
    L_max = 17.04;
    L_min = 0;
    QCAL_max = 255;
    QCAL_min = 0;
    L_lambda = ((L_max-L_min)/(QCAL_max-QCAL_min))*(DN-QCAL_min)+L_min;

     rho_sup3 = pi*(L_lambda-Lp3)*d^2/(Eo3*cos_theta*Tz3);
     rho_sup4 = pi*(L_lambda-Lp4)*d^2/(Eo4*cos_theta*Tz4);
     NDVI_c = (rho_sup4-rho_sup3)./(rho_sup4+rho_sup3);
     NDVI = (f4-f3)./(f4+f3);
     savepath = 'C:/Users/atc327/Desktop/LST data set/output img/';
     savename_c = sprintf('%s_NDVI_cor_method2.png',FolderList(i).name);
     figure,
     imagesc(NDVI_c)
%      saveas(gcf,[savepath savename_c],'png')
%      close
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      
%     NDVI_min = 0.2;
%     NDVI_max = 0.5; 
% 
% 
%     Pv = ((NDVI-NDVI_min)/(NDVI_max-NDVI_min)).^2;
%     etm6 = 0.04*Pv+0.986;
% 
%     Pv_c= ((NDVI_c-NDVI_min)/(NDVI_max-NDVI_min)).^2;
%     etm6_c = 0.04*Pv_c+0.986;
%     
%     %% L_lambda (B6)
%     DN = f6_1;
%     L_max = 17.04;
%     L_min = 0;
%     QCAL_max = 255;
%     QCAL_min = 0;
% 
%     L_lambda = ((L_max-L_min)/(QCAL_max-QCAL_min))*(DN-QCAL_min)+L_min;
% 
% 
%     %% step 3
% 
%     K1 = 666.09;
%     K2 = 1282.71;
%     T = K2./log(K1./L_lambda+1);
% 
%     %% step 4
%     lambda = 11.5*10^-6;
%     lo = 1.438*10^-2;
%     S_t = T./(1+lambda*T./lo.*log(double(etm6)));
%     S_t_c = T./(1+lambda*T./lo.*log(double(etm6_c)));
%      
%      savepath = 'C:/Users/atc327/Desktop/LST data set/output img/L6/';
%      savename = sprintf('%s_L6.png',FolderList(i).name);
%      savename_c = sprintf('%s_L6C_m2.png',FolderList(i).name);
%      imagesc(S_t)
%      saveas(gcf,[savepath savename],'png')
%      close     
%      imagesc(S_t_c)
%      saveas(gcf,[savepath savename_c],'png')
%      close
     

end