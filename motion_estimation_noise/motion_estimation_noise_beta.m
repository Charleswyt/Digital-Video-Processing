clc;
close all;

mbSize = 16;
p = 7;

%% ԭʼ֡
image_I = imread('15.jpg');
image_P = imread('14.jpg');

imgI = double(rgb2gray(image_I));
imgP = double(rgb2gray(image_P));
[height, width] = size(imgI);
imgI = imgI(1:height, 1:width);
imgP = imgP(1:height, 1:width);
mvx = zeros(height/mbSize, width/mbSize);
mvy = zeros(height/mbSize, width/mbSize);

motionVectES = motionEstES(imgP, imgI, mbSize, p);

%�����˶�����ͼ
a = zeros(1, width * height / mbSize^2);
a(:) = motionVectES(1,1:width * height / mbSize^2);
b = zeros(1, width * height / mbSize^2);
b(:) = motionVectES(2,1:width * height / mbSize^2);
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, j+(i-1) * (width / mbSize));% �˶�������x����
        mvy(i, j) = -(a(1, j+(i-1) * (width / mbSize)));% �˶�������y����
    end
end

fig_1 = figure(1);
set(fig_1, 'name', 'Fig1:δ�����˶�����ͼ', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud�������·�ת����
title('�˶�����ͼ');
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

%% ����֡
image_I_noise = imread('15_noise.jpg');
image_P_noise = imread('14_noise.jpg');

imgI = double(rgb2gray(image_I_noise));
imgP = double(rgb2gray(image_P_noise));
[height, width] = size(imgI);
imgI = imgI(1:height, 1:width);
imgP = imgP(1:height, 1:width);
mvx = zeros(height/mbSize, width/mbSize);
mvy = zeros(height/mbSize, width/mbSize);

motionVectES = motionEstES(imgP, imgI, mbSize, p);

%�����˶�����ͼ
a = zeros(1, width * height / mbSize^2);
a(:) = motionVectES(1,1:width * height / mbSize^2);
b = zeros(1, width * height / mbSize^2);
b(:) = motionVectES(2,1:width * height / mbSize^2);
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, j+(i-1) * (width / mbSize));% �˶�������x����
        mvy(i, j) = -(a(1, j+(i-1) * (width / mbSize)));% �˶�������y����
    end
end

fig_2 = figure(2);
set(fig_2, 'name', 'Fig2:�����˶�����ͼ', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud�������·�ת����
title('�˶�����ͼ'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);