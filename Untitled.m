[fileName,pathName] = uigetfile({'*.dat';'*.txt'},'��ѡ��һ�������ļ�');
if  pathName == 0
    error('��ѡ����ʵ��ļ�');
else
%     path=strcat(pathName,fileName);
    c=dlmread(fileName);
end
v02=c(:,2);
va2=c(:,3);
sum(va2-va)
sum(v02-v0)
plot(v02-v0,'bo-');
% hold on;
% plot(v02,'ro-');
% legend('data1','data2')