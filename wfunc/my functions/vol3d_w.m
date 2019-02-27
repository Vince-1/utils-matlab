function [model] = vol3d_w(cdata)
siz = size(cdata);
model.cdata=cdata;
model.xdata = [0 siz(2)];
model.ydata = [0 siz(1)];
model.zdata = [0 siz(3)];
opts = {'Parent',gca,'cdatamapping','scaled','alphadatamapping','scaled','facecolor','texturemap','edgealpha',0,'facealpha','texturemap','tag','3d_w'};
model.alpha = model.cdata;

handle_ind=1;
% Create z-slice
if(1)    
  x = [model.xdata(1), model.xdata(2); model.xdata(1), model.xdata(2)];
  y = [model.ydata(1), model.ydata(1); model.ydata(2), model.ydata(2)];
  z = [model.zdata(1), model.zdata(1); model.zdata(1), model.zdata(1)];
  diff = model.zdata(2)-model.zdata(1);
  delta = diff/size(model.cdata,3);
  for n = 1:size(model.cdata,3)

   cslice = squeeze(model.cdata(:,:,n,:));
   aslice = double(squeeze(model.alpha(:,:,n)));
   h(handle_ind) = surface(x,y,z,cslice,'alphadata',aslice,opts{:});
   z = z + delta;
   handle_ind = handle_ind + 1;
  end

end

% Create x-slice
if (1) 
  x = [model.xdata(1), model.xdata(1); model.xdata(1), model.xdata(1)];
  y = [model.ydata(1), model.ydata(1); model.ydata(2), model.ydata(2)];
  z = [model.zdata(1), model.zdata(2); model.zdata(1), model.zdata(2)];
  diff = model.xdata(2)-model.xdata(1);
  delta = diff/size(model.cdata,2);
  for n = 1:size(model.cdata,2)

   cslice = squeeze(model.cdata(:,n,:,:));
   aslice = double(squeeze(model.alpha(:,n,:)));
   h(handle_ind) = surface(x,y,z,cslice,'alphadata',aslice,opts{:});
   x = x + delta;
   handle_ind = handle_ind + 1;
  end
end

% Create y-slice
if (1)
  x = [model.xdata(1), model.xdata(1); model.xdata(2), model.xdata(2)];
  y = [model.ydata(1), model.ydata(1); model.ydata(1), model.ydata(1)];
  z = [model.zdata(1), model.zdata(2); model.zdata(1), model.zdata(2)];
  diff = model.ydata(2)-model.ydata(1);
  delta = diff/size(model.cdata,1);
  for n = 1:size(model.cdata,1)

   cslice = squeeze(model.cdata(n,:,:,:));
   aslice = double(squeeze(model.alpha(n,:,:)));
   h(handle_ind) = surface(x,y,z,cslice,'alphadata',aslice,opts{:});
   y = y + delta;
   handle_ind = handle_ind + 1;
  end
end
axis equal;
model.handles = h;
