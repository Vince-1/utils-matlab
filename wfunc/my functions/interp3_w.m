function new_image=interp3_w(size_new,image_org)
% size_new=[5 5 5];
% image_org=ones(3,3,3);
size_org=size(image_org);
x1=zeros(size_new(1),size_new(2),size_new(3));
y1=zeros(size_new(1),size_new(2),size_new(3));
z1=zeros(size_new(1),size_new(2),size_new(3));
for i=1:size_new(1)
    x1(i,:,:)=i*(size_org(1)-1)/size_new(1)+1;
end
for i=1:size_new(2)
    y1(:,i,:)=i*(size_org(2)-1)/size_new(2)+1;
end
for i=1:size_new(3)
    z1(:,:,i)=i*(size_org(3)-1)/size_new(3)+1;
end

x=[1:size_org(1)];
y=[1:size_org(2)];
z=[1:size_org(3)];
new_image=interp3(x,y,z,image_org,y1,x1,z1);