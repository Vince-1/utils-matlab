%%%%%%%%%%%%%%%%%%%
%��ά�����������޸İ棬��forѭ����
%[region]Ϊ������󣨿ɶ�ֵͼ��Ҳ��ֱ�������
%imgageΪԭ����x1,y1,z1Ϊ������,thresholdΪ��ֵ�����޸�Ϊ�ٷ�����
%%%%%%%%%%%%%%%%%%%
function[region]=regiongrow_1(image,threshold,x1,y1,z1)
    image=double(image);
    [M,N,P]=size(image);           %��ȡͼ���С
    %max1=max(imhist(image));
    %min1=min(imhist(image));
    %threshold=threshold*(max1-min1); %�ٷ�����õ���ֵ
    suit=numel(x1);                         %��������������������ĵ�ĸ���
    region=zeros(M,N,P);            %��һ��ȫ����ԭͼ��ȴ��ͼ�����Y����Ϊ���ͼ�����
    greyvalue1=ones(numel(x1),1);
    i=1;
    while i-1<numel(x1)
        greyvalue1(i)=image(x1(i),y1(i),z1(i));
        region(x1(i),y1(i),z1(i))=image(x1(i),y1(i),z1(i));
        i=i+1;
    end
    %region(x1,y1,z1)=1;            %�����ӵ�ĻҶ�ֵ��1,�����ڵõ���ֵͼ��
    stack=[x1,y1,z1,greyvalue1];               %��������ʼ��ͻҶ�ֵ����stack��
    while suit>0
        adaptM=stack(1,1);
        adaptN=stack(1,2);
        adaptP=stack(1,3);
        greyvalue=stack(1,4);                       %�����ж��Ƿ�������ƽ���Ҷ�ֵ
        ssum=image(adaptM,adaptN,adaptP);           %��Ҷ�ֵ
        count=1;                                    %��¼ÿ���ж�һ����Χ�˵�����������µ����Ŀ
        filter=greyvalue*ones(3,3,3);               %ƽ���Ҷ�ֵ�˲���
        if (adaptM+1)<(M+1) && (adaptM-1)>0 && (adaptN+1)<(N+1) && (adaptN-1)>0 && (adaptP+1)<(P+1) && (adaptP-1)>0
            if ssum>0
            window=image(adaptM-1:adaptM+1,adaptN-1:adaptN+1,adaptP-1:adaptP+1); %ȡԭ����
            window((abs(window-filter)-threshold)>0)=0;     %֮�������ֵ���㣬���������ĵ㲻��
            window(:,:,2);
            m=window+region(adaptM-1:adaptM+1,adaptN-1:adaptN+1,adaptP-1:adaptP+1);
            window(window~=m)=0;                             %region��ȡ1��λ�����㣬��֤���ظ���⣬�õ���������
            [xip,yip,v]=find(window);                       %�����з��ϵ���������xip��yip��zip���Ҷ�ֵ����v
            zip=ones(numel(yip),1);
             pt=1;
        while pt-1<numel(yip)
            switch(yip(pt))                                 %�õ�zip
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
        %window(window>0)=1;               %�õ���ֵͼ
        region(adaptM-1:adaptM+1,adaptN-1:adaptN+1,adaptP-1:adaptP+1)=region(adaptM-1:adaptM+1,adaptN-1:adaptN+1,adaptP-1:adaptP+1)+window; %������region
        count=count+numel(yip);                    
        ssum=ssum+sum(v);
        greyvalue=ssum/count;
        gip=greyvalue*ones(numel(yip),1);   
        stack_1=cat(2,xip,yip,zip,gip);            %���˴ε�����������ѹ����ʱ��ջ
        %stack_1=[xip,yip,zip];
        stack=cat(1,stack,stack_1);            %����ʱ��ջѹ��stack
        suit=suit+numel(yip);                %ջ��ָ��
            end
        end           
        stack=stack(2:1:suit,:);                 %ѹ��ջ��
        suit=suit-1
    end
             
                
        