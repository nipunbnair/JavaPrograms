
function varargout = (varargin)
% IMAGEMATCHING MATLAB code for ImageMatching.fig
%      IMAGEMATCHING, by itself, creates a new IMAGEMATCHING or raises the existing
%      singleton*.
%
%      H = IMAGEMATCHING returns the handle to a new IMAGEMATCHING or the handle to
%      the existing singleton*.
%
%      IMAGEMATCHING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEMATCHING.M with the given input arguments.
%
%      IMAGEMATCHING('Property','Value',...) creates a new IMAGEMATCHING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImageMatching_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImageMatching_OpeningFcn via varargin.
%   
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help ImageMatching
% Last Modified by GUIDE v2.5 22-Oct-2018 05:41:35
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageMatching_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageMatching_OutputFcn, ...
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
% --- Executes just before ImageMatching is made visible.
function ImageMatching_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageMatching (see VARARGIN)
% Choose default command line output for ImageMatching
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes ImageMatching wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = ImageMatching_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in upload1.
function upload1_Callback(~, ~, handles)
%Image Upload number 1
global img1
[filename, pathname] = uigetfile('*.*','D:\Users\Pictures');
img1 = imread([pathname, filename]);   
imshow(img1,'Parent',handles.axes1);
set(handles.clear, 'Enable', 'on')
set(handles.upload2, 'Enable', 'on')
% hObject    handle to upload1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in upload2.
function upload2_Callback(~, ~, handles)
%Image Upload number 2
global img2
[filename, pathname] = uigetfile('*.*','D:\Users\Pictures');
img2 = imread([pathname, filename]);   
imshow(img2,'Parent',handles.axes2);
set(handles.clear, 'Enable', 'on')
set(handles.match, 'Enable', 'on')
% hObject    handle to upload2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in match.
function match_Callback(~, ~, handles)
global img1;
global img2;
scale_factor = 1; 
img1 = imresize(img1, scale_factor, 'bilinear');
img2 = imresize(img2, scale_factor, 'bilinear'); 
 
I = img1;
I1 = rgb2gray(I);
I2 = imresize(imrotate(I1, -20), 1.2);
points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);
[f1,vpts1] = extractFeatures(I1,points1);
[f2,vpts2] = extractFeatures(I2,points2);
indexPairs1 = matchFeatures(f1,f2);
matchedPoints1 = vpts1(indexPairs1(:,1));
matchedPoints2 = vpts2(indexPairs1(:,2));
figure; showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
handles.axes1 = showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
II = img2;
I11 = rgb2gray(II);
I22 = imresize(imrotate(I11, -20), 1.2);
points11 = detectSURFFeatures(I11);
points22 = detectSURFFeatures(I22);
[f11,vpts11] = extractFeatures(I11,points11);
[f22,vpts22] = extractFeatures(I22,points22);
indexPairs = matchFeatures(f11,f22);
matchedPoints11 = vpts11(indexPairs(:,1));
matchedPoints22 = vpts22(indexPairs(:,2));
figure; showMatchedFeatures(I11, I22, matchedPoints11, matchedPoints22);
handles.axes1 = showMatchedFeatures(I11, I22, matchedPoints11, matchedPoints22);
    
if I1 == I11
    msgbox('Images are matched!');
else
    msgbox('Images are NOT matched!');
end
set(handles.upload2, 'Enable', 'off')
set(handles.upload1, 'Enable', 'off')
% hObject    handle to match (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in clear.
function clear_Callback(~, ~, handles)
cla(handles.axes1)
cla(handles.axes2)
set(handles.upload1, 'Enable', 'on')
set(handles.upload2, 'Enable', 'off')
set(handles.match, 'Enable', 'off')
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)