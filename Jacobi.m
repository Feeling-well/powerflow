%% 程序说明：
%功能：形成雅可比矩阵
%作者：苏向阳
%% 编写于2016.x.x，广西大学
%修改于2017.11.3，广西大学。修改排版及变量说明，修改相角求法，速度提升约0.15s
%原求法：ij=repmat(va,1,n)-repmat(va',n,1)-angle(y); 
%repmat(A,M,N)函数的功能是将A矩阵堆叠到MxN的矩阵中去
% ij=sparse(repmat(va,1,nodenum)-repmat(va',nodenum,1)-angle(y));
%上面的语句与程序中ij的那条语句相同，但程序中的ij需要在循环的末尾对pv.angle进行求解迭代
%% 变量说明：
%ij:相角                      H、N、J、L：雅可比矩阵的子元素阵
%pv：pv节点参数               nodenum：节点数
%system：系统参数             v0：PV节点电压
%  Jacobian：雅可比矩阵       yi、yj：y_abs中非零行元素所在的行和列
%y_abs：节点导纳的幅值        y1angle：节点导纳的相角     
%va：相角                    v0：PV节点电压             
%nodenum：节点数             pv：pv节点参数
%v1、siny1、cosy1：中间变量，无实际意义
function [Jacobian] =Jacobi(yi,yj,y_abs,y1angle,v0,nodenum,pv,system)
%% 雅可比矩阵元素的分块求解（分块，速度稍微块一点，约0.05s）
v1=diag(v0);
ij = sparse(yi,yj,pv.angle(yi) - pv.angle(yj) - y1angle((yj-1)*nodenum+yi));
siny1=y_abs.*sin(ij);
cosy1=y_abs.*cos(ij);
%% H、N、J、L中的子元素阵
%% HH中的子元素阵
Jacsin1=sparse(diag(v1*(siny1)*v0));
Jacsin2=sparse(v1*(siny1)*v1);
%% NN中的子元素阵
Jacsin3=sparse(v1*(siny1));
Jacsin4=sparse(diag((siny1)*v0));
%% JJ中的子元素阵
Jaccos1=sparse(diag(v1*(cosy1)*v0));
Jaccos2=sparse(v1*(cosy1)*v1);
%% LL中的子元素阵
Jaccos3=sparse(v1*(cosy1));
Jaccos4=sparse(diag((cosy1)*v0));
%% 形成H、N、J、L
HH=Jacsin1-Jacsin2;
NN=-Jaccos3-Jaccos4;
JJ=-Jaccos1+Jaccos2;
LL=-Jacsin3-Jacsin4;
%% 雅可比矩阵元素整体求解
% HH=diag(diag(v0)*(siny1)*v0)-diag(v0)*(siny1)*diag(v0);    %h矩阵
% NN=-diag(v0)*(cosy1)-diag((cosy1)*v0);                     %n矩阵
% JJ=-diag(diag(v0)*(cosy1)*v0)+diag(v0)*(cosy1)*diag(v0);   %j矩阵
% LL=-diag(v0)*(siny1)-diag((siny1))*v0);                    %L矩阵
%% 雅可比的形成
NN(:,pv.i)=0;                                                          %处理pv节点
JJ(pv.i,:)=0;                                                          %处理pv节点
LL(pv.i,:)=0;                                                          %处理pv节点
LL(:,pv.i)=0;                                                          %处理pv节点
LL=LL+sparse(pv.i,pv.i,1,nodenum,nodenum);                             %形成L
Jacobian=[HH NN;JJ LL];                                                %初步形成雅可比矩阵
Jacobian(system(2),:)=0;                                               %处理平衡节点a
Jacobian(:,system(2))=0;                                               %处理平衡节点a
Jacobian(system(2),system(2))=1;                                       %处理平衡节点a
Jacobian(system(2)+nodenum,:)=0;                                       %处理平衡节点v
Jacobian(:,system(2)+nodenum)=0;                                       %处理平衡节点v
Jacobian(system(2)+nodenum,system(2)+nodenum)=1;                       %处理平衡节点v
end