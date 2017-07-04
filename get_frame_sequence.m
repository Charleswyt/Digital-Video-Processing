function get_frame_sequence(video_name, frame_sequence_path, total_frame_number)
video = VideoReader(video_name);% ��ȡ��Ƶ
frame_number = floor(video.Duration * video.FrameRate);% ��ȡ��ǰ��Ƶ��֡��
if total_frame_number > frame_number
    total_frame_number = frame_number;
end
for i = 1 : total_frame_number
    image_name = strcat(frame_sequence_path, num2str(i), '.jpg');
    image = read(video, i);% ����ͼƬ
    imwrite(image, image_name, 'jpg');% дͼƬ
end
end