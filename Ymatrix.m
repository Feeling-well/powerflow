%% ����˵����
%���ܣ��γɽڵ㵼�ɾ���
%���ߣ�������
%% ��д��2016.x.x��������ѧ
%�޸���2017.11.3��������ѧ������δ�Ķ����޸��Ű漰����˵��  
%% ����˵����
%y1:��·�ڵ㵼�ɾ���   y2����ѹ�����ɾ���        y3�����ӽӵ�֧·�ĵ��ɾ���
%y���ڵ㵼�ɾ���       y_abs���ڵ㵼�ɵķ�ֵ     y1angle���ڵ㵼�ɵ����    yi��yj��y_abs�з�����Ԫ�����ڵ��к���  
%qis���ڵ�ע���޹����� pis���ڵ��й�ע�빦��     va�����                  v0��PV�ڵ��ѹ            
function [y,y_abs,yi,yj,y1angle,pis,qis,va,v0] = Ymatrix(system,nodenum,line,branch,trans,pow,pv)
%% ����·���ɾ���
y1=-sparse(line.i,line.j,1./(line.r+1j*line.x),nodenum,nodenum)-...
    sparse(line.j,line.i,1./(line.r+1j*line.x),nodenum,nodenum)+...
    sparse(line.i,line.i,1./(line.r+1j*line.x)+1j*line.b,nodenum,nodenum)+...
    sparse(line.j,line.j,1./(line.r+1j*line.x)+1j*line.b,nodenum,nodenum);
%% �����ӵ�֧·�ĵ��ɾ���
y2=sparse(branch.i,branch.i,branch.g+1j*branch.b,nodenum,nodenum);
%% ����ѹ�����ɾ���
y3=-sparse(trans.i,trans.j,1./(trans.r+1j*trans.x)./trans.k,nodenum,nodenum)-...
    sparse(trans.j,trans.i,1./(trans.r+1j*trans.x)./trans.k,nodenum,nodenum)+...
    sparse(trans.i,trans.i,(1-trans.k)./(trans.r+1j*trans.x)./trans.k./trans.k+1./(trans.r+1j*trans.x)./trans.k,nodenum,nodenum)+...
    sparse(trans.j,trans.j,(trans.k-1)./(trans.r+1j*trans.x)./trans.k+1./(trans.r+1j*trans.x)./trans.k,nodenum,nodenum);
%% �γɽڵ㵼�ɾ���
y=y1+y2+y3;
%% ���ݴ���
y_abs=abs(y);                                              %�ڵ㵼�ɵķ�ֵ
y1angle=angle(y);                                          %�ڵ㵼�ɵ����
pis=sparse(pow.i,1,(pow.pgi-pow.pdi)./100,nodenum,1);      %�ڵ�ע���й�����
qis=sparse(pow.i,1,(pow.qgj-pow.qdj)./100,nodenum,1);      %�ڵ�ע���޹�����
v0=sparse(ones(1,nodenum)');                               %�ڵ��ѹ��С��ʼ��
va=sparse(zeros(nodenum,1));                               %��ǳ�ʼ��
v0(system(2))=system(3);                                   %ƽ��ڵ��ѹ
v0(pv.i)=pv.v;                                             %pv�ڵ��ѹ
[yi,yj]=find(y_abs);                                       %���ҷ����зֱ�洢��yi��yj��
end

