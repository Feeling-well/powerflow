[fileName,pathName] = uigetfile({'*.dat';'*.txt'},'请选择一个数据文件');
if  pathName == 0
    error('请选择合适的文件');
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