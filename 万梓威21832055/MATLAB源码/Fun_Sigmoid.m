%****************************
%Ŀ�ģ�S�ͼ����
%ʱ�䣺2019/4/13
%����Ա��Jarvis
%****************************
function FunS_Value= Fun_Sigmoid(X,Bias)
    if X+Bias<-10   %�±���
        FunS_Value=-1;
    elseif X+Bias>10   %�ϱ���
        FunS_Value=1;
    else
        FunS_Value=2/(1+2.718^(-2*(X+Bias)))-1;
    end
end