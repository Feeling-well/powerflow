%% ����˵��
%���ܣ�������
%���ߣ�������
%��д��2017.12.3
%% ����˵��
% va����ѹ���               v0����ѹ��ֵ           iteration���������� 
% deltPandQ�����ƽ����    nodenum���ڵ���Ŀ      time������ʱ��          
function [va,v0] = print(va,v0,iteration,deltPandQ,system,nodenum,time)
%% ͼ�����
va(system(2),1)=0;
figure('NumberTitle', 'off', 'Name', 'IEEE');   %ͼ��˵��
subplot(3,1,1);                                 %ͼ��λ��
 plot(1:iteration-1,deltPandQ,'b');
 hold on 
 scatter(1:iteration-1,deltPandQ,'b');
 xlabel('��������');
ylabel('���ƽ����');
title('������');
 subplot(3,1,2);                                %ͼ��λ��
 scatter(1:nodenum,v0,20,'g');
xlabel('�ڵ��');
ylabel('��ѹ(pu)');
title('�ڵ��ѹ�ֲ�');           
 subplot(3,1,3);                                %ͼ��λ��
 scatter(1:nodenum,full(va),20,'r');
xlabel('�ڵ��');
ylabel('���(����)');
title('�ڵ���Ƿֲ�');
va=va.*180./pi;                                 %ת���ɽǶ�
%% ��������
disp('�ڵ��ѹ��ֵ��');
disp(v0)
disp('�ڵ��ѹ��ǣ�');
disp(va)
disp(['�������� ',num2str(iteration)])
disp(['����ʱ�� ',num2str(time)])
end