function[region]=regiongrow1(image,threshold,x,y)
    %[x,y]=getpts;                %�������������ʼ��
    x1=round(x);                 %������ȡ��
    y1=round(y);                 %������ȡ��
    image=double(image);
    [M,N]=size(image);           %��ȡͼ���С
    max1=max(max(image));
    min1=min(max(image));
    threshold=threshold*(max1-min1); %�ٷ�����õ���ֵ
    suit=numel(x1);                         %��������������������ĵ�ĸ���
    region=zeros(M,N);            %��һ��ȫ����ԭͼ��ȴ��ͼ�����Y����Ϊ���ͼ�����
    greyvalue1=ones(numel(x1),1);
    i=1;
    while i-1<numel(x1)
        greyvalue1(i)=image(x1(i),y1(i));
        region(x1(i),y1(i))=image(x1(i),y1(i));
        i=i+1;
    end
    %region(x1,y1,z1)=1;            %�����ӵ�ĻҶ�ֵ��1,�����ڵõ���ֵͼ��
    stack=[x1,y1,greyvalue1];               %��������ʼ��Ҷ�ֵ����stack��
    while suit>0
        adaptM=stack(1,1);
        adaptN=stack(1,2);
        greyvalue=stack(1,3);                       %�����ж��Ƿ�������ƽ���Ҷ�ֵ
        ssum=image(adaptM,adaptN);           %��Ҷ�ֵ
        count=1;                                    %��¼ÿ���ж�һ����Χ�˵�����������µ����Ŀ
        filter=greyvalue*ones(3,3);               %ƽ���Ҷ�ֵ�˲���
        if adaptM+1<(M+1) && adaptM-1>0 && adaptN+1<(N+1) && adaptN-1>0 
            window=image(adaptM-1:adaptM+1,adaptN-1:adaptN+1); %ȡԭ����
            window((abs(window-filter)-threshold)>0)=0;     %֮�������ֵ���㣬���������ĵ㲻��
            m=window+region(adaptM-1:adaptM+1,adaptN-1:adaptN+1);
            window(window~=m)=0;                             %region��ȡ1��λ�����㣬��֤���ظ���⣬�õ���������
            [xip,yip,v]=find(window);                       %�����з��ϵ���������xip��yip��zip���Ҷ�ֵ����v
            %window(window>0)=1;               %�õ���ֵͼ
            xip=xip+adaptM-2;
            yip=yip+adaptN-2;
            region(adaptM-1:adaptM+1,adaptN-1:adaptN+1)=region(adaptM-1:adaptM+1,adaptN-1:adaptN+1)+window; %������region
            count=count+numel(yip);                    
            ssum=ssum+sum(v);
            greyvalue=ssum/count;
            gip=greyvalue*ones(numel(yip),1);
            stack_1=cat(2,xip,yip,gip);            %���˴ε�����������ѹ����ʱ��ջ
            %stack_1=[xip,yip];
            stack=cat(1,stack,stack_1);            %����ʱ��ջѹ��stack
            suit=suit+numel(yip);                %ջ��ָ��
        end
               
        stack=stack(2:1:suit,:);                 %ѹ��ջ��
        suit=suit-1;
    end