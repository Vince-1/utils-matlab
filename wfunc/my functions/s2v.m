function [handle]=s2v(D,threshold)
handle=figure;
D=squeeze(D);                        %除去size为1的维数
[x,y,z,D]=reducevolume(D,[2 2 1]);   %减少集合里的元素个数，保留每个方向上每2th 2th 1th个元素，即坐标轴上
D=smooth3(D);
fv=isosurface(x,y,z,D,threshold);  %提取等值面
p1=patch(fv,'facecolor',[1,.75,.65],'EdgeColor','none');%显示
smooth(p1);                              %平滑

p2=patch(isocaps(x,y,z,D,0.1),'facecolor','none','edgecolor','none');
view(3);                   %设置视点
axis tight;                %设置坐标系函数，tight表示使坐标范围适应数据范围
daspect([1,1,2]);          %设置坐标比例，x:y:z=1:1:2
colormap(JET)        %设置当前色图  100+种颜色？线性灰度色图
camlight;                  %创建相机光源，参数为光源相对于相机的方位
lighting gouraud           %照明设置，先对顶点颜色插补，再对顶点勾划的面色进行插补，用于曲面表现
isonormals(x,y,z,D,p1)     %计算等值表面顶点的法向
% %hidden off;

% [x y z D] = reducevolume(D, [4 4 1]);
%  Ds = smooth3(D);
% %    
%  hiso = patch(isosurface(Ds,5),'FaceColor',[1,.75,.65], 'EdgeColor','none');
%  hcap = patch(isocaps(Ds,5),'FaceColor','interp','EdgeColor','none');
%  colormap copper
%  view(45,30) 
%  axis tight 
%  daspect([1,1,.8])
%  lightangle(45,30); 
%  set(gcf,'Renderer','zbuffer'); lighting phong
%  isonormals(Ds,hiso)
%  set(hcap,'AmbientStrength',.6)
%  set(hiso,'SpecularColorReflectance',0,'SpecularExponent',50)