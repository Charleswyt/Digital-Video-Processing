% ����
%   imgP : ��ǰ֡��Ϊ��Ѱ���˶�������
%   imgI : �ο�֡
%   mbSize : ���С
%   p : �������ڲ������������ڴ�СΪ(2p+1)��(2p+1)��
%
% ���
%   motionVect : �˶�����
%   SS4computations: ����ÿ��������ƽ����������

function [motionVect, SS4Computations] = motionEst4SS(imgP, imgI, mbSize, p)

[row, col] = size(imgI);

vectors = zeros(2,row*col/mbSize^2);
costs = ones(3, 3) * 65537;

% ��ͼ�����Ͻǿ�ʼ����
% �������ң����ϵ��£���mbSizeΪ���С��������
% ��ÿһ���ϡ��¡�����p�����صķ�Χ���������ƥ���
computations = 0;
mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        % 4����������ʼ
        x = j;
        y = i;
        
        % �����������ڵ�����ֵ
        costs(2,2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i:i+mbSize-1,j:j+mbSize-1),mbSize);
        computations = computations + 1;
        
        % ��һ��������9����
        for m = -2 : 2 : 2
            for n = -2 : 2 : 2
                refBlkVer = y + m;% ��ֱ����
                refBlkHor = x + n;% ˮƽ����
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                        || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;% ����ͼ��Χ������ѭ������һ���������
                end
                
                costRow = m/2 + 2;
                costCol = n/2 + 2;
                if (costRow == 2 && costCol == 2)
                    continue;% �������ĵ㣬��������ѭ������һ���������
                end
                costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                    imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                computations = computations + 1;
                
            end
        end
        
        [dx, dy, cost] = minCost(costs);
        
        % ��MBD��������ģʽ������ʱ��flag_4ss��Ϊ1
        % �Բ���Ϊ1�ķ���ģʽ��������
        if (dx == 2 && dy == 2)
            flag_4ss = 1;
        else
            flag_4ss = 0;
            xLast = x;
            yLast = y;
            x = x + (dx-2)*2;
            y = y + (dy-2)*2;
        end
        
        costs = ones(3,3) * 255;
        costs(2,2) = cost;
        
        % ��MBD�㲻������ģʽ������ʱ��flag_4ss��Ϊ0
        % �����Բ���Ϊ2�ķ���ģʽ��������
        stage = 1;
        while (flag_4ss == 0 && stage <=2)
            for m = -2 : 2 : 2
                for n = -2 : 2 : 2
                    refBlkVer = y + m;
                    refBlkHor = x + n;
                    if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                            || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                        continue;
                    end
                    
                    if (refBlkHor >= xLast - 2 && refBlkHor <= xLast + 2 ...
                            && refBlkVer >= yLast - 2 && refBlkVer <= yLast + 2 )
                        continue;
                    end
                    
                    costRow = m/2 + 2;
                    costCol = n/2 + 2;
                    if (costRow == 2 && costCol == 2)
                        continue
                    end
                    
                    costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                        imgI(refBlkVer:refBlkVer+mbSize-1, ...
                        refBlkHor:refBlkHor+mbSize-1), mbSize);
                    computations = computations + 1;
                    
                end
            end
            
            [dx, dy, cost] = minCost(costs);
            
            
            if (dx == 2 && dy == 2)
                flag_4ss = 1;
            else
                flag_4ss = 0;
                xLast = x;
                yLast = y;
                x = x + (dx-2)*2;
                y = y + (dy-2)*2;
            end
            
            costs = ones(3,3) * 65537;
            costs(2,2) = cost;
            stage = stage + 1;   
        end
        
        
        % �������һ�����Բ���Ϊ1�ķ���ģʽ��������
        for m = -1 : 1 : 1
            for n = -1 : 1 : 1
                refBlkVer = y + m;
                refBlkHor = x + n;
                if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                    continue;
                end
                
                costRow = m + 2;
                costCol = n + 2;
                if (costRow == 2 && costCol == 2)
                    continue
                end
                costs(costRow, costCol ) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                    imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
                computations = computations + 1;
            end
        end
        
        [dx, dy, cost] = minCost(costs);
        
        x = x + dx - 2;
        y = y + dy - 2;
        
        vectors(1,mbCount) = y - i;
        vectors(2,mbCount) = x - j;
        mbCount = mbCount + 1;
        costs = ones(3,3) * 65537;
        
    end
end

motionVect = vectors;
SS4Computations = computations/(mbCount - 1);