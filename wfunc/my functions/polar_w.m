function [polar_map,p17_map]=polar_w(input_image)
mask=input_image;
mask(mask>0)=1;
[sizex0 sizey0 sizez0]=size(input_image);
non_zero_num=0;
DETLA_THETA=9;   
 
for ind=1:sizez0    %去除全黑页
%     slice_image=im2bw(image(:,:,ind),0.01);
%     if (sum(slice_image(:)~=0))
       non_zero_num=non_zero_num+1; 
       org_image(:,:,non_zero_num)=mask(:,:,ind)';
       PET_org_image(:,:,non_zero_num)=input_image(:,:,ind)';
%     end        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%create polar map%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
polar_map=zeros(sizex0,sizey0);
polar_map_g=polar_map;
polar_x_initial=[1:sizex0]'-sizex0/2-0.5;
polar_y_initial=[1:sizey0]-sizey0/2-0.5;
polar_x=repmat(polar_x_initial,1,sizex0);  %sizex*sizex
polar_y=repmat(polar_y_initial,sizey0,1);
[polar_theta,polar_r]=cart2pol(polar_x,polar_y);   %转换极坐标
polar_theta_degree=polar_theta*180/pi;     %弧度
polar_theta_degree(find( polar_theta_degree<0))= polar_theta_degree(find( polar_theta_degree<0))+360; %0-2PI
polar_r_max=sizex0/2+0.5;
    
    
%%
 for delta_r=1:non_zero_num
      image=org_image(:,:,non_zero_num-delta_r+1);
      PET_image=PET_org_image(:,:,non_zero_num-delta_r+1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    slice_image=im2bw(image,0.01);
   [x,y]=find(image>0);
   xdata=x-sizex0/2-0.5;
   ydata=y-sizey0/2-0.5;

    k0 = ones(1,3);  %% k 的运行初值，不会影响最终结果
    
    F = @(k,xdata) xdata.^2 + ydata.^2 + k(1)*xdata + k(2)*ydata +k(3);   %椭圆拟合
    [k,resnorm]=lsqcurvefit(F,k0,xdata,ydata);                        %曲线拟合 ydata存于F（k,xdata）%@为高级句柄 F为表达式
% step2：圆参数求解
    r=1/2*sqrt(k(1)^2+k(2)^2-4*k(3));
    A=-k(1)/2+sizex0/2+0.5;
    B=-k(2)/2+sizey0/2+0.5;
    org_x_initial=[1:sizex0]'-A;
    org_y_initial=[1:sizey0]-B;
    org_x=repmat(org_x_initial,1,sizex0);
    org_y=repmat(org_y_initial,sizex0,1);
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
%     sum_value=0;
    sum_point=0;
    for ind_x=1:sizex0
        for ind_y=1:sizex0
            if (org_theta_degree(ind_x,ind_y)<ind_polar_theta*DETLA_THETA)&(org_theta_degree(ind_x,ind_y)>=(ind_polar_theta-1)*DETLA_THETA);
%                 sum_point=sum_point+1;
%                 sum_value=sum_value+PET_image(ind_x,ind_y);
                if(PET_image(ind_x,ind_y)>max_value)
                    max_value=PET_image(ind_x,ind_y);
                end
        
            end
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    for ind_x=1:sizex0
        for ind_y=1:sizex0
        if (polar_theta_degree(ind_x,ind_y)<ind_polar_theta*DETLA_THETA)&(polar_theta_degree(ind_x,ind_y)>=(ind_polar_theta-1)*DETLA_THETA)&(polar_r(ind_x,ind_y)<delta_r*polar_r_max/non_zero_num)&(polar_r(ind_x,ind_y)>=(delta_r-1)*polar_r_max/non_zero_num)
            polar_map(ind_x,ind_y)=max_value;    
%             polar_map_g(ind_x,ind_y)=sum_value;
        end
            
        end
    end
end
polar_map_1(:,:,delta_r)=polar_map';
end
figure,imagesc(polar_map);
% figure,imagesc(polar_map_g);
%%


saveas(gcf,'rot-pmap-interp.jpg')
p17_map=polar_map;
pn_map=zeros(sizex0,sizex0);
max_value=0;
%%%%%%%%%
for ind_x=1:sizex0         %第一层
    for ind_y=1:sizex0
        if (polar_r(ind_x,ind_y)<16)
            if polar_map(ind_x,ind_y)>max_value
                max_value=polar_map(ind_x,ind_y);
                
            end
        end
    end
end
for ind_x=1:sizex0
    for ind_y=1:sizex0
        if (polar_r(ind_x,ind_y)<16)
              p17_map(ind_x,ind_y)=max_value;
              pn_map(ind_x,ind_y)=17;
        end
    end
end
%%%%%%%%%%

for ind_polar_theta=1:4   %%%%%第二层
    max_value=0;
    for ind_x=1:sizex0
        for ind_y=1:sizex0
%             if((polar_r(ind_x,ind_y)<32)&(polar_r(ind_x,ind_y)>=15)&(polar_theta_degree(ind_x,ind_y)>=((ind_polar_theta-1)*90-45))&(polar_theta_degree(ind_x,ind_y)<((ind_polar_theta-1)*90+45)))
            if (((polar_r(ind_x,ind_y)<32)&(polar_r(ind_x,ind_y)>=15)&...
                    (((polar_theta_degree(ind_x,ind_y)>=((ind_polar_theta-1)*90+45))&...
                    (polar_theta_degree(ind_x,ind_y)<((ind_polar_theta-1)*90+135)))|...
                    (((polar_theta_degree(ind_x,ind_y)>=315)|(polar_theta_degree(ind_x,ind_y)<45))))))
                if polar_map(ind_x,ind_y)>max_value
                    max_value=polar_map(ind_x,ind_y);
                    
                end
            end
        end
    end
    
    for ind_x=1:sizex0
        for ind_y=1:sizex0
%             if((polar_r(ind_x,ind_y)<32)&(polar_r(ind_x,ind_y)>=15)&(polar_theta_degree(ind_x,ind_y)>=((ind_polar_theta-1)*90-45))&(polar_theta_degree(ind_x,ind_y)<((ind_polar_theta-1)*90+45)))
              if (((polar_r(ind_x,ind_y)<32)&(polar_r(ind_x,ind_y)>=15)&...
                    (((polar_theta_degree(ind_x,ind_y)>=((ind_polar_theta-1)*90+45))&...
                    (polar_theta_degree(ind_x,ind_y)<((ind_polar_theta-1)*90+135)))|...
                    (((polar_theta_degree(ind_x,ind_y)>=315)|(polar_theta_degree(ind_x,ind_y)<45))))))
                p17_map(ind_x,ind_y)=max_value;
                pn_map(ind_x,ind_y)=17-ind_polar_theta;
            end
        end
    end
end
%%%%%%

for ind_polar_theta=1:6   %%%%%第三、四层
    for ind_r=3:4
    max_value=0;
    for ind_x=1:sizex0
        for  ind_y=1:sizex0
            if (((polar_r(ind_x,ind_y)<ind_r*16)&(polar_r(ind_x,ind_y)>=((ind_r-1)*16-1))&...
                    (((polar_theta_degree(ind_x,ind_y)>=((ind_polar_theta-1)*60+30))&...
                    (polar_theta_degree(ind_x,ind_y)<((ind_polar_theta-1)*60+90)))|...
                    (((polar_theta_degree(ind_x,ind_y)>=330)|(polar_theta_degree(ind_x,ind_y)<30))))))
                if polar_map(ind_x,ind_y)>max_value
                    max_value=polar_map(ind_x,ind_y);
                    
                end
            end
        end
    end
    for ind_x=1:sizex0
        for  ind_y=1:sizex0
            if (((polar_r(ind_x,ind_y)<ind_r*16)&(polar_r(ind_x,ind_y)>=((ind_r-1)*16-1))&...
                    (((polar_theta_degree(ind_x,ind_y)>=((ind_polar_theta-1)*60+30))&...
                    (polar_theta_degree(ind_x,ind_y)<((ind_polar_theta-1)*60+90)))|...
                    (((polar_theta_degree(ind_x,ind_y)>=330)|(polar_theta_degree(ind_x,ind_y)<30))))))
                p17_map(ind_x,ind_y)=max_value;
                pn_map(ind_x,ind_y)=13-(ind_r-3)*6-ind_polar_theta;
            end
        end
    end
    end
end
figure,imagesc(p17_map);
saveas(gcf,'rot-p17-interp.jpg')