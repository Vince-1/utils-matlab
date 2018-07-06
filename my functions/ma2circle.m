%this function is used for contour matrix to X,Y vectors.which can be draw into lines 
function [newX,newY]=ma2circle(slice)
[x,y]=find(slice==1);
d=zeros(length(x),length(x));
for i=1:length(x)
    x0=x(i);
    y0=y(i);
    d(i,:)=(x-x0).*(x-x0)+(y-y0).*(y-y0);
end
d1=d(1,:);
[minv,dmin]=min(d1);
d(:,dmin)=999;
d(:,1)=999;
newX=[x(1),x(dmin)];
newY=[y(1),y(dmin)];
for i=3:length(x)
    di=d(dmin,:);
    [minv,dmin]=min(di);
    d(:,dmin)=999;
    newX=[newX,x(dmin)];
    newY=[newY,y(dmin)];
end
newX=[newX,x(1)];
newY=[newY,y(1)];

