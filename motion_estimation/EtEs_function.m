function EtEs_function(image_I, image_P)

mbSize = 16;
p = 7;

figure;
subplot(121);imshow(image_I);title('��ǰ֡');
subplot(122);imshow(image_P);title('�ο�֡');

imgI = double(rgb2gray(image_I));
imgP = double(rgb2gray(image_P));
[height, width] = size(imgI);
imgI = imgI(1:height, 1:width);
imgP = imgP(1:height, 1:width);
mvx = zeros(floor(height/mbSize), floor(width/mbSize));
mvy = zeros(floor(height/mbSize), floor(width/mbSize));

%% ȫ������

motionVectES = motionEstES(imgP, imgI, mbSize, p);

%�����˶�����ͼ
a = zeros(1, floor(width * height / mbSize^2));
a(:) = motionVectES(1,floor(1:width * height / mbSize^2));
b = zeros(1, floor(width * height / mbSize^2));
b(:) = motionVectES(2,1:floor(width * height / mbSize^2));
for i = 1 : height / mbSize
    for j = 1 : width / mbSize
        mvx(i, j) = b(1, floor(j+(i-1) * (width / mbSize)));% �˶�������x����
        mvy(i, j) = -(a(1, floor(j+(i-1) * (width / mbSize))));% �˶�������y����
    end
end

figure;
quiver(flipud(mvx), flipud(mvy));% flipud�������·�ת����
title('�˶�����ͼ'); 
set(gca, 'XLim', [-1, width / mbSize + 2], 'YLim', [-1, height / mbSize + 2]);