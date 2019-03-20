%% ����˵��
%���ܣ���ȡ�����ļ�
%���ߣ�������
%��д��2016.x.x��������ѧ
%�޸���2017.11.3��������ѧ���޸���ۼ�˵�������벿��δ����
%% ����˵��
%system��ϵͳ����       line����·����
%branch���ӵ�֧·����   trans����ѹ������
%pow���ڵ㹦�ʲ���      pv��pv�ڵ���� 
function [system,nodenum,line,branch,trans,pow,pv] = Read(dataA)
%% ���ļ�
system=dataA(1,:);
system(2)=dataA(3,2);                     %ƽ��ڵ�
system(3)=1;                              %ƽ��ڵ��ѹ
system(4)=dataA(2,1);                     %��������
nodenum=system(1);                        %�ڵ���Ŀ
zero=find(dataA(:,1)==0);                 %��¼0Ԫ�ص��к�
%% ��ȡ��·������N0��ţ�i��jΪ��·���
lines=zero(2)-zero(1)-1;                  %��·������������
knum=zero(2)-1;                           %��·������������
lineblock=dataA(zero(1)+1:knum,:);        %��·��������
line.i=lineblock(1:lines,2);              %��·������ĸ��i
line.j=lineblock(1:lines,3);              %��·������ĸ��j
line.r=lineblock(1:lines,4);              %��·������R
line.x=lineblock(1:lines,5);              %��·������X
line.b=lineblock(1:lines,6);              %��·������B
%% �ӵ�֧·������ȡ
branchline=zero(3)-zero(2)-1;             %�ӵ�֧·��������
k1=knum+2;                                %�ӵ�֧·��ʼ��
k2=knum+1+branchline;                     %�ӵ�֧·������
branchblock=dataA(k1:k2,:);               %�ӵ�֧·��������
branch.i=branchblock(1:branchline,1);     %�ڵ��
branch.b=branchblock(1:branchline,2);     %�ӵ�֧·����
branch.g=branchblock(1:branchline,3);
%% ��ѹ��������ȡ
transline=zero(4)-zero(3)-1;              %��ѹ��������������
k1=k2+2;                                  %��ѹ��������ʼ��
k2=zero(3)+transline;                     %��ѹ������������
transblock=dataA(k1:k2,:);                %��ѹ���������
trans.i=transblock(1:transline,2);        %��ѹ��������ĸ��i
trans.j=transblock(1:transline,3);        %��ѹ��������ĸ��j
trans.r=transblock(1:transline,4);        %��ѹ��������R
trans.x=transblock(1:transline,5);        %��ѹ��������X
trans.k=transblock(1:transline,6);        %��ѹ�������ı��
%% ��ȡ�ڵ㹦�ʲ���
powline=zero(5)-zero(4)-1;                %�ڵ㹦�ʹ�������
k1=k2+2;                                  %�ڵ㹦�ʿ�ʼ��
k2=k2+1+powline;
powblock=dataA(k1:k2,:);                  %�ڵ㹦���������
pow.i=powblock(1:powline,1);              %�ڵ㹦�ʲ����Ľڵ��
pow.pgi=powblock(1:powline,2);            %�ڵ㹦�ʲ�����PG
pow.qgj=powblock(1:powline,3);            %�ڵ㹦�ʲ�����QG
pow.pdi=powblock(1:powline,4);            %�ڵ㹦�ʲ�����PD
pow.qdj=powblock(1:powline,5);            %�ڵ㹦�ʲ�����QD
%% ��ȡpv�ڵ����
pvline=zero(6)-zero(5)-1;                  %PV�ڵ㹲������
k1=k2+2;                                   %PV�ڵ㿪ʼ��
k2=k2+1+pvline;                            %PV�ڵ������
pvblock=dataA(k1:k2,:);                    %PV�ڵ��������
pv.i=pvblock(1:pvline,1);                  %PV�ڵ�����Ľڵ��
pv.v=pvblock(1:pvline,2);                  %PV�ڵ�����ĵ�ѹ
pv.qmin=pvblock(1:pvline,3);               %PV�ڵ������Qmin
pv.qmax=pvblock(1:pvline,4);               %PV�ڵ������Qmax
pv.angle=sparse([],[],[],nodenum,1);       %PV�ڵ����
clear dataA;                              %���a���󣬺ô�����ո��ٻ���