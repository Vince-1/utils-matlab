function[region]=regiongrow1(image,threshold,x,y)
    %[x,y]=getpts;                %获得区域生长起始点
    x1=round(x);                 %横坐标取整
    y1=round(y);                 %纵坐标取整
    image=double(image);
    [M,N]=size(image);           %获取图像大小
    max1=max(max(image));
    min1=min(max(image));
    threshold=threshold*(max1-min1); %百分数获得的阈值
    suit=numel(x1);                         %储存符合区域生长条件的点的个数
    region=zeros(M,N);            %作一个全零与原图像等大的图像矩阵Y，作为输出图像矩阵
    greyvalue1=ones(numel(x1),1);
    i=1;
    while i-1<numel(x1)
        greyvalue1(i)=image(x1(i),y1(i));
        region(x1(i),y1(i))=image(x1(i),y1(i));
        i=i+1;
    end
    %region(x1,y1,z1)=1;            %将种子点的灰度值置1,可用于得到二值图像
    stack=[x1,y1,greyvalue1];               %将生长起始点灰度值存入stack中
    while suit>0
        adaptM=stack(1,1);
        adaptN=stack(1,2);
        greyvalue=stack(1,3);                       %用于判定是否生长的平均灰度值
        ssum=image(adaptM,adaptN);           %存灰度值
        count=1;                                    %记录每次判断一点周围八点符合条件的新点的数目
        filter=greyvalue*ones(3,3);               %平均灰度值滤波器
        if adaptM+1<(M+1) && adaptM-1>0 && adaptN+1<(N+1) && adaptN-1>0 
            window=image(adaptM-1:adaptM+1,adaptN-1:adaptN+1); %取原矩阵
            window((abs(window-filter)-threshold)>0)=0;     %之差大于阈值置零，符合生长的点不变
            m=window+region(adaptM-1:adaptM+1,adaptN-1:adaptN+1);
            window(window~=m)=0;                             %region中取1的位置置零，保证不重复检测，得到生长区域
            [xip,yip,v]=find(window);                       %将所有符合点的坐标存入xip、yip、zip，灰度值存入v
            %window(window>0)=1;               %得到二值图
            xip=xip+adaptM-2;
            yip=yip+adaptN-2;
            region(adaptM-1:adaptM+1,adaptN-1:adaptN+1)=region(adaptM-1:adaptM+1,adaptN-1:adaptN+1)+window; %返还给region
            count=count+numel(yip);                    
            ssum=ssum+sum(v);
            greyvalue=ssum/count;
            gip=greyvalue*ones(numel(yip),1);
            stack_1=cat(2,xip,yip,gip);            %将此次的生长点坐标压入临时堆栈
            %stack_1=[xip,yip];
            stack=cat(1,stack,stack_1);            %将临时堆栈压入stack
            suit=suit+numel(yip);                %栈底指针
        end
               
        stack=stack(2:1:suit,:);                 %压出栈顶
        suit=suit-1;
    end