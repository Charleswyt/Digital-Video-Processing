function image = read_image_from_sequence(frame_sequence_path, current_image_number)

img_path_list = dir(strcat(frame_sequence_path, '*.jpg'));% ��ȡ���ļ���������jpg��ʽ��ͼ��
img_num = length(img_path_list);% ��ȡͼ��������

if img_num < current_image_number
    current_image_number = img_num;
end

image_name = img_path_list(current_image_number).name;% ͼ����
image =  imread(strcat(frame_sequence_path, image_name));% ��ͼ��

end