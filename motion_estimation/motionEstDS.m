% ����
%   imgP : ��ǰ֡��Ϊ��Ѱ���˶�������
%   imgI : �ο�֡
%   mbSize : ���С
%   p : �������ڲ������������ڴ�СΪ(2p+1)��(2p+1)��
%
% ���
%   motionVect : �˶�����
%   DScomputations: ����ÿ��������ƽ����������

function [motionVect, DScomputations] = motionEstDS(imgP, imgI, mbSize, p)

[row, col] = size(imgI);
vectors = zeros(2,row*col/mbSize^2);
costs = ones(1, 9) * 65537;

% ����������ģʽ
LDSP(1,:) = [ 0 -2];
LDSP(2,:) = [-1 -1];
LDSP(3,:) = [ 1 -1];
LDSP(4,:) = [-2  0];
LDSP(5,:) = [ 0  0];
LDSP(6,:) = [ 2  0];
LDSP(7,:) = [-1  1];
LDSP(8,:) = [ 1  1];
LDSP(9,:) = [ 0  2];

% С��������ģʽ
SDSP(1,:) = [ 0 -1];
SDSP(2,:) = [-1  0];
SDSP(3,:) = [ 0  0];
SDSP(4,:) = [ 1  0];
SDSP(5,:) = [ 0  1];

% ��ͼ�����Ͻǿ�ʼ����
% �������ң����ϵ��£���mbSizeΪ���С��������
% ��ÿһ���ϡ��¡�����p�����صķ�Χ���������ƥ���
computations = 0;

