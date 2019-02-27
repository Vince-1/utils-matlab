clear all;
load aaa4_maltab
figure,imshow(aaa(:,:,49));
[x,y]=getpts;
[lx,ly]=poly_w(y,x);
% th=0.10;
a=double(aaa);
b=zeros(512,512,73);
b(:,:,1:48)=1;
for i=1:length(lx)
    b(lx(i),ly(i),[49:73])=1;
end
for i=49:73
    b(:,:,i)=imfill(b(:,:,i),'holes');
end
 a=a.*b;
 aaa=a;
 save aaa5_maltab aaa
 View4D(a)
 

% [maxa,index]=max(max(max(a)));
% a(a>u*maxa)=1;
% a(a~=1)=0;
% single=a(:,:,1);
% contour=edge(single,'canny');
% for i=2:length(zt)
%     s=a(:,:,i);
%     s=imfill(s,'holes');
%     s=edge(s,'canny');
%     contour=cat(3,contour,s);
% end
% View4D(contour)