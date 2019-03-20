%% 程序说明：
%功能：形成节点导纳矩阵
%作者：苏向阳
%% 编写于2016.x.x，广西大学
%修改于2017.11.3，广西大学。内容未改动，修改排版及变量说明  
%% 变量说明：
%y1:线路节点导纳矩阵   y2：变压器导纳矩阵        y3：含接接地支路的导纳矩阵
%y：节点导纳矩阵       y_abs：节点导纳的幅值     y1angle：节点导纳的相角    yi、yj：y_abs中非零行元素所在的行和列  
%qis：节点注入无功功率 pis：节点有功注入功率     va：相角                  v0：PV节点电压            
function [y,y_abs,yi,yj,y1angle,pis,qis,va,v0] = Ymatrix(system,nodenum,line,branch,trans,pow,pv)
%% 仅线路导纳矩阵
y1=-sparse(line.i,line.j,1./(line.r+1j*line.x),nodenum,nodenum)-...
    sparse(line.j,line.i,1./(line.r+1j*line.x),nodenum,nodenum)+...
    sparse(line.i,line.i,1./(line.r+1j*line.x)+1j*line.b,nodenum,nodenum)+...
    sparse(line.j,line.j,1./(line.r+1j*line.x)+1j*line.b,nodenum,nodenum);
%% 仅含接地支路的导纳矩阵
y2=sparse(branch.i,branch.i,branch.g+1j*branch.b,nodenum,nodenum);
%% 仅变压器导纳矩阵
y3=-sparse(trans.i,trans.j,1./(trans.r+1j*trans.x)./trans.k,nodenum,nodenum)-...
    sparse(trans.j,trans.i,1./(trans.r+1j*trans.x)./trans.k,nodenum,nodenum)+...
    sparse(trans.i,trans.i,(1-trans.k)./(trans.r+1j*trans.x)./trans.k./trans.k+1./(trans.r+1j*trans.x)./trans.k,nodenum,nodenum)+...
    sparse(trans.j,trans.j,(trans.k-1)./(trans.r+1j*trans.x)./trans.k+1./(trans.r+1j*trans.x)./trans.k,nodenum,nodenum);
%% 形成节点导纳矩阵
y=y1+y2+y3;
%% 数据处理
y_abs=abs(y);                                              %节点导纳的幅值
y1angle=angle(y);                                          %节点导纳的相角
pis=sparse(pow.i,1,(pow.pgi-pow.pdi)./100,nodenum,1);      %节点注入有功功率
qis=sparse(pow.i,1,(pow.qgj-pow.qdj)./100,nodenum,1);      %节点注入无功功率
v0=sparse(ones(1,nodenum)');                               %节点电压大小初始化
va=sparse(zeros(nodenum,1));                               %相角初始化
v0(system(2))=system(3);                                   %平衡节点电压
v0(pv.i)=pv.v;                                             %pv节点电压
[yi,yj]=find(y_abs);                                       %查找非零行分别存储在yi和yj中
end

