%%%%%%%%%%%%%%%%%
%%��ά��ͼ����ȡ��
%%fig_handleΪ��ͼ���
%%��סalt+�����ȡ�����
%�ڰ�enter֮��Ż�ȡ����
%%%%%%%%%%%%%%%%%
function [x1,y1,z1]=datacursor(fig_handle)
hCursor= datacursormode(fig_handle);
set(hCursor,'DisplayStyle','datatip',...
    'SnapToDataVertex','off','Enable','on');
disp('Click points to get the coordinates,then press Enter to ensure.')
pause
c_info = getCursorInfo(hCursor);
c_info_cell=struct2cell(c_info);
c_points=squeeze(c_info_cell(2,:,:));
c=cell2mat(c_points);
x1=round(c(:,1));
y1=round(c(:,2));
z1=round(c(:,3));

