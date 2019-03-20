%% 功能：修正不平衡量
%作者：苏向阳
%编写于2016.x.x
%修改于2017.11.3，修改角度求法，速度提升0.15s左右
%% 变量说明
%deltp：有功修正量    deltq：无功修正量
%delt：p,q修正量数组
%va：相角           v0：电压幅值
%system(2)：平衡节点号
function [delt,pv]=Delts(y,pis,qis,va,v0,pv,system)
va=sparse(va);
v=v0.*(cos(va)+1j*sin(va)); %节点电压复数形式
delt0=conj(y*v);            %conj求共轭  
delt1=v.*delt0;             %代入节点电压求出的功率
%检测pv节点无功是否越限
deltp=pis-real(delt1);       %有功修正量
deltq=qis-imag(delt1);       %无功修正量
deltp(system(2))=0;          %有功修正量(处理平衡节点)
deltq(system(2))=0;          %无功修正量（处理平衡节点）
deltq(pv.i)=0;               %无功修正量（处理pv节点）
delt=[deltp;deltq];          %p,q修正量数组
end