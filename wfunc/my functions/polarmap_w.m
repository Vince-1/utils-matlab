function polar_map=polarmap_w(f,g)    
non_zero_num=47;
org_image=f;
PET_org_image=g;

% for ind=1:47     %去除全黑页
%     slice_image=im2bw(f(:,:,ind),0.01);
%     if (sum(slice_image(:)~=0))
%        non_zero_num=non_zero_num+1; 
%        org_image(:,:,non_zero_num)=f(:,:,ind)';
%        PET_org_image(:,:,non_zero_num)=g(:,:,ind)';
%     end        
% end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%create polar map%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    polar_map=zeros(128,128);
    polar_x_initial=[1:128]'-64.5;
    polar_y_initial=[1:128]-64.5;
    polar_x=repmat(polar_x_initial,1,128);  %128*128
    polar_y=repmat(polar_y_initial,128,1);
    [polar_theta,polar_r]=cart2pol(polar_x,polar_y);   %转换极坐标
    polar_theta_degree=polar_theta*180/pi;     %弧度
    polar_theta_degree(find( polar_theta_degree<0))= polar_theta_degree(find( polar_theta_degree<0))+360; %0-2PI
    polar_r_max=64.5;
    
    
  for delta_r=1:non_zero_num
      image=org_image(:,:,non_zero_num-delta_r+1);
      PET_image=PET_org_image(:,:,non_zero_num-delta_r+1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   slice_image=im2bw(image,0.01);
   [x,y]=find(slice_image==1);
   xdata=x-64.5;
   ydata=y-64.5;

    k0 = ones(1,3);  %% k 的运行初值，不会影响最终结果
    
    F = @(k,xdata) xdata.^2 + ydata.^2 + k(1)*xdata + k(2)*ydata +k(3);   %椭圆拟合
    [k,resnorm]=lsqcurvefit(F,k0,xdata,ydata);                        %曲线拟合 ydata存于F（k,xdata）%@为高级句柄 F为表达式
% step2：圆参数求解
    r=1/2*sqrt(k(1)^2+k(2)^2-4*k(3));
    A=-k(1)/2+64.5;
    B=-k(2)/2+64.5;
    org_x_initial=[1:128]'-A;
    org_y_initial=[1:128]-B;
    org_x=repmat(org_x_initial,1,128);
    org_y=repmat(org_y_initial,128,1);
    [org_theta,org_r]=cart2pol(org_x,org_y);
    org_theta_degree=org_theta*180/pi;
    org_theta_degree(find(org_theta_degree<0))=org_theta_degree(find(org_theta_degree<0))+360;
    
%       seta=0:0.001:2*pi; 
%     xx=r*cos(seta)+B; 
%     yy=r*sin(seta)+A;
%     figure,imshow(slice_image)
%     hold on
%     plot(xx,yy,'r')
%     plot(B,A)
    
 
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
for ind_polar_theta=1:360/DETLA_THETA      %每一份9度，共40份
    max_value=0;
    for ind_x=1:128
        for ind_y=1:128
    if (org_theta_degree(ind_x,ind_y)<ind_polar_theta*DETLA_THETA)&(org_theta_degree(ind_x,ind_y)>=(ind_polar_theta-1)*DETLA_THETA);
        if(PET_image(ind_x,ind_y)>max_value)
            max_value=PET_image(ind_x,ind_y);
        end
        
    end
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    for ind_x=1:128
        for ind_y=1:128
        if (polar_theta_degree(ind_x,ind_y)<ind_polar_theta*DETLA_THETA)&(polar_theta_degree(ind_x,ind_y)>=(ind_polar_theta-1)*DETLA_THETA)&(polar_r(ind_x,ind_y)<delta_r*polar_r_max/non_zero_num)&(polar_r(ind_x,ind_y)>=(delta_r-1)*polar_r_max/non_zero_num)
            polar_map(ind_x,ind_y)=max_value;           
        end
            
        end
    end

end
polar_map_1(:,:,delta_r)=polar_map';

end
    
    
