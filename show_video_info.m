function show_video_info(video_path)

video = VideoReader(video_path);% ��ȡ��Ƶ
output = sprintf('��Ƶ��ʱ��Ϊ��%0.1f��', video.Duration);disp(output);
output = sprintf('��Ƶ֡��Ϊ��%0.1f֡/��', video.FrameRate);disp(output);
output = sprintf('��Ƶ��֡��Ϊ��%d֡', video.NumberOfFrames);disp(output);
output = sprintf('��Ƶ�߶�Ϊ��%d����', video.Height);disp(output);
output = sprintf('��Ƶ���Ϊ��%d����', video.Width);disp(output);
disp(['��Ƶ����Ϊ��', video.VideoFormat]);