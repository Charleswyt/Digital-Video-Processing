% Input
%   imgP : ��ǰ֡��Ϊ��Ѱ���˶�������
%   imgI : �ο�֡
%   mbSize : ���С
%   p : �������ڣ��������ڴ�СΪ(2p+1)��(2p+1)��
%
% Ouput
%   motionVect : �˶�����
%   NTSScomputations: ����ÿ��������ƽ����������

function [motionVect, TSScomputations] = motionEstTSS(imgP, imgI, mbSize, p)

[row,  col] = size(imgI);

vectors = zeros(2,row*col/mbSize^2);
costs = ones(3, 3) * 65537;
computations = 0;

% �����������������Լ���󲽳�
L = floor(log10(p+1)/log10(2));
stepMax = 2^(L-1);

% ��ͼ�����Ͻǿ�ʼ����
% �������ң����ϵ��£���mbSizeΪ���С��������
% ��ÿһ���ϡ��¡�����p�����صķ�Χ���������ƥ���

mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        % ������������ʼ
        % ÿһ��������9����
        x = j;
        y = i;
        
        % ���������������ĵ��ֵ
        costs(2,2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i:i+mbSize-1,j:j+mbSize-1),mbSize);
        computations = computations + 1;
        stepSize = stepMax;
        
        while(stepSize >= 1)
            % m ���У���ֱ������
            % n ���У�ˮƽ������
            for m = -stepSize : stepSize : stepSize
                for n = -stepSize : stepSize : stepSize
                    refBlkVer = y + m;% ��ֱ����
                    refBlkHor = x + n;% ˮƽ����
                    if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                            || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                        continue;% ����ͼ��Χ������ѭ������һ���������
                    end
                                       
                    costRow = m/stepSize + 2;
                    costCol = n/stepSize + 2;
                    if (costRow == 2 && costCol == 2)
                        continue;% �������ĵ㣬��������ѭ������һ���������
                    end
                    costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                        imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                    computations = computations + 1;
                end
            end
            
            % ��¼��MBD����С��ƥ�������ֵ�Լ�λ��
            [dx, dy, min] = minCost(costs);
            x = x + (dx-2)*stepSize;
            y = y + (dy-2)*stepSize;
            stepSize = stepSize / 2;
            costs(2,2) = costs(dy,dx);
            
        end
        vectors(1,mbCount) = y - i;
        vectors(2,mbCount) = x - j;
        mbCount = mbCount + 1;
        costs = ones(3,3) * 65537;
    end
end

motionVect = vectors;
TSScomputations = computations/(mbCount - 1);