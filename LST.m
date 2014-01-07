% LST test

clc
clear

% f1 = imread('C:\Users\atc327\Desktop\LE70130322013249EDC00\LE70130322013249EDC00_B1.TIF');
% f2 = imread('C:\Users\atc327\Desktop\LE70130322013249EDC00\LE70130322013249EDC00_B2.TIF');
f3 = imread('C:\Users\atc327\Desktop\LE70130322013249EDC00\LE70130322013249EDC00_B3.TIF');
f4 = imread('C:\Users\atc327\Desktop\LE70130322013249EDC00\LE70130322013249EDC00_B4.TIF');
% f5 = imread('C:\Users\atc327\Desktop\LE70130322013249EDC00\LE70130322013249EDC00_B5.TIF');
f6_1 = imread('C:\Users\atc327\Desktop\LE70130322013249EDC00\LE70130322013249EDC00_B6_VCID_1.TIF');
% f6_2 = imread('C:\Users\atc327\Desktop\LE70130322013249EDC00\LE70130322013249EDC00_B6_VCID_2.TIF');
% f7 = imread('C:\Users\atc327\Desktop\LE70130322013249EDC00\LE70130322013249EDC00_B7.TIF');
f3 = double(f3(1475:2230,1845:2815,1));
f4 = double(f4(1475:2230,1845:2815,1));
f6_1 =double(f6_1(1475:2230,1845:2815,1));
%% step 1
NDVI = (f4-f3)./(f4+f3);
NDVI_min = 0.2;
NDVI_max = 0.5; 

Pv = ((NDVI-NDVI_min)/(NDVI_max-NDVI_min)).^2;
etm6 = 0.04*Pv+0.986;

%% step 2
DN = f6_1;
L_max = 17.04;
L_min = 0;
QCAL_max = 255;
QCAL_min = 0;

L_lambda = ((L_max-L_min)/(QCAL_max-QCAL_min))*(DN-QCAL_min)+L_min;


%% step 3

K1 = 666.09;
K2 = 1282.71;
T = K2./log(K1./L_lambda+1);

%% step 4
lambda = 11.5*10^-6;
lo = 1.438*10^-2;
S_t = T./(1+lambda*T./lo.*log(double(etm6)));

%re-scale
uni_value = unique(S_t);
pic = (S_t - uni_value(2))/(max(S_t(:))-uni_value(2))*255;
pic(pic<0) = 0;

% pic = k2RGB(S_t);

figure,imshow(uint8(pic))


