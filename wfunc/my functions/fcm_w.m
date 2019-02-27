function seg3=fcm_w(f)
% fid=fopen('F:\SJTU_project_paper\ruijin_data_3_21_2016\Cardiac_data\data_analysis\PET_step_2');
% fid=fopen('D:\Í¼Ïñ\MATLAB\finalwork\PET - ¸±±¾\data2');
% % f=fread(fid,'float');
% f=squeeze(dicomread('DOG_CARDIAC20180414.NM.I-131_MIBG.1000.0001.2018.04.14.15.33.04.718750.4814270.IMA'));
f=double(f);
[m,n,q]=size(f);
t=m*n*q;
f=reshape(f,[t,1]);
k=3;  %%fcm alogrithm classify the image data into 3 clusters
[row column]=size(f);
data=[zeros(1,row)' f];
[center1, U1] = fcm(data, k);
[maxU1,I1] = max(U1);
I=zeros(k,row);
% % % % % % % % % % % % % % 
for ind=k:-1:1
    I(ind,:)=I1-ind+1;
    index=find(I<0);
    I(index)=0;
    if ind==k
   S(ind,:)=I(ind,:);
    elseif ind==k-1
    S(ind,:)=I(ind,:)-2*I(ind+1,:); 
    else
    S(ind,:)=I(ind,:)-2*I(ind+1,:)+I(ind+2,:);    
    end
end
seg3=shiftdim(reshape(S,[k m n q]),1);
% for indk=1:k
% % figure,imshow(seg3(:,:,21,indk))
% % figure,imshow(seg3(:,:,22,indk))
% % figure,imshow(seg3(:,:,28,indk))
% % figure,imshow(seg3(:,:,29,indk))
% % figure,imshow(seg3(:,:,10,indk))
% figure,imshow(seg3(:,:,ceil(q/2),indk))
% end
%figure,imshow(re(:,:,8))