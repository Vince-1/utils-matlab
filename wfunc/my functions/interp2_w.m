function new_image=interp2_w(size_org,size_new,image_org)
%%¶þÎ¬¾ØÕó²åÖµº¯Êý
% size_org=3;
% size_new=5;
% image_org=ones(3,3);
x1=zeros(size_new,size_new);
y1=zeros(size_new,size_new);
for i=1:size_new
    x1(i,:)=i*(size_org-1)/size_new+1;
    y1(:,i)=i*(size_org-1)/size_new+1;
end
x=[1:size_org];
y=[1:size_org];
image_org=double(image_org);
new_image=interp2(x,y,image_org,y1,x1);



