function mean_image = get_frame_mean_image(frame_sequence_path, total_frame_number)

img_path_list = dir(strcat(frame_sequence_path, '*.jpg'));% ��ȡ���ļ���������jpg��ʽ��ͼ��
img_num = length(img_path_list);% ��ȡͼ��������

if img_num < total_frame_number
    total_frame_number = img_num;
end

% �ڼ��������һ��Ҫ��ͼ��ת��Ϊdouble���ͣ��������ͼ�����
image_name = img_path_list(1).name;% ͼ����
image =  imread(strcat(frame_sequence_path, image_name));% ��ͼ��
image_sum = double(image);

for j = 2 : total_frame_number% ��һ��ȡͼ��
    image_name = img_path_list(j).name;% ͼ����
    image =  imread(strcat(frame_sequence_path, image_name));% ��ͼ��
    image_double = double(image);
    
    %------- ͼ������� -------%
    
    image_sum = image_sum + image_double;
    
    %----------- End -----------%
end
mean_image = image_sum / total_frame_number;
mean_image = uint8(mean_image);
end