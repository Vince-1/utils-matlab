%%%%%%%%%%%%%%%%%%%
%三维区域生长（修改版，无for循环）
%[region]为输出矩阵（可二值图，也可直接输出）
%imgage为原矩阵，x1,y1,z1为生长点,threshold为阈值（可修改为百分数）
%%%%%%%%%%%%%%%%%%%
function[region]=regiongrow_1(image,threshold,x1,y1,z1)
    image=double(image);
    [M,N,P]=size(image);           %获取图像大小
    %max1=max(imhist(image));
    %min1=min(imhist(image));
    %threshold=threshold*(max1-min1); %百分数获得的阈值
    suit=numel(x1);                         %储存符合区域生长条件的点的个数
    region=zeros(M,N,P);            %作一个全零与原图像等大的图像矩阵Y，作为输出图像矩阵
    greyvalue1=ones(numel(x1),1);
    i=1;
    while i-1<numel(x1)
        greyvalue1(i)=image(x1(i),y1(i),z1(i));
        region(x1(i),y1(i),z1(i))=image(x1(i),y1(i),z1(i));
        i=i+1;
    end
    %region(x1,y1,z1)=1;            %将种子点的灰度值置1,可用于得到二值图像
    stack=[x1,y1,z1,greyvalue1];               %将生长起始点和灰度值存入stack中
    while suit>0
        adaptM=stack(1,1);
        adaptN=stack(1,2);
        adaptP=stack(1,3);
        greyvalue=stack(1,4);                       %用于判定是否生长的平均灰度值
        ssum=image(adaptM,adaptN,adaptP);           %存灰度值
        count=1;                                    %记录每次判断一点周围八点符合条件的新点的数目
        filter=greyvalue*ones(3,3,3);               %平均灰度值滤波器
        if (adaptM+1)<(M+1) && (adaptM-1)>0 && (adaptN+1)<(N+1) && (adaptN-1)>0 && (adaptP+1)<(P+1) && (adaptP-1)>0
            if ssum>0
            window=image(adaptM-1:adaptM+1,adaptN-1:adaptN+1,adaptP-1:adaptP+1); %取原矩阵
            window((abs(window-filter)-threshold)>0)=0;     %之差大于阈值置零，符合生长的点不变
            window(:,:,2);
            m=window+region(adaptM-1:adaptM+1,adaptN-1:adaptN+1,adaptP-1:adaptP+1);
            window(window~=m)=0;                             %region中取1的位置置零，保证不重复检测，得到生长区域
            [xip,yip,v]=find(window);                       %将所有符合点的坐标存入xip、yip、zip，灰度值存入v
            zip=ones(numel(yip),1);
             pt=1;
        while pt-1<numel(yip)
            switch(yip(pt))                                 %得到zip
                case{4,5,6}
                    yip(pt)=yip(pt)-3;
                    zip(pt)=2;
                case{7,8,9}
                    yip(pt)=yip(pt)-6;
                    zip(pt)=3;
            end
            pt=pt+1;       
            end
        xip=xip+adaptM-2;
        yip=yip+adaptN-2;
        zip=zip+adaptP-2;
        %window(window>0)=1;               %得到二值图
        region(adaptM-1:adaptM+1,adaptN-1:adaptN+1,adaptP-1:adaptP+1)=region(adaptM-1:adaptM+1,adaptN-1:adaptN+1,adaptP-1:adaptP+1)+window; %返还给region
        count=count+numel(yip);                    
        ssum=ssum+sum(v);
        greyvalue=ssum/count;
        gip=greyvalue*ones(numel(yip),1);   
        stack_1=cat(2,xip,yip,zip,gip);            %将此次的生长点坐标压入临时堆栈
        %stack_1=[xip,yip,zip];
        stack=cat(1,stack,stack_1);            %将临时堆栈压入stack
        suit=suit+numel(yip);                %栈底指针
            end
        end           
        stack=stack(2:1:suit,:);                 %压出栈顶
        suit=suit-1
    end
             
                
        