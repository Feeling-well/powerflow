%% ����˵����
%���ܣ��γ��ſɱȾ���
%���ߣ�������
%% ��д��2016.x.x��������ѧ
%�޸���2017.11.3��������ѧ���޸��Ű漰����˵�����޸�����󷨣��ٶ�����Լ0.15s
%ԭ�󷨣�ij=repmat(va,1,n)-repmat(va',n,1)-angle(y); 
%repmat(A,M,N)�����Ĺ����ǽ�A����ѵ���MxN�ľ�����ȥ
% ij=sparse(repmat(va,1,nodenum)-repmat(va',nodenum,1)-angle(y));
%���������������ij�����������ͬ���������е�ij��Ҫ��ѭ����ĩβ��pv.angle����������
%% ����˵����
%ij:���                      H��N��J��L���ſɱȾ������Ԫ����
%pv��pv�ڵ����               nodenum���ڵ���
%system��ϵͳ����             v0��PV�ڵ��ѹ
%  Jacobian���ſɱȾ���       yi��yj��y_abs�з�����Ԫ�����ڵ��к���
%y_abs���ڵ㵼�ɵķ�ֵ        y1angle���ڵ㵼�ɵ����     
%va�����                    v0��PV�ڵ��ѹ             
%nodenum���ڵ���             pv��pv�ڵ����
%v1��siny1��cosy1���м��������ʵ������
function [Jacobian] =Jacobi(yi,yj,y_abs,y1angle,v0,nodenum,pv,system)
%% �ſɱȾ���Ԫ�صķֿ���⣨�ֿ飬�ٶ���΢��һ�㣬Լ0.05s��
v1=diag(v0);
ij = sparse(yi,yj,pv.angle(yi) - pv.angle(yj) - y1angle((yj-1)*nodenum+yi));
siny1=y_abs.*sin(ij);
cosy1=y_abs.*cos(ij);
%% H��N��J��L�е���Ԫ����
%% HH�е���Ԫ����
Jacsin1=sparse(diag(v1*(siny1)*v0));
Jacsin2=sparse(v1*(siny1)*v1);
%% NN�е���Ԫ����
Jacsin3=sparse(v1*(siny1));
Jacsin4=sparse(diag((siny1)*v0));
%% JJ�е���Ԫ����
Jaccos1=sparse(diag(v1*(cosy1)*v0));
Jaccos2=sparse(v1*(cosy1)*v1);
%% LL�е���Ԫ����
Jaccos3=sparse(v1*(cosy1));
Jaccos4=sparse(diag((cosy1)*v0));
%% �γ�H��N��J��L
HH=Jacsin1-Jacsin2;
NN=-Jaccos3-Jaccos4;
JJ=-Jaccos1+Jaccos2;
LL=-Jacsin3-Jacsin4;
%% �ſɱȾ���Ԫ���������
% HH=diag(diag(v0)*(siny1)*v0)-diag(v0)*(siny1)*diag(v0);    %h����
% NN=-diag(v0)*(cosy1)-diag((cosy1)*v0);                     %n����
% JJ=-diag(diag(v0)*(cosy1)*v0)+diag(v0)*(cosy1)*diag(v0);   %j����
% LL=-diag(v0)*(siny1)-diag((siny1))*v0);                    %L����
%% �ſɱȵ��γ�
NN(:,pv.i)=0;                                                          %����pv�ڵ�
JJ(pv.i,:)=0;                                                          %����pv�ڵ�
LL(pv.i,:)=0;                                                          %����pv�ڵ�
LL(:,pv.i)=0;                                                          %����pv�ڵ�
LL=LL+sparse(pv.i,pv.i,1,nodenum,nodenum);                             %�γ�L
Jacobian=[HH NN;JJ LL];                                                %�����γ��ſɱȾ���
Jacobian(system(2),:)=0;                                               %����ƽ��ڵ�a
Jacobian(:,system(2))=0;                                               %����ƽ��ڵ�a
Jacobian(system(2),system(2))=1;                                       %����ƽ��ڵ�a
Jacobian(system(2)+nodenum,:)=0;                                       %����ƽ��ڵ�v
Jacobian(:,system(2)+nodenum)=0;                                       %����ƽ��ڵ�v
Jacobian(system(2)+nodenum,system(2)+nodenum)=1;                       %����ƽ��ڵ�v
end