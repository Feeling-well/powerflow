%% ���ܣ����
%���ߣ�������
%��д��2016.x.x��������ѧ
%�޸���2017.11.3��������ѧ������δ�Ķ����޸��Ű漰����˵��
%% ����˵��
%jie��������
%delta�����������          deltv����ѹ��С������
%va�����           v0����ѹ��ֵ
%accuracy����������
function [va,v0,accuracy,delta] =Revise(Jacobian,delt,nodenum,va,v0)
jie=Jacobian\delt;
delta=jie(1:nodenum);               %���������
deltv=jie((nodenum+1):2*nodenum);   %��ѹ��С������
va=va-delta;
v0=v0-deltv;
accuracy=max(abs(deltv));
end