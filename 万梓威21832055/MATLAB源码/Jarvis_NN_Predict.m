%****************************
%Ŀ�ģ�BP������Ԥ�ⲿ�֣��������ʧ����
%ʱ�䣺2019/4/13
%����Ա��Jarvis
%****************************
function Predict_YY = Jarvis_NN_Predict(Predict_x,Wo,Bo,Wl,Bl)
Data_size=size(Predict_x,1);%Ԥ�⼯������
Num_X=size(Predict_x,2);%Num_X=3
Num_L=size(Bl,1);%Num_L=50
Num_Y=size(Bo,1);%Num_Y=6
L=zeros(Num_L,1);%50��������ڵ�
Y=zeros(Num_Y,Data_size);%6������ڵ�(��Ϊ������)
    for kk=1:Data_size
        for ii=1:Num_L
            Midd=0;
            for jj=1:Num_X
                Midd=Midd+Predict_x(kk,jj)*Wl(jj,ii);%���Ȩ��
            end
            L(ii,1)=Fun_Sigmoid(Midd,Bl(ii,1));%��������Ľ��
        end
        for ii=1:Num_Y
            Midd=0;
            for jj=1:Num_L
                Midd=Midd+L(jj)*Wo(jj,ii);%���Ȩ��
            end
            Y(ii,kk)=Fun_Sigmoid(Midd,Bo(ii,1));%�������Ľ��
        end
    end
Predict_YY=Y';%Ԥ����
end