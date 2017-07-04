function add_gaussian_noise_to_frames(frame_sequence_path, frame_noise_sequence_path, mean, variance)

%%
% frame_sequence_path = '.\frame_sequence\'
% frame_noise_sequence_path = '.\frame_noise_sequence\'
% mean = 0
% variance = 0.1

img_path_list = dir(strcat(frame_sequence_path, '*.jpg'));% ��ȡ���ļ���������jpg��ʽ��ͼ��
img_num = length(img_path_list);% ��ȡͼ��������
if img_num > 0% ������������ͼ��
    for j = 1:img_num% ��һ��ȡͼ��
        image_name = img_path_list(j).name;% ͼ����
        image =  imread(strcat(frame_sequence_path, image_name));% ��ͼ��
        dot_index = strfind(image_name, '.');% ��ȡdot��λ��
        image_write_name = strcat(frame_noise_sequence_path, image_name(1:dot_index - 1), '_noise', '.jpg');% ���ͼ����
        
        %------- ͼ������� -------%
        iamge_noise = imnoise(image, 'gaussian', mean, variance);
        imwrite(iamge_noise, image_write_name);
        %----------- End -----------%
    end
end