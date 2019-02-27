clc; clear all;
% a=fopen('D:\Í¼Ïñ\MATLAB\finalwork\PET\20130908_m1_try1_PET 5mins new_em_v1.pet.img') ;
%a=fopen('D:\Image\20130908_m1_try1_PET 5mins new_em_v1.pet.img');
%b=fread(a,'float32') ;
% b=fread(a,'float32');

f=fopen('D:\Í¼Ïñ\MATLAB\finalwork\PET\data2');
data=fread(f,'float');
image=reshape(data,[128,128,47]);
%image=reshape(b,[128,128,159]);
% % %image1=mat2gray(image,[0 1]);
x1=[63];
y1=[72];
z1=[18];
figure,vol3d_w(image);
image1=regiongrow_1(image,1120,x1,y1,z1);
figure,
h=vol3d_w(image1);
% % figure,imshow(image1(:,:,18),[])
% [mu,mask]=kmeans(image(:,:,50),3);
% figure,imshow(image(:,:,50),[]);
% figure,imshow(mu);