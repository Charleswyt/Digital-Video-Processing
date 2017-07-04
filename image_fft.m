clc;
clear all;
close all;

image_name_1 = 'lena_gray.bmp';
image_name_2 = 'Barbara.bmp';

%% �Ҷ�ͼ1_����Ҷ�任��������ס���λ��
image_1 = imread(image_name_1);% ��ȡͼ��
image_1_double = double(image_1);% ��ͼ��ת��Ϊdouble����
image_spectrum_1 = fft2(image_1_double);% ��ͼ��������Ҷ�任����ȡƵ��
image_spectrum_1 = fftshift(image_spectrum_1);% ��fft��DC�����Ƶ�Ƶ������
image_magnitude_1 = abs(image_spectrum_1);% ������
image_phase_1 = angle(image_spectrum_1);% ��λ��

%% �Ҷ�ͼ2_����Ҷ�任��������ס���λ��
image_2 = imread(image_name_2);% ��ȡͼ��
image_2_double = double(image_2);% ��ͼ��ת��Ϊdouble����
image_spectrum_2 = fft2(image_2_double);% ��ͼ��������Ҷ�任����ȡƵ��
image_spectrum_2 = fftshift(image_spectrum_2);% ��fft��DC�����Ƶ�Ƶ������
image_magnitude_2 = abs(image_spectrum_2);% ������
image_phase_2 = angle(image_spectrum_2);% ��λ��

fig_1 = figure(1);
set(fig_1, 'name', 'Fig1:�Ҷ�ͼ1', 'Numbertitle', 'off');
subplot(211);imshow(image_1);title('ͼ��1');
subplot(223);imshow(log(1 + image_magnitude_1), []);title('����������');
subplot(224);imshow(image_phase_1, []);title('��λ��');

fig_2 = figure(2);
set(fig_2, 'name', 'Fig2:�Ҷ�ͼ2', 'Numbertitle', 'off');
subplot(211);imshow(image_2);title('ͼ��2');
subplot(223);imshow(log(1 + image_magnitude_2), []);title('����������');
subplot(224);imshow(image_phase_2, []);title('��λ��');

%% ��ʽ����Ҷ�任��������λ�׺ͷ����״���ԭƵ��
% ����λ�״���ԭƵ��
image_new_spectrum_1 = 128 * exp(1j * image_phase_1);
image_new_spectrum_1 = ifftshift(image_new_spectrum_1);
image_new_1 = ifft2(image_new_spectrum_1);
image_new_1 = uint8(image_new_1);

% �÷����״���ԭƵ��
image_new_spectrum_2 = image_magnitude_1;
image_new_spectrum_2 = ifftshift(image_new_spectrum_2);
image_new_2 = ifft2(image_new_spectrum_2);
image_new_2 = uint8(image_new_2);

%% ��ʽ����Ҷ�任������������ͼ�����λ�׺ͷ�����
% ͼ1�ķ�������ͼ2����λ������
image_new_spectrum_3 = image_magnitude_1 .* exp(1j * image_phase_2);
image_new_spectrum_3 = ifftshift(image_new_spectrum_3);
image_new_3 = ifft2(image_new_spectrum_3);
image_new_3 = uint8(image_new_3);

% ͼ2�ķ�������ͼ1����λ������
image_new_spectrum_4 = image_magnitude_2 .* exp(1j * image_phase_1);
image_new_spectrum_4 = ifftshift(image_new_spectrum_4);
image_new_4 = ifft2(image_new_spectrum_4);
image_new_4 = uint8(image_new_4);

fig_3 = figure(3);
set(fig_3, 'name', 'Fig3:��ʽ����Ҷ�任', 'Numbertitle', 'off');
subplot(221);imshow(image_new_1, []);title('ͼ��1�����Ⱥ�Ϊ256 + ͼ1��λ�ף�');
subplot(222);imshow(image_new_2, []);title('ͼ��2��ͼ1������ + ��λ�׺�Ϊ0��');
subplot(223);imshow(image_new_3, []);title('ͼ��3��ͼ1������ + ͼ2��λ�ף�');
subplot(224);imshow(image_new_4, []);title('ͼ��4��ͼ2������ + ͼ1��λ�ף�');