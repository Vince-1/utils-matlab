function [region,rect]=mycrop(image)
rect=getrect;  %rect=[xmin ymin width height]
w=round(rect(3));
rect(3)=w;
h=round(rect(4));
rect(4)=h;
if w>=1 && h>=1
    r=[rect(1),rect(1)+w,rect(1)+w,rect(1);rect(2),rect(2),rect(2)+h,rect(2)+h];
    rectangle('Position',[rect(1),rect(2),w,h],'edgecolor','green');
    bw=roipoly(image,r(1,:),r(2,:));
    image1=reshape(image,[(size(image,1)*size(image,2)),size(image,3)]);
    region1=image1(bw,:);
    region=reshape(region1,[h,w,size(image,3)]);
end