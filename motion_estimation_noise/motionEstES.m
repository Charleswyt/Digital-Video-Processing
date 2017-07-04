% ����
%   imgP : ��ǰ֡
%   imgI : �ο�֡
%   mbSize : ���С
%   p : �������������������ڴ�СΪ(2p+1)��(2p+1)��
%
% ���
%   motionVect : �˶�����
%   EScomputations: ����ÿ��������ƽ����������

function [motionVect, EScomputations] = motionEstES(imgP, imgI, mbSize, p)

[row, col] = size(imgI);

vectors = zeros(2, floor(row*col/mbSize^2));
costs = ones(2*p + 1, 2*p +1) * 65537;

computations = 0;

% ��ͼ������Ͻǿ�ʼ
% �������ң����ϵ��£���mbSizeΪ���С��������
% ��ÿһ����ϡ��¡�����p�����صķ�Χ���������ƥ���

mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        % ȫ�����㷨��ʼ
        % m���У���ֱ������
        % n���У�ˮƽ������
        % this means we are scanning in raster order
        
        for m = -p : p
            for n = -p : p
                refBlkVer = i + m;   % ��ֱ����
                refBlkHor = j + n;   % ˮƽ����
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                        || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;% ����ͼ��Χ������ѭ������һ�����������
                end
                % ����MAD��ƽ��������
                costs(m+p+1,n+p+1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                    imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                computations = computations + 1;
                
            end
        end
        
        [dx, dy, min] = minCost(costs);  % ��¼��MBD���ֵ�Լ�λ��
        vectors(1,mbCount) = dy-p-1;    % �˶�������y����
        vectors(2,mbCount) = dx-p-1;    % �˶�������x����
        mbCount = mbCount + 1;
        costs = ones(2*p + 1, 2*p +1) * 65537;
    end
end

motionVect = vectors;
EScomputations = computations/(mbCount - 1);