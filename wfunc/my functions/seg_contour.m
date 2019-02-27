CT = dicomread('CT.DCM');


[a,b,c,d]=size(CT);

MIN=min(min(min(CT)));
CT=squeeze(CT);
CT=CT-MIN;
for i=1:73
    S1=CT(:,:,i);
    gausFilter=fspecial('gaussian',[10 10],1.6);
    S2 = imfilter(S1, gausFilter, 'replicate');
    CT(:,:,i)=S2;
end
A=double(CT);
aa=double(CT);
A(CT>700)=0;
B=zeros(512,512,73);
B(A==0)=1;

C=imfill(B,'holes');
dd=C.*aa;
D=C;
for i=1:73
    cc=dd(:,:,i);
    d=edge(cc,'canny');
    D(:,:,i)=d;
end
D=imfill(D,'holes');
% View4D(D)
for i=1:73
    cc=C(:,:,i);
    d=im2bw(cc,0.4);      
    D(:,:,i)=d;
end

dd=D.*aa;

% View4D(dd);

cc=dd;
cc(390:512,:,:)=0;
nn=cc;
aaa=cc;
aaa(cc>1000)=0;
View4D(aaa)