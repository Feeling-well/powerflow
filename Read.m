%% 函数说明
%功能：读取数据文件
%作者：苏向阳
%编写于2016.x.x，广西大学
%修改于2017.11.3，广西大学。修改外观及说明，代码部分未更改
%% 符号说明
%system：系统参数       line：线路参数
%branch：接地支路参数   trans：变压器参数
%pow：节点功率参数      pv：pv节点参数 
function [system,nodenum,line,branch,trans,pow,pv] = Read(dataA)
%% 读文件
system=dataA(1,:);
system(2)=dataA(3,2);                     %平衡节点
system(3)=1;                              %平衡节点电压
system(4)=dataA(2,1);                     %迭代精度
nodenum=system(1);                        %节点数目
zero=find(dataA(:,1)==0);                 %记录0元素的行号
%% 读取线路参数，N0序号，i、j为线路标号
lines=zero(2)-zero(1)-1;                  %线路参数共有行数
knum=zero(2)-1;                           %线路参数结束行数
lineblock=dataA(zero(1)+1:knum,:);        %线路参数整块
line.i=lineblock(1:lines,2);              %线路参数的母线i
line.j=lineblock(1:lines,3);              %线路参数的母线j
line.r=lineblock(1:lines,4);              %线路参数的R
line.x=lineblock(1:lines,5);              %线路参数的X
line.b=lineblock(1:lines,6);              %线路参数的B
%% 接地支路参数读取
branchline=zero(3)-zero(2)-1;             %接地支路共有行数
k1=knum+2;                                %接地支路开始行
k2=knum+1+branchline;                     %接地支路结束行
branchblock=dataA(k1:k2,:);               %接地支路参数整块
branch.i=branchblock(1:branchline,1);     %节点号
branch.b=branchblock(1:branchline,2);     %接地支路导纳
branch.g=branchblock(1:branchline,3);
%% 变压器参数读取
transline=zero(4)-zero(3)-1;              %变压器参数共有行数
k1=k2+2;                                  %变压器参数开始行
k2=zero(3)+transline;                     %变压器参数结束行
transblock=dataA(k1:k2,:);                %变压器整块参数
trans.i=transblock(1:transline,2);        %变压器参数的母线i
trans.j=transblock(1:transline,3);        %变压器参数的母线j
trans.r=transblock(1:transline,4);        %变压器参数的R
trans.x=transblock(1:transline,5);        %变压器参数的X
trans.k=transblock(1:transline,6);        %变压器参数的变比
%% 读取节点功率参数
powline=zero(5)-zero(4)-1;                %节点功率共有行数
k1=k2+2;                                  %节点功率开始行
k2=k2+1+powline;
powblock=dataA(k1:k2,:);                  %节点功率整块参数
pow.i=powblock(1:powline,1);              %节点功率参数的节点号
pow.pgi=powblock(1:powline,2);            %节点功率参数的PG
pow.qgj=powblock(1:powline,3);            %节点功率参数的QG
pow.pdi=powblock(1:powline,4);            %节点功率参数的PD
pow.qdj=powblock(1:powline,5);            %节点功率参数的QD
%% 读取pv节点参数
pvline=zero(6)-zero(5)-1;                  %PV节点共有行数
k1=k2+2;                                   %PV节点开始行
k2=k2+1+pvline;                            %PV节点结束行
pvblock=dataA(k1:k2,:);                    %PV节点整块参数
pv.i=pvblock(1:pvline,1);                  %PV节点参数的节点号
pv.v=pvblock(1:pvline,2);                  %PV节点参数的电压
pv.qmin=pvblock(1:pvline,3);               %PV节点参数的Qmin
pv.qmax=pvblock(1:pvline,4);               %PV节点参数的Qmax
pv.angle=sparse([],[],[],nodenum,1);       %PV节点相角
clear dataA;                              %清空a矩阵，好处：清空高速缓存