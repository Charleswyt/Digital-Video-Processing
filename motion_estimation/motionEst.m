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

%%  ѡ�ò�ͬ���㷨�õ��˶�����ͼ��Ԥ��֡�Ͳв�֡
%% ȫ������

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
set(fig_2, 'name', 'Fig2:ȫ���������˶�����ͼ', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud�������·�ת����
title('�˶�����ͼ'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% ����Ԥ��֡
imgComp = motionComp(imgI, motionVectES, mbSize);
I1 = uint8(imgComp(1: height - 8,1: width));
fig_3 = figure(3);
set(fig_3, 'name', 'Fig3:ȫ��������Ԥ��֡', 'Numbertitle', 'off');
imshow(I1);title('Ԥ��֡');

% ���Ʋв�ͼ
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_4 = figure(4);
set(fig_4, 'name', 'Fig4:ȫ���������в�֡', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('�в�֡');

%% ����������

motionVectTSS = motionEstTSS(imgP, imgI, mbSize, p);

%�����˶�����ͼ
a = zeros(1, width * height / mbSize^2);
a(:) = motionVectTSS(1,1:width * height / mbSize^2);
b = zeros(1,width * height / mbSize^2);
b(:) = motionVectTSS(2,1:width * height / mbSize^2);
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, j+(i-1) * (width / mbSize));% �˶�������x����
        mvy(i, j) = -(a(1, j+(i-1) * (width / mbSize)));% �˶�������y����
    end
end

fig_5 = figure(5);
set(fig_5, 'name', 'Fig5:�������������˶�����ͼ', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud�������·�ת����
title('�˶�����ͼ'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% ����Ԥ��֡
imgComp = motionComp(imgI, motionVectTSS, mbSize);
I1 = uint8(imgComp(1: height - 8,1:width));
fig_6 = figure(6);
set(fig_6, 'name', 'Fig6:������������Ԥ��֡', 'Numbertitle', 'off');
imshow(I1);title('Ԥ��֡');

% ���Ʋв�ͼ
canc = zeros(height, width);
for i = 1 : height - mbSize / 2
    for j = 1 : width
        canc(i, j) = 255 - abs(imgP(i, j) - imgComp(i, j));
    end
end
fig_7 = figure(7);
set(fig_7, 'name', 'Fig7:�������������в�֡', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('�в�֡');

%% �Ĳ�������

motionVect4SS = motionEst4SS(imgP, imgI, mbSize, p);

%�����˶�����ͼ
a = zeros(1, width * height / mbSize^2);
a(:) = motionVect4SS(1,1:width * height / mbSize^2);
b = zeros(1,width * height / mbSize^2);
b(:) = motionVect4SS(2,1:width * height / mbSize^2);
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, j+(i-1) * (width / mbSize));% �˶�������x����
        mvy(i, j) = -(a(1, j+(i-1) * (width / mbSize)));% �˶�������y����
    end
end

fig_8 = figure(8);
set(fig_8, 'name', 'Fig8:�Ĳ����������˶�����ͼ', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud�������·�ת����
title('�˶�����ͼ'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% ����Ԥ��֡
imgComp = motionComp(imgI, motionVect4SS, mbSize);
I1 = uint8(imgComp(1: height - 8,1:width));
fig_9 = figure(9);
set(fig_9, 'name', 'Fig9:�Ĳ���������Ԥ��֡', 'Numbertitle', 'off');
imshow(I1);title('Ԥ��֡');

% ���Ʋв�ͼ
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_10 = figure(10);
set(fig_10, 'name', 'Fig10:�Ĳ����������в�֡', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('�в�֡');

%% ����������

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

fig_11 = figure(11);
set(fig_11, 'name', 'Fig11:�������������˶�����ͼ', 'Numbertitle', 'off');
quiver(flipud(mvx), flipud(mvy));% flipud�������·�ת����
title('�˶�����ͼ'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);

% ����Ԥ��֡
imgComp = motionComp(imgI, motionVectDS, mbSize);
I1 = uint8(imgComp(1: height - 8,1:width));
fig_12 = figure(12);
set(fig_12, 'name', 'Fig12:������������Ԥ��֡', 'Numbertitle', 'off');
imshow(I1);title('Ԥ��֡');

% ���Ʋв�ͼ
canc = zeros(height, width);
for i = 1:height - mbSize / 2
    for j = 1:width
        canc(i, j) = 255 - abs(imgP(i,j) - imgComp(i, j));
    end
end
fig_13 = figure(13);
set(fig_13, 'name', 'Fig13:�������������в�֡', 'Numbertitle', 'off');
imshow(uint8(canc(1:height - mbSize / 2, 1:width)));title('�в�֡');