mbCount = 1;
for i = 1 : mbSize : row-mbSize+1
    for j = 1 : mbSize : col-mbSize+1
        % ���������㷨��ʼ
        x = j;
        y = i;
        % ���������������ĵ��ֵ
        costs(5) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), imgI(i:i+mbSize-1,j:j+mbSize-1),mbSize);
        computations = computations + 1;
        
        % �Դ���������ģʽ��ʼ
        for k = 1:9
            refBlkVer = y + LDSP(k,2);   % ��ֱ����
            refBlkHor = x + LDSP(k,1);   % ˮƽ����
            if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                continue;% ����ͼ��Χ������ѭ������һ���������
            end
            
            if (k == 5)
                continue;% �������ĵ㣬��������ѭ������һ���������
            end
            costs(k) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                imgI(refBlkVer:refBlkVer+mbSize-1, refBlkHor:refBlkHor+mbSize-1), mbSize);
            computations = computations + 1;
        end
        
        [cost, point] = min(costs);% ��¼��MBD����С��ƥ�������ֵ�Լ�λ��
        
        % ����������MBD��������ģʽ�����ĵ�ʱ����SDSPFlag��Ϊ1
        % ����С��������ģʽ
        
        if (point == 5)
            SDSPFlag = 1;
        else
            SDSPFlag = 0;
            if ( abs(LDSP(point,1)) == abs(LDSP(point,2)) )
                cornerFlag = 0;
            else
                cornerFlag = 1; % ��MBD���Ǵ����εĶ���ʱ����cornerFlag��Ϊ1
            end
            xLast = x;
            yLast = y;
            x = x + LDSP(point, 1); % ������ģʽ����������һ�ε�MBD��
            y = y + LDSP(point, 2);
            costs = ones(1,9) * 65537;
            costs(5) = cost;
        end
        
        
        while (SDSPFlag == 0)% �ô���������ģʽ����
            if (cornerFlag == 1)% ��MBD���Ǵ����εĶ���ʱ��ֻ������5����
                for k = 1:9
                    refBlkVer = y + LDSP(k,2);
                    refBlkHor = x + LDSP(k,1);
                    if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                            || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                        continue;
                    end
                    
                    if (k == 5)
                        continue;
                    end
                    
                    if ( refBlkHor >= xLast - 1  && refBlkHor <= xLast + 1 && refBlkVer >= yLast - 1  && refBlkVer <= yLast + 1 )
                        continue;% ��������������������ѭ������һ������
                    elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                        continue;% �������ش��ڷ�Χ����������ѭ������һ������
                    else
                        costs(k) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                            imgI(refBlkVer:refBlkVer+mbSize-1, ...
                            refBlkHor:refBlkHor+mbSize-1), mbSize);
                        computations = computations + 1;
                    end
                end
                
            else% ��MBD���Ǵ�����4�����ϵĵ�ʱ��ֻ������3����
                switch point
                    case 2% ��MBD�Ǵ������ϵ�2��ʱ��ֻ������������ģʽ�ϵ�1 2 3 4��
                        refBlkVer = y + LDSP(1,2);   % row/Vert co-ordinate for ref block
                        refBlkHor = x + LDSP(1,1);   % col/Horizontal co-ordinate
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            costs(1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(2,2);
                        refBlkHor = x + LDSP(2,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            
                            costs(2) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(4,2);
                        refBlkHor = x + LDSP(4,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            costs(4) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                    case 3
                        refBlkVer = y + LDSP(1,2);   % row/Vert co-ordinate for ref block
                        refBlkHor = x + LDSP(1,1);   % col/Horizontal co-ordinate
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            costs(1) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(3,2);
                        refBlkHor = x + LDSP(3,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            costs(3) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(6,2);
                        refBlkHor = x + LDSP(6,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            costs(6) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        
                    case 7
                        refBlkVer = y + LDSP(4,2);
                        refBlkHor = x + LDSP(4,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            costs(4) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(7,2);
                        refBlkHor = x + LDSP(7,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            costs(7) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(9,2);
                        refBlkHor = x + LDSP(9,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            costs(9) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        
                    case 8
                        refBlkVer = y + LDSP(6,2);
                        refBlkHor = x + LDSP(6,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            costs(6) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(8,2);
                        refBlkHor = x + LDSP(8,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p || refBlkVer > i+p)
                            % �����������ڷ�Χ
                        else
                            costs(8) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                        
                        refBlkVer = y + LDSP(9,2);
                        refBlkHor = x + LDSP(9,1);
                        if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                            % ����ͼ��Χ
                        elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p ...
                                || refBlkVer > i+p)
                            % �����������ڷ�Χ 
                        else
                            costs(9) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                                refBlkHor:refBlkHor+mbSize-1), mbSize);
                            computations = computations + 1;
                        end
                    otherwise
                end
            end
            
            [cost, point] = min(costs);
            if (point == 5)
                SDSPFlag = 1;
            else
                SDSPFlag = 0;
                if ( abs(LDSP(point,1)) == abs(LDSP(point,2)) )
                    cornerFlag = 0;
                else
                    cornerFlag = 1;
                end
                xLast = x;
                yLast = y;
                x = x + LDSP(point, 1);
                y = y + LDSP(point, 2);
                costs = ones(1,9) * 65537;
                costs(5) = cost;
            end
        end
        
        % ��С��������ģʽ����
        costs = ones(1,5) * 65537;
        costs(3) = cost;
        
        for k = 1:5
            refBlkVer = y + SDSP(k,2);
            refBlkHor = x + SDSP(k,1);
            if ( refBlkVer < 1 || refBlkVer+mbSize-1 > row ...
                    || refBlkHor < 1 || refBlkHor+mbSize-1 > col)
                continue; %����ͼ��Χ
            elseif (refBlkHor < j-p || refBlkHor > j+p || refBlkVer < i-p ...
                    || refBlkVer > i+p)
                continue;   % �������ش��ڷ�Χ
            end
            
            if (k == 3)
                continue;% �������ĵ㣬������ѭ������һ���������
            end
            
            costs(k) = costFuncMAD(imgP(i:i+mbSize-1,j:j+mbSize-1), ...
                imgI(refBlkVer:refBlkVer+mbSize-1, ...
                refBlkHor:refBlkHor+mbSize-1), mbSize);
            computations = computations + 1;
            
        end
        
        [cost, point] = min(costs);
        
        x = x + SDSP(point, 1);
        y = y + SDSP(point, 2);
        
        vectors(1,mbCount) = y - i;
        vectors(2,mbCount) = x - j;
        mbCount = mbCount + 1;
        costs = ones(1,9) * 65537;
        
    end
end

motionVect = vectors;
DScomputations = computations/(mbCount - 1);