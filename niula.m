clc;
clear;
[FileName,PathName]=uigetfile('*.dat');
tic;                 %记录时间
path=strcat(PathName,FileName);
a=textread(path);
%a=textread(filename);        %读文件
c=a(1,:);
c(2)=a(3,2);               %平衡节点
c(3)=1;                    %平衡节点电压
c(4)=a(2,1);               %迭代精度
n=c(1);                 %节点数目
b=find(a(:,1)==0);      %记录0元素的行号
line=b(2)-b(1)-1;       %线路参数共有行数
knum=b(2)-1;         %线路参数结束行数
%读取线路参数，N0序号，i、j为线路标号
lineblock=a(b(1)+1:knum,:);
% lineNo=lineblock(1:line,1);
linei=lineblock(1:line,2);
linej=lineblock(1:line,3);
liner=lineblock(1:line,4);
linex=lineblock(1:line,5);
lineb=lineblock(1:line,6);
%接地支路参数读取
branch=b(3)-b(2)-1;     %接地支路共有行数
k1=knum+2;          %接地支路开始行
k2=knum+1+branch;     %接地支路结束行
branchblock=a(k1:k2,:);
branchi=branchblock(1:branch,1);
branchb=branchblock(1:branch,2);
branchg=branchblock(1:branch,3);

%变压器参数读取
trans=b(4)-b(3)-1;     %变压器参数共有行数
k1=k2+2;             %变压器参数开始行
k2=b(3)+trans;         %变压器参数结束行
transblock=a(k1:k2,:);  
transNo=transblock(1:trans,1);
transi=transblock(1:trans,2);
transj=transblock(1:trans,3);
transr=transblock(1:trans,4);
transx=transblock(1:trans,5);
transk=transblock(1:trans,6);


pow=b(5)-b(4)-1;    %节点功率共有行数
k1=k2+2;          %节点功率开始行
k2=k2+1+pow;
%读取节点功率参数
powblock=a(k1:k2,:);
%powNo=powblock(1:pow,1);
powi=powblock(1:pow,1);
powpgi=powblock(1:pow,2);
powqgj=powblock(1:pow,3);
powpdi=powblock(1:pow,4);
powqdj=powblock(1:pow,5);
pv=b(6)-b(5)-1;     %PV节点共有行数
k1=k2+2;          %PV节点开始行
k2=k2+1+pv;       %PV节点结束行
%读取pv节点参数
pvblock=a(k1:k2,:);
pvNo=pvblock(1:pv,1);
pvi=pvblock(1:pv,1);
pvv=pvblock(1:pv,2);
pvqmin=pvblock(1:pv,3);
pvqmax=pvblock(1:pv,4);
%clear a;            %清空a矩阵有什么好处吗？清空高速缓存
%仅线路导纳矩阵
y0=-sparse(linei,linej,1./(liner+j*linex),n,n)-sparse(linej,linei,1./(liner+j*linex),n,n)+...
    sparse(linei,linei,1./(liner+j*linex)+j*lineb,n,n)+sparse(linej,linej,1./(liner+j*linex)+j*lineb,n,n);
%仅变压器导纳矩阵
y3=-sparse(transi,transj,1./(transr+j*transx)./transk,n,n)+...
    -sparse(transj,transi,1./(transr+j*transx)./transk,n,n)+...
    sparse(transi,transi,(1-transk)./(transr+j*transx)./transk./transk+1./(transr+j*transx)./transk,n,n)+...
    sparse(transj,transj,(transk-1)./(transr+j*transx)./transk+1./(transr+j*transx)./transk,n,n);
%z22=(1-transk)./(transr+j*transx)./transk./transk+1./(transr+j*transx)./transk;
%z2=1./(transr+j*transx)./transk;
%仅含接地支路的导纳矩阵
y2=sparse(branchi,branchi,branchg+j*branchb,n,n);
y=y0+y3+y2;         %形成节点导纳矩阵
y1=abs(y);                         % sqrt(real(y).*real(y)+imag(y).*imag(y));
pis=sparse(powi,1,(powpgi-powpdi)./100,n,1);      %节点注入有功功率
qis=sparse(powi,1,(powqgj-powqdj)./100,n,1);      %节点注入无功功率
v0=sparse(1*ones(1,n)');  %节点电压大小初始化
va=sparse(zeros(n,1));  %相角初始化
v0(c(2))=c(3);          %平衡节点电压
v0(pvi)=pvv;            %pv节点电压
ee=1;                   %精度
k=1;                    %迭代次数
while(ee>c(4)&&k<20)
ij=repmat(va,1,n)-repmat(va',n,1)-angle(y);          %角
v=v0.*(cos(va)+j*sin(va));  %节点电压复数形式
delt0=conj(y*v);          %conj求共轭  
delt1=v.*delt0;          %代入节点电压求出的功率
%检测pv节点无功是否越限
deltp=pis-real(delt1);  %有功修正量
deltq=qis-imag(delt1);  %无功修正量

deltp(c(2))=0;          %有功修正量(处理平衡节点)
deltq(c(2))=0;          %无功修正量（处理平衡节点）
deltq(pvi)=0;           %无功修正量（处理pv节点）n                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
delt=[deltp;deltq];     %p,q修正量数组

%形成雅克比矩阵
h=diag(diag(v0)*(y1.*sin(ij))*v0)-diag(v0)*(y1.*sin(ij))*diag(v0);    %h矩阵
nn=-diag(v0)*(y1.*cos(ij))-diag((y1.*cos(ij))*v0);         %n矩阵
jj=-diag(diag(v0)*(y1.*cos(ij))*v0)+diag(v0)*(y1.*cos(ij))*diag(v0);
l=-diag(v0)*(y1.*sin(ij))-diag((y1.*sin(ij))*v0);
nn(:,pvi)=0;              %处理pv节点
jj(pvi,:)=0;              %处理pv节点
l(pvi,:)=0;               %处理pv节点
l(:,pvi)=0;               %处理pv节点
l=l+sparse(pvi,pvi,1,n,n);  %形成l
ykb=[h nn;jj l];          %初步形成雅可比矩阵
ykb(c(2),:)=0;          %处理平衡节点a
ykb(:,c(2))=0;          %处理平衡节点a
ykb(c(2),c(2))=1;       %处理平衡节点a
ykb(c(2)+n,:)=0;          %处理平衡节点v
ykb(:,c(2)+n)=0;          %处理平衡节点v
ykb(c(2)+n,c(2)+n)=1;       %处理平衡节点v

jie=ykb\delt;
delta=jie(1:n);         %相角修正量
deltv=jie((n+1):2*n);   %电压大小修正量
va=va-delta;
v0=v0-deltv;
ee=max(abs(deltv));
k=k+1;
end
%输出数据
va=va.*180./pi                %相角
v0                          %电压幅值
toc                         %迭代次数为k