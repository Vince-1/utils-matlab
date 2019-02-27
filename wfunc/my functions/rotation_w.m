function [new_image,new_data1]=rotation_w(org_image,data1)
% org_image=f;
% data1=seg1;
[m n q]=size(data1);
data1(data1>0)=1;
    x=[];
    y=[];
    z=[];
    for ind=1:q
       [x2,y2]=find(data1(:,:,ind)==1);
       z2=repmat(ind,length(x2),1); 
       x=[x;x2];
       y=[y;y2];
       z=[z;z2];          %x y z 中存储了所有为1点的坐标....%每一页的点数量不一样不能串联呐。。。只是一维的
    end
    mid=0;

for ind=1:length(z)      %所有为1点的数量     需要更改计算方式
    for ind_1=1:length(z)    
       dis=(x(ind)-x(ind_1)).^2+ (y(ind)-y(ind_1)).^2+(z(ind)-z(ind_1)).^2;   %排除重复点 %避免出错？
       if dis>mid
          mid=dis;
          X_f(1)=x(ind);
          X_f(2)=x(ind_1);
          Y_f(1)=y(ind);
          Y_f(2)=y(ind_1);
          Z_f(1)=z(ind);
          Z_f(2)=z(ind_1);      %存储的是last-1的坐标
       end
    end
end
    cos_sigma=(Z_f(2)-Z_f(1))/sqrt((X_f(2)-X_f(1))^2+(Y_f(2)-Y_f(1))^2+(Z_f(2)-Z_f(1))^2)  
    x_new=[1:m];
    y_new=[1:n];
    z_new=[1:q];
    
    
    ro_x_new=x_new.*cos_sigma; 
    ro_y_new=y_new.*cos_sigma; 
    ro_z_new=z_new.*cos_sigma;  
    
    
    flo_ro_x_new=floor(ro_x_new)+1;
    cel_ro_x_new=floor(ro_x_new)+2;
    
    flo_ro_y_new=floor(ro_y_new)+1;
    cel_ro_y_new=floor(ro_y_new)+2;
    
    flo_ro_z_new=floor(ro_z_new)+1;
    cel_ro_z_new=floor(ro_z_new)+2;
    
    wet_x_1=ceil(ro_x_new)-ro_x_new;
    wet_x_2=ro_x_new-floor(ro_x_new);
    
    wet_y_1=ceil(ro_y_new)-ro_y_new;
    wet_y_2=ro_y_new-floor(ro_y_new);
    
    wet_z_1=ceil(ro_z_new)-ro_z_new;
    wet_z_2=ro_z_new-floor(ro_z_new);
    
    
    new_image=zeros(m,n,q);
    
    
    
    f2=data1;
    
    f3=zeros(m+2,n+2,q+2);
    f4=f3;
    f3(2:(m+1),2:(n+1),2:(q+1))=org_image;
    f4(2:(m+1),2:(n+1),2:(q+1))=data1;
    
   wet=zeros(m,n,q,8);
   
   for ind=1:q
   wet(:,:,ind,1)=wet_x_1'*wet_y_1*wet_z_1(ind);   
   wet(:,:,ind,2)=wet_x_2'*wet_y_2*wet_z_2(ind);    
   wet(:,:,ind,3)=wet_x_2'*wet_y_1*wet_z_1(ind); 
   wet(:,:,ind,4)=wet_x_1'*wet_y_2*wet_z_1(ind); 
   wet(:,:,ind,5)=wet_x_1'*wet_y_1*wet_z_2(ind); 
   wet(:,:,ind,6)=wet_x_2'*wet_y_2*wet_z_1(ind); 
   wet(:,:,ind,7)=wet_x_2'*wet_y_1*wet_z_2(ind); 
   wet(:,:,ind,8)=wet_x_1'*wet_y_2*wet_z_2(ind); 
   end
    
    
    

    
  %  for indd=1:47
    %插值计算新矩阵
    new_image(x_new,y_new,z_new)=  f3(flo_ro_x_new,flo_ro_y_new,flo_ro_z_new).*wet(x_new,y_new,z_new,1)+ f3(cel_ro_x_new,cel_ro_y_new,cel_ro_z_new).*wet(x_new,y_new,z_new,2) ...    
        + f3(cel_ro_x_new,flo_ro_y_new,flo_ro_z_new).*wet(x_new,y_new,z_new,3)+ f3(flo_ro_x_new,cel_ro_y_new,flo_ro_z_new).*wet(x_new,y_new,z_new,4)+ f3(flo_ro_x_new,flo_ro_y_new,cel_ro_z_new).*wet(x_new,y_new,z_new,5) ...
        + f3(cel_ro_x_new,cel_ro_y_new,flo_ro_z_new).*wet(x_new,y_new,z_new,6)+ f3(cel_ro_x_new,flo_ro_y_new,cel_ro_z_new).*wet(x_new,y_new,z_new,7)+ f3(flo_ro_x_new,cel_ro_y_new,cel_ro_z_new).*wet(x_new,y_new,z_new,8);
    new_data1(x_new,y_new,z_new)=  f4(flo_ro_x_new,flo_ro_y_new,flo_ro_z_new).*wet(x_new,y_new,z_new,1)+ f4(cel_ro_x_new,cel_ro_y_new,cel_ro_z_new).*wet(x_new,y_new,z_new,2) ...    
        + f4(cel_ro_x_new,flo_ro_y_new,flo_ro_z_new).*wet(x_new,y_new,z_new,3)+ f4(flo_ro_x_new,cel_ro_y_new,flo_ro_z_new).*wet(x_new,y_new,z_new,4)+ f4(flo_ro_x_new,flo_ro_y_new,cel_ro_z_new).*wet(x_new,y_new,z_new,5) ...
        + f4(cel_ro_x_new,cel_ro_y_new,flo_ro_z_new).*wet(x_new,y_new,z_new,6)+ f4(cel_ro_x_new,flo_ro_y_new,cel_ro_z_new).*wet(x_new,y_new,z_new,7)+ f4(flo_ro_x_new,cel_ro_y_new,cel_ro_z_new).*wet(x_new,y_new,z_new,8);
    new_data1(new_data1>0.3)=1;
    new_data1(new_data1<=0.3)=0;