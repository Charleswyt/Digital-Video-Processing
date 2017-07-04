clc;
clear all;
close all;

video_name = 'singleball.avi';% ��Ƶ�ļ���
frame_sequence_path = '.\frame_sequence\';
total_frame_number = 30;% ��������Ƶ֡����
frame_number = 10;
reference_frame_number = 15;
current_image_number = reference_frame_number + 1;% ��ǰ��Ƶ֡

% ��ȡ��Ƶ������Ϣ
show_video_info(video_name);

% ��ȡ��Ƶ֡
get_frame_sequence(video_name, frame_sequence_path, total_frame_number);

% ��ȡ��֡ͼ���ƽ��ֵ����ʾ
mean_image_10 = get_frame_mean_image(frame_sequence_path, frame_number);
fig_1 = figure(1);
set(fig_1,'name', 'Fig_1����ֵͼ��', 'Numbertitle', 'off');
imshow(mean_image_10);
title(strcat('ǰ', num2str(reference_frame_number), '֡ͼ���ƽ��ֵͼ��'));

% ��ȡ��֡ͼ�����ֵ����ʾ
median_image_10 = get_frame_median_image(frame_sequence_path, frame_number);
fig_2 = figure(2);
set(fig_2, 'name', 'Fig_2����ֵͼ��', 'Numbertitle', 'off');
imshow(median_image_10);
title(strcat('ǰ', num2str(reference_frame_number), '֡ͼ�����ֵͼ��'));

% ��ȡ��Ƶ���е��ض�֡
image_current = read_image_from_sequence(frame_sequence_path, current_image_number);

%% ��ƽ��ֵģ�ͺ���ֵģ��Ӧ���ڵ�ǰͼ��֡
% ƽ��ֵģ��
mean_image = get_frame_mean_image(frame_sequence_path, reference_frame_number);
image_difference_mean = image_current - mean_image;
image_difference_mean = uint8(image_difference_mean);
fig_3 = figure(3);
set(fig_3, 'name', 'Fig_3����ǰ֡��ƽ��֡�Ĳ�ֵͼ��', 'Numbertitle', 'off');
imshow(image_difference_mean);
title('��ǰ֡��ƽ��֡�Ĳ�ֵͼ��');

% ��ֵģ��
median_image = get_frame_median_image(frame_sequence_path, reference_frame_number);
image_difference_median = image_current - median_image;
image_difference_median = uint8(image_difference_median);
fig_4 = figure(4);
set(fig_4, 'name', 'Fig_4����ǰ֡����ֵ֡�Ĳ�ֵͼ��', 'Numbertitle', 'off');
imshow(image_difference_median);
title('��ǰ֡����ֵ֡�Ĳ�ֵͼ��');

fig_5 = figure(5);
set(fig_5, 'name', 'Fig_5����ֵ������ֵ���������(��������128��)', 'Numbertitle', 'off');
dif = 128 * uint8(image_difference_mean - image_difference_median);
imshow(rgb2gray(dif));
title('��ֵ������ֵ���������');
