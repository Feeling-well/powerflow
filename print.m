%% 程序说明
%功能：输出结果
%作者：苏向阳
%编写于2017.12.3
%% 变量说明
% va：电压相角               v0：电压幅值           iteration：迭代次数 
% deltPandQ：最大不平衡量    nodenum：节点数目      time：计算时间          
function [va,v0] = print(va,v0,iteration,deltPandQ,system,nodenum,time)
%% 图形输出
va(system(2),1)=0;
figure('NumberTitle', 'off', 'Name', 'IEEE');   %图形说明
subplot(3,1,1);                                 %图形位置
 plot(1:iteration-1,deltPandQ,'b');
 hold on 
 scatter(1:iteration-1,deltPandQ,'b');
 xlabel('迭代次数');
ylabel('最大不平衡量');
title('收敛性');
 subplot(3,1,2);                                %图形位置
 scatter(1:nodenum,v0,20,'g');
xlabel('节点号');
ylabel('电压(pu)');
title('节点电压分布');           
 subplot(3,1,3);                                %图形位置
 scatter(1:nodenum,full(va),20,'r');
xlabel('节点号');
ylabel('相角(弧度)');
title('节点相角分布');
va=va.*180./pi;                                 %转化成角度
%% 命令窗口输出
disp('节点电压幅值：');
disp(v0)
disp('节点电压相角：');
disp(va)
disp(['迭代次数 ',num2str(iteration)])
disp(['计算时间 ',num2str(time)])
end