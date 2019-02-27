function [handle]=s2v(D,threshold)
handle=figure;
D=squeeze(D);                        %��ȥsizeΪ1��ά��
[x,y,z,D]=reducevolume(D,[2 2 1]);   %���ټ������Ԫ�ظ���������ÿ��������ÿ2th 2th 1th��Ԫ�أ�����������
D=smooth3(D);
fv=isosurface(x,y,z,D,threshold);  %��ȡ��ֵ��
p1=patch(fv,'facecolor',[1,.75,.65],'EdgeColor','none');%��ʾ
smooth(p1);                              %ƽ��

p2=patch(isocaps(x,y,z,D,0.1),'facecolor','none','edgecolor','none');
view(3);                   %�����ӵ�
axis tight;                %��������ϵ������tight��ʾʹ���귶Χ��Ӧ���ݷ�Χ
daspect([1,1,2]);          %�������������x:y:z=1:1:2
colormap(JET)        %���õ�ǰɫͼ  100+����ɫ�����ԻҶ�ɫͼ
camlight;                  %���������Դ������Ϊ��Դ���������ķ�λ
lighting gouraud           %�������ã��ȶԶ�����ɫ�岹���ٶԶ��㹴������ɫ���в岹�������������
isonormals(x,y,z,D,p1)     %�����ֵ���涥��ķ���
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