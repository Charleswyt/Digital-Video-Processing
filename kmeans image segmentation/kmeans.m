function [mu,mask]=kmeans(ima,k)%kΪָ�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   kmeans image segmentation
%
%   Input:
%          ima: grey color image�Ҷ�ͼ��
%          k: Number of classesָ����ͼ���������Ŀ
%   Output:
%          mu: vector of class means ÿ����ľ�ֵ
%          mask: clasification image mask������ͼ����Ĥ��mask)
%
%   Author: Jose Vicente Manjon Herrera
%    Email: jmanjon@fis.upv.es
%     Date: 27-08-2005
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pic=imread('1.jpg');
imshow(pic);
pic=rgb2hsv(pic);
h=pic(:,:,2);
h=round(h*255);
ima=h;
k=2;
% check image
ima=double(ima);
copy=ima;         % make a copy
ima=ima(:);       % vectorize ima��ͼ������������һά����
mi=min(ima);      % deal with negative 
ima=ima-mi+1;     % and zero values

s=length(ima);%���ͼ�����ظ���

% create image histogram%����ͼ��ֱ��ͼ

m=max(ima)+1;%�������ֵ��1
h=zeros(1,m);%ֱ��ͼ����m��bin
hc=zeros(1,m);%��ž���ÿ�����ص��ֵΪ�õ�������������

for i=1:s%s��ͼ�����ظ�����������ÿ������
  if(ima(i)>0) h(ima(i))=h(ima(i))+1;end;%ֱ��ͼ�ж�Ӧbin��1
end
ind=find(h);%�ҵ�ֱ��ͼ�в�Ϊ�����Щbin����š�
hl=length(ind);%ֱ��ͼ�з���bin�ĸ���

% initiate centroids

mu=(1:k)*m/(k+1);%kΪָ�����������muΪ��ͬ��ķָ�㣬�൱���������ϵ�����

% start process

while(true)
  
  oldmu=mu;
  % current classification  
 
  for i=1:hl
      c=abs(ind(i)-mu);%�����൱�ڿ���ind(i)�������������ĸ����������ע��mu�ܹ���k��
      cc=find(c==min(c));%cc��������ind(i)����������ţ����Ϊ1��2��3...k
      hc(ind(i))=cc(1);
  end
  
  %recalculation of means  ����ĳ������ڼ���ÿһ��ľ�ֵλ��
  
  for i=1:k, 
      a=find(hc==i);
      mu(i)=sum(a.*h(a))/sum(h(a));%hΪֱ��ͼ
  end
  
  if(mu==oldmu) break;end;%ѭ����������
  
end

% calculate mask
s=size(copy);
mask=zeros(s);
mask1=mask;%����һ����ʾ����
size(mask1)
for i=1:s(1),
for j=1:s(2),
  c=abs(copy(i,j)-mu);
  a=find(c==min(c));  
  mask(i,j)=a(1);
end
end

mu=mu+mi-1;   % recover real range

for	i	=	1	:	k
	p=find(mask==i);
	mask1(p)=1/k*i;
end
figure,imshow(mask1)

%������������֣�
%rgb��hsv�ռ��
%hЧ����ã�
%v��Ч�������ڶ�ֵ�����ܲ���
%sҲ����̫��