clc
clear
close all
fix = imread('03.jpg');
mov = imread('05.jpg');
[opt,mtx] = imregconfig('Multimodal');
reg_img = imregister(mov(:,:,1),fix(:,:,1),'similarity',opt,mtx);

figure,imshowpair(fix(:,:,1),mov(:,:,1))




figure,imshowpair(fix(:,:,1),reg_img)

figure,imshow(reg_img)
