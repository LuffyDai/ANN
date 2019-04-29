%****************************
%Ŀ�ģ�������ʧ����ͼ��
%ʱ�䣺2019/4/29
%����Ա��Jarvis
%****************************
clear;clc;close all;

Scale=100;%����ϸ��100��
v1=linspace(-1,1,Scale+1);%ϸ��100
v2=linspace(-1,1,Scale+1);%ϸ��100
Z=zeros(Scale+1);%Fx
[X, Y]=meshgrid(v1,v2);
for ii= 0:Scale
    for jj=0:Scale
        Z(jj+1,ii+1)=(ii*2/Scale-1)^2+(jj*2/Scale-1)^2;%��ʧ��������
    end
end
figure(1);
mesh(X, Y, Z);
xlabel('dY1');
ylabel('dY2');
zlabel('MSE');
title('Loss Function ( MSE )');