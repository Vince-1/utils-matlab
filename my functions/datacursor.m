%%%%%%%%%%%%%%%%%
%%三维视图坐标取点
%%fig_handle为视图句柄
%%按住alt+左键可取多个点
%在按enter之后才会取数据
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

