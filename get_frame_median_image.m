function median_image = get_frame_median_image(frame_sequence_path, total_frame_number)

img_path_list = dir(strcat(frame_sequence_path, '*.jpg'));% ��ȡ���ļ���������jpg��ʽ��ͼ��
img_num = length(img_path_list);% ��ȡͼ��������

if img_num < total_frame_number
    total_frame_number = img_num;
end

median_image = [ ];

for j = 1 : total_frame_number% ��һ��ȡͼ��
    image_name = img_path_list(j).name;% ͼ����
    image =  imread(strcat(frame_sequence_path, image_name));% ��ͼ��
    median_image = [median_image, double(image(:))];
end
siz = size(image);
median_image = median_image';
median_image = median(median_image);
median_image = reshape(median_image,siz);
median_image = uint8(median_image);
end