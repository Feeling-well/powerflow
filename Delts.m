%% ���ܣ�������ƽ����
%���ߣ�������
%��д��2016.x.x
%�޸���2017.11.3���޸ĽǶ��󷨣��ٶ�����0.15s����
%% ����˵��
%deltp���й�������    deltq���޹�������
%delt��p,q����������
%va�����           v0����ѹ��ֵ
%system(2)��ƽ��ڵ��
function [delt,pv]=Delts(y,pis,qis,va,v0,pv,system)
va=sparse(va);
v=v0.*(cos(va)+1j*sin(va)); %�ڵ��ѹ������ʽ
delt0=conj(y*v);            %conj����  
delt1=v.*delt0;             %����ڵ��ѹ����Ĺ���
%���pv�ڵ��޹��Ƿ�Խ��
deltp=pis-real(delt1);       %�й�������
deltq=qis-imag(delt1);       %�޹�������
deltp(system(2))=0;          %�й�������(����ƽ��ڵ�)
deltq(system(2))=0;          %�޹�������������ƽ��ڵ㣩
deltq(pv.i)=0;               %�޹�������������pv�ڵ㣩
delt=[deltp;deltq];          %p,q����������
end