clc;
clear;
[FileName,PathName]=uigetfile('*.dat');
tic;                 %��¼ʱ��
path=strcat(PathName,FileName);
a=textread(path);
%a=textread(filename);        %���ļ�
c=a(1,:);
c(2)=a(3,2);               %ƽ��ڵ�
c(3)=1;                    %ƽ��ڵ��ѹ
c(4)=a(2,1);               %��������
n=c(1);                 %�ڵ���Ŀ
b=find(a(:,1)==0);      %��¼0Ԫ�ص��к�
line=b(2)-b(1)-1;       %��·������������
knum=b(2)-1;         %��·������������
%��ȡ��·������N0��ţ�i��jΪ��·���
lineblock=a(b(1)+1:knum,:);
% lineNo=lineblock(1:line,1);
linei=lineblock(1:line,2);
linej=lineblock(1:line,3);
liner=lineblock(1:line,4);
linex=lineblock(1:line,5);
lineb=lineblock(1:line,6);
%�ӵ�֧·������ȡ
branch=b(3)-b(2)-1;     %�ӵ�֧·��������
k1=knum+2;          %�ӵ�֧·��ʼ��
k2=knum+1+branch;     %�ӵ�֧·������
branchblock=a(k1:k2,:);
branchi=branchblock(1:branch,1);
branchb=branchblock(1:branch,2);
branchg=branchblock(1:branch,3);

%��ѹ��������ȡ
trans=b(4)-b(3)-1;     %��ѹ��������������
k1=k2+2;             %��ѹ��������ʼ��
k2=b(3)+trans;         %��ѹ������������
transblock=a(k1:k2,:);  
transNo=transblock(1:trans,1);
transi=transblock(1:trans,2);
transj=transblock(1:trans,3);
transr=transblock(1:trans,4);
transx=transblock(1:trans,5);
transk=transblock(1:trans,6);


pow=b(5)-b(4)-1;    %�ڵ㹦�ʹ�������
k1=k2+2;          %�ڵ㹦�ʿ�ʼ��
k2=k2+1+pow;
%��ȡ�ڵ㹦�ʲ���
powblock=a(k1:k2,:);
%powNo=powblock(1:pow,1);
powi=powblock(1:pow,1);
powpgi=powblock(1:pow,2);
powqgj=powblock(1:pow,3);
powpdi=powblock(1:pow,4);
powqdj=powblock(1:pow,5);
pv=b(6)-b(5)-1;     %PV�ڵ㹲������
k1=k2+2;          %PV�ڵ㿪ʼ��
k2=k2+1+pv;       %PV�ڵ������
%��ȡpv�ڵ����
pvblock=a(k1:k2,:);
pvNo=pvblock(1:pv,1);
pvi=pvblock(1:pv,1);
pvv=pvblock(1:pv,2);
pvqmin=pvblock(1:pv,3);
pvqmax=pvblock(1:pv,4);
%clear a;            %���a������ʲô�ô�����ո��ٻ���
%����·���ɾ���
y0=-sparse(linei,linej,1./(liner+j*linex),n,n)-sparse(linej,linei,1./(liner+j*linex),n,n)+...
    sparse(linei,linei,1./(liner+j*linex)+j*lineb,n,n)+sparse(linej,linej,1./(liner+j*linex)+j*lineb,n,n);
%����ѹ�����ɾ���
y3=-sparse(transi,transj,1./(transr+j*transx)./transk,n,n)+...
    -sparse(transj,transi,1./(transr+j*transx)./transk,n,n)+...
    sparse(transi,transi,(1-transk)./(transr+j*transx)./transk./transk+1./(transr+j*transx)./transk,n,n)+...
    sparse(transj,transj,(transk-1)./(transr+j*transx)./transk+1./(transr+j*transx)./transk,n,n);
%z22=(1-transk)./(transr+j*transx)./transk./transk+1./(transr+j*transx)./transk;
%z2=1./(transr+j*transx)./transk;
%�����ӵ�֧·�ĵ��ɾ���
y2=sparse(branchi,branchi,branchg+j*branchb,n,n);
y=y0+y3+y2;         %�γɽڵ㵼�ɾ���
y1=abs(y);                         % sqrt(real(y).*real(y)+imag(y).*imag(y));
pis=sparse(powi,1,(powpgi-powpdi)./100,n,1);      %�ڵ�ע���й�����
qis=sparse(powi,1,(powqgj-powqdj)./100,n,1);      %�ڵ�ע���޹�����
v0=sparse(1*ones(1,n)');  %�ڵ��ѹ��С��ʼ��
va=sparse(zeros(n,1));  %��ǳ�ʼ��
v0(c(2))=c(3);          %ƽ��ڵ��ѹ
v0(pvi)=pvv;            %pv�ڵ��ѹ
ee=1;                   %����
k=1;                    %��������
while(ee>c(4)&&k<20)
ij=repmat(va,1,n)-repmat(va',n,1)-angle(y);          %��
v=v0.*(cos(va)+j*sin(va));  %�ڵ��ѹ������ʽ
delt0=conj(y*v);          %conj����  
delt1=v.*delt0;          %����ڵ��ѹ����Ĺ���
%���pv�ڵ��޹��Ƿ�Խ��
deltp=pis-real(delt1);  %�й�������
deltq=qis-imag(delt1);  %�޹�������

deltp(c(2))=0;          %�й�������(����ƽ��ڵ�)
deltq(c(2))=0;          %�޹�������������ƽ��ڵ㣩
deltq(pvi)=0;           %�޹�������������pv�ڵ㣩n                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
delt=[deltp;deltq];     %p,q����������

%�γ��ſ˱Ⱦ���
h=diag(diag(v0)*(y1.*sin(ij))*v0)-diag(v0)*(y1.*sin(ij))*diag(v0);    %h����
nn=-diag(v0)*(y1.*cos(ij))-diag((y1.*cos(ij))*v0);         %n����
jj=-diag(diag(v0)*(y1.*cos(ij))*v0)+diag(v0)*(y1.*cos(ij))*diag(v0);
l=-diag(v0)*(y1.*sin(ij))-diag((y1.*sin(ij))*v0);
nn(:,pvi)=0;              %����pv�ڵ�
jj(pvi,:)=0;              %����pv�ڵ�
l(pvi,:)=0;               %����pv�ڵ�
l(:,pvi)=0;               %����pv�ڵ�
l=l+sparse(pvi,pvi,1,n,n);  %�γ�l
ykb=[h nn;jj l];          %�����γ��ſɱȾ���
ykb(c(2),:)=0;          %����ƽ��ڵ�a
ykb(:,c(2))=0;          %����ƽ��ڵ�a
ykb(c(2),c(2))=1;       %����ƽ��ڵ�a
ykb(c(2)+n,:)=0;          %����ƽ��ڵ�v
ykb(:,c(2)+n)=0;          %����ƽ��ڵ�v
ykb(c(2)+n,c(2)+n)=1;       %����ƽ��ڵ�v

jie=ykb\delt;
delta=jie(1:n);         %���������
deltv=jie((n+1):2*n);   %��ѹ��С������
va=va-delta;
v0=v0-deltv;
ee=max(abs(deltv));
k=k+1;
end
%�������
va=va.*180./pi                %���
v0                          %��ѹ��ֵ
toc                         %��������Ϊk