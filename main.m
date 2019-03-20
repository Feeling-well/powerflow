%% ����˵��
%���ܣ���������
%���ߣ�������
%��д��2016.x.x
%�޸���2017.10.27��������ѧ
%�޸���2017.11.3 ��������ѧ���޸�һЩ��������read�Ӻ���
%% ����˵��
% nodenum���ڵ�����;        node���ڵ��;             blanNode��ƽ��ڵ��;    
% dataA��ϵͳ����;          lineblock����·����;      branchblock���ӵ�֧·����;
% transblock����ѹ������;   pvNodepara��pv�ڵ����
% y���ڵ㵼�ɾ���           pvNode��PV�ڵ��;         pvNum��PV�ڵ�����
% pis���ڵ�ע���й�;        qis���ڵ�ע���޹�   
% iteration����������;      accuracy����������;
% deltP���й���ƽ����       deltQ���޹���ƽ����       delta�����������    deltv����ѹ������
% angleij:���              Voltage����ֵ
function main()
clc
clear
[fileName,pathName] = uigetfile({'*.dat';'*.txt'},'��ѡ��һ�������ļ�');
if  pathName == 0
    error('��ѡ����ʵ��ļ�');
else
    path=strcat(pathName,fileName);
    dataA=textread(path);
    tic                                                                  %��ʱ��ʼ
    [system,nodenum,line,branch,trans,pow,pv] = Read(dataA);             %���ݶ�ȡ
end
[y,y_abs,yi,yj,y1angle,pis,qis,va,v0] = Ymatrix(system,nodenum,line,branch,trans,pow,pv);%�γɽڵ㵼�ɾ���
accuracy=1;                                                              %������1
iteration=1;                                                             %��������
deltPandQ=[];
while(accuracy>system(4)&&iteration<20)
[delt,pv]=Delts(y,pis,qis,va,v0,pv,system);                              %��ƽ����
[Jacobian] =Jacobi(yi,yj,y_abs,y1angle,v0,nodenum,pv,system);            %�γ��ſ˱Ⱦ���
[va,v0,accuracy,delta] = Revise(Jacobian,delt,nodenum,va,v0);            %�������
pv.angle=pv.angle-delta;                                                 %pv.��Ǵ���
deltPandQ(iteration)=max(abs(delt));                                     %���ƽ����
iteration=iteration+1;
end
%% �������
time=toc;
[va,v0] = print(va,v0,iteration,deltPandQ,system,nodenum,time);
end