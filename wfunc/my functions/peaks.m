function [peaksX,peaksY,a]=peaks(I)
% a=1 求每一行每一列的波峰
% a=-1求每一行每一列的波谷


gausFilter = fspecial('gaussian',[10 10],1.6);
gaus = imfilter(I, gausFilter, 'replicate');


kernel1=[-a,0,a,0,0];
kernel2=[0,-a,a,0,0];
kernel3=[0,0,a,-a,0];
kernel4=[0,0,a,0,-a];

for y=1:M
temp1 = imfilter(gaus(y,:), kernel1, 'replicate');
temp2 = imfilter(gaus(y,:), kernel2, 'replicate');
temp3 = imfilter(gaus(y,:), kernel3, 'replicate');
temp4 = imfilter(gaus(y,:), kernel4, 'replicate');

peaks=and(temp1>=0,temp2>=0);
peaks = and(peaks,temp3>=0);
peaks = and(peaks,temp4>=0);

try
    peaksX(y,:) = find(peaks==1);
catch
    peaksX(y,:) = peaksX(y-1,:);
end
end

for x=1:N
    g1=gaus';
temp1 = imfilter(g1(x,:), kernel1, 'replicate');
temp2 = imfilter(g1(x,:), kernel2, 'replicate');
temp3 = imfilter(g1(x,:), kernel3, 'replicate');
temp4 = imfilter(g1(x,:), kernel4, 'replicate');

peaks=and(temp1>=0,temp2>=0);
peaks = and(peaks,temp3>=0);
peaks = and(peaks,temp4>=0);

try
    peaksY(:,x) = find(peaks==1)';
catch
    peaksY(:,x) = peaksY(:,x-1);
end
end

% for i=1:length(peaksX(3,:))
% plot(peaksX(:,i),Ax,'r');hold on;
% end
% for i=1:length(peaksY(:,3))
% plot(Ax,peaksY(i,:),'r');hold on;
% end





