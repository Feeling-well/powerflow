%% 功能：求解
%作者：苏向阳
%编写于2016.x.x，广西大学
%修改于2017.11.3，广西大学。内容未改动，修改排版及变量说明
%% 符号说明
%jie：修正量
%delta：相角修正量          deltv：电压大小修正量
%va：相角           v0：电压幅值
%accuracy：迭代精度
function [va,v0,accuracy,delta] =Revise(Jacobian,delt,nodenum,va,v0)
jie=Jacobian\delt;
delta=jie(1:nodenum);               %相角修正量
deltv=jie((nodenum+1):2*nodenum);   %电压大小修正量
va=va-delta;
v0=v0-deltv;
accuracy=max(abs(deltv));
end