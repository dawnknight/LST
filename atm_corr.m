clc
clear
path ='C:\Users\atc327\Desktop\LST data set\extract\';
filelist=dir(path);

rlist=dir([path,'*.txt']);
for i = 3: length(filelist)-1
    subfolder = filelist(i).name;
    subpath = [path subfolder '\'];
    imlist=dir([subpath,'*.TIF']);
    
    txtlist=dir([subpath,'*.txt']);
    
    
    f3 = double(imread([subpath imlist(3).name]));    % Wavelength Band 3	0.63-0.69
    f4 = double(imread([subpath imlist(4).name]));     %Wavelength Band 4	0.77-0.90
    f6_1 = double(imread([subpath imlist(6).name]));
    
    rfid = fopen([path rlist.name]);
    
    fid = fopen([subpath txtlist(2).name]) ;
    index = fgetl(fid);
    while isempty(findstr(index,'SUN_ELEVATION'))
            index = fgets(fid);
    end
    cos_theta = cosd(90-str2num( index(20:end)));   %========================change============================%    
    day =   str2num(subfolder(14:16));                           %========================change============================%
    
    
    fid = fopen([subpath txtlist(2).name]) ;
    index = fgetl(fid);
    while isempty(findstr(index,' RADIANCE_MULT_BAND_3 '))
            index = fgets(fid);
    end 
    num3 =  str2num(index(27:end-2));
    idx = (num3-0.25)/0.01+5;
    line3 = readline( [path rlist.name] ,idx);
    Eo3 = line3(5);                                                                                       %========================change============================%
    fid = fopen([subpath txtlist(2).name]) ;
    index = fgetl(fid);
    while isempty(findstr(index,' RADIANCE_MULT_BAND_4 '))
            index = fgets(fid);
    end 
    num4 =    str2num(index(27:end-2)); 
    idx = (num4-0.25)/0.01+5;
    line4 = readline( [path rlist.name] ,idx);
    Eo4 = line4(5);   
  
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


    rho_sup3 = pi*(f3-Lp3)*d^2/(Eo3*cos_theta*Tz3);
    rho_sup4 = pi*(f4-Lp4)*d^2/(Eo4*cos_theta*Tz4);

     NDVI_s = (rho_sup4-rho_sup3)./(rho_sup4+rho_sup3);
    
     savepath = 'C:/Users/atc327/Desktop/LST data set/output img/';
     savename_s = sprintf('%s_NDVI_cor_method2.png',filelist(i).name);
     imagesc(NDVI_s)
     saveas(gcf,[savepath savename_s],'png')
     close
    

end