function varargout = seg_w(varargin)
% SEG_W MATLAB code for seg_w.fig
%      SEG_W, by itself, creates a new SEG_W or raises the existing
%      singleton*.
%
%      H = SEG_W returns the handle to a new SEG_W or the handle to
%      the existing singleton*.
%
%      SEG_W('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEG_W.M with the given input arguments.
%
%      SEG_W('Property','Value',...) creates a new SEG_W or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before seg_w_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to seg_w_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help seg_w

% Last Modified by GUIDE v2.5 19-Jul-2017 11:14:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @seg_w_OpeningFcn, ...
                   'gui_OutputFcn',  @seg_w_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lung_sm contour  u zt 
save lung_seg lung_sm contour Y u zt b

% --- Executes just before seg_w is made visible.
function seg_w_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to seg_w (see VARARGIN)

% Choose default command line output for seg_w
handles.output = hObject;
handles.output = hObject;
global lung_sm contour pcon zt Y b u
contour=[];pcon=0;b=[];
load lung
set(handles.edit3,'String','0.30');
View4D(lung_sm)
Max=length(zt)/100;
set(handles.slider1,'Max',Max);
ss=double(lung_sm(:,:,1));
maxv=double(max(max(ss)));
ss=maxv-ss;
imshow(ss,[]);
b=zeros(168,168,length(zt));
if  pcon==4
    try
    s=contour(:,:,1);
    [x,y]=ma2circle(s);
    line(y,x,'linestyle','.','linewidth',0.1);
    hold off;
    catch
    end
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes seg_w wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = seg_w_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
slice=ceil(double(get(handles.slider1,'Value'))*100);
set(handles.text1,'String',num2str(slice));
global lung_sm contour pcon zt 
s=double(lung_sm(:,:,slice));
maxv=double(max(max(s)));
s=maxv-s;
imshow(s,[]);

if pcon==4
try
 c=contour(:,:,slice);
[newX,newY]=ma2circle(c);
line(newY,newX,'linestyle','-');
catch
end
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lung_sm maxa contour u b zt
slice=ceil(double(get(handles.slider1,'Value'))*100);
u=str2double(get(handles.edit3,'String'));
[x,y]=getpts;
[lx,ly]=poly_w(y,x);
th=0.10;
a=double(lung_sm(:,:,slice));
b(:,:,slice)=0;
contour(:,:,slice)=0;
for i=1:length(lx)
    b(lx(i),ly(i),slice)=1;
end
m=b(:,:,slice);
b(:,:,slice)=imfill(m,'holes');
m=b(:,:,slice);
a=a.*m;
a(a>u*maxa)=1;
a(a~=1)=0;
a=edge(a,'canny');
contour(:,:,slice)=a;



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pcon
if strcmp(get(handles.pushbutton3,'String'),'plot contour')
    pcon=4;
    set(handles.pushbutton3,'String','back');
else
    set(handles.pushbutton3,'String','plot contour');
    pcon=3;
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lung_sm zt contour maxa Y b u
[x,y]=getpts;
[lx,ly]=poly_w(y,x);
th=0.10;
u=str2double(get(handles.edit3,'String'));
a=double(lung_sm);
% assignin('base','lx',lx);
% assignin('base','ly',ly);
s1=get(handles.edit1,'String');
s2=get(handles.edit2,'String');
b=zeros(512,512,50);
for i=1:length(lx)
    b(lx(i),ly(i),[str2double(s1{1}):str2double(s2{1})])=1;
end
for i=1:length(zt)
    b(:,:,i)=imfill(b(:,:,i),'holes');
end
 a=a.*b;
 assignin('base','a',a);
assignin('base','b',b);
% [maxa,index]=max(max(max(a)));
% assignin('base','maxa',maxa);
% a(a>u*maxa)=1;
% a(a~=1)=0;
% single=a(:,:,1);
% contour=edge(single,'canny');
% for i=2:length(zt)
%     s=a(:,:,i);
%     s=imfill(s,'holes');
%     s=edge(s,'canny');
%     contour=cat(3,contour,s);
% end
% assignin('base','contour',contour);
View4D(a)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lung_sm contour Y u zt b
u=str2double(get(handles.edit3,'String'));
a=lung_sm;
a=a.*b;
[maxa,index]=max(max(max(a)));
a(a>u*maxa)=1;
a(a~=1)=0;
single=a(:,:,1);
contour=edge(single,'canny');
for i=2:length(zt)
    s=a(:,:,i);
    s=imfill(s,'holes');
    s=edge(s,'canny');
    contour=cat(3,contour,s);
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global lung_sm maxa contour u b zt
slice=ceil(double(get(handles.slider1,'Value'))*100);
u=str2double(get(handles.edit3,'String'));
a=double(lung_sm(:,:,slice));
m=b(:,:,slice);
a=a.*m;
a(a>u*maxa)=1;
a(a~=1)=0;
a=edge(a,'canny');
figure,imshow(a,[])
contour(:,:,slice)=a;