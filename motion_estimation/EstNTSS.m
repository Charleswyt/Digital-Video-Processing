%% ������������
clc;
clear all;
close all;

mbSize = 16;
p = 7;

image_I = imread('19.jpg');
image_P = imread('18.jpg');

fig_1 = figure(1);
set(fig_1, 'name', 'Fig1:��ǰ֡��Ԥ��֡', 'Numbertitle', 'off');
subplot(121);imshow(image_I);title('��ǰ֡');
subplot(122);imshow(image_P);title('�ο�֡');

imgI = double(rgb2gray(image_I));
imgP = double(rgb2gray(image_P));
[height, width] = size(imgI);
imgI = imgI(1:height, 1:width);
imgP = imgP(1:height, 1:width);
mvx = zeros(height/mbSize, width/mbSize);
mvy = zeros(height/mbSize, width/mbSize);

motionVectDS = motionEstDS(imgP, imgI, mbSize, p);

%�����˶�����ͼ
a = zeros(1, width * height / mbSize^2);
a(:) = motionVectDS(1,1:width * height / mbSize^2);
b = zeros(1,width * height / mbSize^2);
b(:) = motionVectDS(2,1:width * height / mbSize^2);
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, j+(i-1) * (width / mbSize));% �˶�������x����
        mvy(i, j) = -(a(1, j+(i-1) * (width / mbSize)));% �˶�������y����
    end
end

fig_2 = figure(2);
set(fig_2, 'name', 'Fig2:���������������˶�����ͼ', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud�������·�ת����
title('�˶�����ͼ'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% ����Ԥ��֡
imgComp = motionComp(imgI, motionVectDS, mbSize);
I1 = uint8(imgComp(1: height - 8,1:width));
fig_3 = figure(3);
set(fig_3, 'name', 'Fig3:��������������Ԥ��֡', 'Numbertitle', 'off');
imshow(I1);title('Ԥ��֡');

% ���Ʋв�ͼ
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_4 = figure(4);
set(fig_4, 'name', 'Fig4:���������������в�֡', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('�в�֡');