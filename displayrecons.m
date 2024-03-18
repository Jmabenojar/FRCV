clear all; close all;
resultroot='D:\Darkroom\Joshua\mainlatest\FRCV-results\';

imgarray=zeros([600,600,6]);

AS1='AS\PhFB_num=5_iter=10.bmp';
AS2='AS\PhFB_num=5_iter=50.bmp';
AS3='AS\PhFB_num=5_iter=170.bmp';
% TF1='TF\PhFB_num=5_iter=10.bmp';
% TF2='TF\PhFB_num=5_iter=50.bmp';
% TF3='TF\PhFB_num=5_iter=170.bmp';
IR1='IR\PhFB_num=5_iter=10.bmp';
IR2='IR\PhFB_num=5_iter=50.bmp';
IR3='IR\PhFB_num=5_iter=170.bmp';
imgarray(:,:,1)=double(imread([resultroot AS1]));
imgarray(:,:,2)=double(imread([resultroot AS2]));
imgarray(:,:,3)=double(imread([resultroot AS3]));
% imgarray(:,:,4)=double(imread([resultroot TF1]));
% imgarray(:,:,5)=double(imread([resultroot TF2]));
% imgarray(:,:,6)=double(imread([resultroot TF3]));
imgarray(:,:,4)=double(imread([resultroot IR1]));
imgarray(:,:,5)=double(imread([resultroot IR2]));
imgarray(:,:,6)=double(imread([resultroot IR3]));
figure(1)
for i=1:6
    subplot(2,3,i), imagesc(imgarray(:,:,i)), axis image; axis off; colormap(gray(255));
end