function ima=getDcm()
[filename, pathname] = uigetfile({'*.dcm' });
 ima = dicomread([ pathname,filename]);