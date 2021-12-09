function varargout = decaptcha_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @decaptcha_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @decaptcha_gui_OutputFcn, ...
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


% --- Executes just before decaptcha_gui is made visible.
function decaptcha_gui_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for decaptcha_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = decaptcha_gui_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
disp('Load image button pressed ...')
%% Create a file dialog for images
[filename, user_cancelled] = imgetfile;
    if user_cancelled
            disp('User pressed cancel')
    else
            disp(['User selected ', filename])
    end

    %% Read the selected image into the variable
    disp('Reading the image into variable X');
    [X,map] = imread(filename);
    %% Copy X and map to base workspace, overwriting the content !!!
    assignin('base','X',X); 
    assignin('base','map',map); 
    %% Now you have X and map variables in the base workspace
    axes(handles.axes1);
    imshow(X);
    
background = imopen(X,strel('disk',15));
figure, surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
set(gca,'ydir','reverse');
I2 = X - background;
figure, imshow(I2)
level = graythresh(I2);
Ibw = im2bw(I2,level);
Ibw = bwareaopen(Ibw, 50);
figure, imshow(Ibw)
cc = bwconncomp(Ibw, 4)
cc.NumObjects
Ibw = ~Ibw;
Igray = rgb2gray(X);
Iedge = edge(uint8(Igray));
imshow(Ibw);
se = strel('square',2); 
Iedge2 = imdilate(Iedge, se); 
Ifill= imfill(Iedge2,'holes'); 
[Ilabel num] = bwlabel(Ifill); 
Iprops = regionprops(Ilabel); 
Ibox = [Iprops.BoundingBox]; 
disp(size(Ibox));
Ibox = reshape(Ibox,[4 length(Ibox)/4]);
imshow(Ibw)
hold on; 
for cnt = 1:length(Ibox) 
rectangle('position',Ibox(:,cnt),'edgecolor','r');
end
letters = zeros(26,26,10);
for cnt = 1:length(Ibox) 
out = ceil(Ibox(1:2,cnt))';
start_ocr_col = out(1,1);
start_ocr_row = out(1,2);
end_ocr_col = start_ocr_col + ceil(Ibox(3,cnt))-1;
end_ocr_row = start_ocr_row + ceil(Ibox(4,cnt))-1;
subimage(cnt) = {Ifill(start_ocr_row:end_ocr_row, start_ocr_col:end_ocr_col,:)};
% subimage{cnt}=imsharpen(subimage{cnt});
figure, imshow(~subimage{cnt}) 
let=extractletter(~subimage{cnt}, 0, 26);
letters(:,:,cnt) = let;
end

fontsize =16;
sz = fontsize + 10;
letters_trng = zeros(sz,sz,10);

for n=1:10
c = char('0'+n-1);
figure(1);clf;axis([-5 5 -5 5]);axis off; axis equal;
text(.1,.5,['\fontsize{36}'...
     '\color{black}' c...
       ])
set(gcf, 'color', 'white'); drawnow; pause(.002);
img=frame2im(getframe(gcf));drawnow;pause(.002);
dimg = double(img);
dimg=sqrt(dimg(:,:,1).^2 + dimg(:,:,2).^2 + dimg(:,:,3).^2/sqrt(3));
let_trng=extractletter(dimg, 0, sz);
letters_trng(:,:,n) = let_trng;
end

% Comparison of letters generated with letters in captcha
f = cell(length(Ibox), 1);
for p=1:length(Ibox)
    for n=1:10
        cntr=0;
        if n==1
            max=cntr;
        end
        character=1;
        for i=1:26 
            for j=1:26
                if letters_trng(i,j,n)== letters(i,j,p)
                    cntr=cntr+1;
                end
            end
        end
        if(max<cntr)
            max=cntr;
            %disp(max);
            character=n-1;
            %disp(character);
        end
    end 
    disp (max);
    disp(character);
    f{p} = strcat(f{p}, num2str(character));
end

disp(f);
set(handles.text3, 'String', f) 



function [let, avex, avey] = extractletter(img, num, sz)
[rows, columns] = find(img==num);
avex = floor(sum(rows)/length(rows));
avey = floor(sum(columns)/length(columns));
let = zeros(sz, sz);

for m= 1:length(rows)
r=max(1, min(sz, rows(m) + sz/2 - avex));
c=max(1, min(sz, columns(m) + sz/2 - avey));
let(r,c) = 255;
end

for layer = 1:1
newlet = let;
for i=1:sz
for j=1:sz
rows = max(1, min(sz, i-1:i+1));
cols = max(1, min(sz, j-1:j+1));
if(max(max(let(rows,cols)))>let(i,j))
newlet(i,j)= max(max(let(rows,cols)));
end
end
end
let=newlet;
end
