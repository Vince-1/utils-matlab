function ima=getImage()
[filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
           '*.*','All Files' });
 ima = imread([ pathname,filename]);
 ima=rgb2gray(ima);