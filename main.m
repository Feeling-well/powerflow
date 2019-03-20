%% 程序说明
%功能：潮流计算
%作者：苏向阳
%编写于2016.x.x
%修改于2017.10.27，广西大学
%修改于2017.11.3 ，广西大学。修改一些参数，和read子函数
%% 变量说明
% nodenum：节点数量;        node：节点号;             blanNode：平衡节点号;    
% dataA：系统参数;          lineblock：线路参数;      branchblock：接地支路参数;
% transblock：变压器参数;   pvNodepara：pv节点参数
% y：节点导纳矩阵           pvNode：PV节点号;         pvNum：PV节点数量
% pis：节点注入有功;        qis：节点注入无功   
% iteration：迭代次数;      accuracy：迭代精度;
% deltP：有功不平衡量       deltQ：无功不平衡量       delta：相角修正量    deltv：电压修正量
% angleij:相角              Voltage：幅值
function main()
clc
clear
[fileName,pathName] = uigetfile({'*.dat';'*.txt'},'请选择一个数据文件');
if  pathName == 0
    error('请选择合适的文件');
else
    path=strcat(pathName,fileName);
    dataA=textread(path);
    tic                                                                  %计时开始
    [system,nodenum,line,branch,trans,pow,pv] = Read(dataA);             %数据读取
end
[y,y_abs,yi,yj,y1angle,pis,qis,va,v0] = Ymatrix(system,nodenum,line,branch,trans,pow,pv);%形成节点导纳矩阵
accuracy=1;                                                              %精度置1
iteration=1;                                                             %迭代次数
deltPandQ=[];
while(accuracy>system(4)&&iteration<20)
[delt,pv]=Delts(y,pis,qis,va,v0,pv,system);                              %不平衡量
[Jacobian] =Jacobi(yi,yj,y_abs,y1angle,v0,nodenum,pv,system);            %形成雅克比矩阵
[va,v0,accuracy,delta] = Revise(Jacobian,delt,nodenum,va,v0);            %方程求解
pv.angle=pv.angle-delta;                                                 %pv.相角处理
deltPandQ(iteration)=max(abs(delt));                                     %最大不平衡量
iteration=iteration+1;
end
%% 输出数据
time=toc;
[va,v0] = print(va,v0,iteration,deltPandQ,system,nodenum,time);
end