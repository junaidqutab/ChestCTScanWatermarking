%% 19L-1841_M.Asad Bin Hameed (Group leader)
%% 19L-2413_Syed Junaid Qutab (Group Member)

function varargout = fig(varargin)
% FIG MATLAB code for fig.fig
%      FIG, by itself, creates a new FIG or raises the existing
%      singleton*.
%
%      H = FIG returns the handle to a new FIG or the handle to
%      the existing singleton*.
%
%      FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIG.M with the given input arguments.
%
%      FIG('Property','Value',...) creates a new FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fig

% Last Modified by GUIDE v2.5 26-Dec-2020 17:49:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fig_OpeningFcn, ...
                   'gui_OutputFcn',  @fig_OutputFcn, ...
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


% --- Executes just before fig is made visible.
function fig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fig (see VARARGIN)

% Choose default command line output for fig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Load image
% --- Executes on button press in input.
function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path] =uigetfile('*.jpg;*.bmp;*','');
image = imread([path filename]);
axes(handles.img1);
imshow(image);
guidata(hObject,handles);
%% ROI /RONI / Segmentation
% --- Executes on button press in thresh.
function thresh_Callback(hObject, eventdata, handles)
%% Fixing key so results are reproduceable during extraction
rng(5);
% hObject    handle to thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = getimage(handles.img1);
boundry = padarray(image,[1,1]);
t=graythresh(boundry);
newimage=boundry;
%% Thresholding
for i =1: size(boundry,1)
for j=1:size(boundry,2)
    if newimage(i,j)>t*255
        newimage(i,j)=255;
    
    else
        newimage(i,j)=0;
    end    
end
end
%Binarize end

%% Segmentation
x = 0; y=0;
f = 0;
for i=1:size(newimage,1)
    for j=1:size(newimage,2)        
    if(newimage(i,j)==255)
        x=i;
        y=j;
        f = 1;
        break;
    end
    end
    if f==1
        break;
    end
end
tagging = zeros(size(newimage,1),size(newimage,2));
tagging(x,y)=2;
pre = -1;
%% TAGGING THE WHITE PIXELS / ARound the parenchyma
for k=1:50000
    
for i=1:size(newimage,1)
    for j=1:size(newimage,2)        
        if tagging(i,j)==2
            if i-1>0 && j-1>0 && newimage(i-1,j-1)==255
            tagging(i-1,j-1)=2;
            end
            if i-1>0 && newimage(i-1,j)==255
            tagging(i-1,j)=2;        
            end
            if i-1>0 && j+1<=size(newimage,2) && newimage(i-1,j+1)==255
            tagging(i-1,j+1)=2;
            end
            if j-1>0 && newimage(i,j-1)==255
            tagging(i,j-1)=2;
            end
            if j+1<=size(newimage,2) && newimage(i,j+1)==255
            tagging(i,j+1)=2;
            end
            if i+1<=size(newimage,1) && j-1>0 && newimage(i,j-1)==255
            tagging(i+1,j-1)=2;
            end
            if i+1<=size(newimage,1) && newimage(i+1,j)==255
            tagging(i+1,j)=2;
            end
            if i+1<=size(newimage,1) && j+1<=size(newimage,2) && newimage(i,j+1)==255
            tagging(i+1,j+1)=2;
            end
        end
    end
end
sum=0;
%% Used for termination of loop if no furhter region growing
for i=1:size(newimage,1)
    for j=1:size(newimage,2)        
    if(tagging(i,j)==2)
        sum = sum+1;
    end
    end
end
if pre==sum
    break
else
    pre = sum;
end
end

%% Tagging the black pixels by region growing / Starts from boundries so ignores black pixels inside the white boundry
tagging (1,1) = 1;
for k=1:50000
    
for i=1:size(newimage,1)
    for j=1:size(newimage,2)        
        if tagging(i,j)==1
            if i-1>0 && j-1>0 && newimage(i-1,j-1)==0
            tagging(i-1,j-1)=1;
            end
            if i-1>0 && newimage(i-1,j)==0
            tagging(i-1,j)=1;        
            end
            if i-1>0 && j+1<=size(newimage,2) && newimage(i-1,j+1)==0
            tagging(i-1,j+1)=1;
            end
            if j-1>0 && newimage(i,j-1)==0
            tagging(i,j-1)=1;
            end
            if j+1<=size(newimage,2) && newimage(i,j+1)==0
            tagging(i,j+1)=1;
            end
            if i+1<=size(newimage,1) && j-1>0 && newimage(i,j-1)==0
            tagging(i+1,j-1)=1;
            end
            if i+1<=size(newimage,1) && newimage(i+1,j)==0
            tagging(i+1,j)=1;
            end
            if i+1<=size(newimage,1) && j+1<=size(newimage,2) && newimage(i,j+1)==0
            tagging(i+1,j+1)=1;
            end
        end
    end
end
sum=0;
for i=1:size(newimage,1)
    for j=1:size(newimage,2)        
    if(tagging(i,j)==1)
        sum = sum+1;
    end
    end
end
if pre==sum
    break
else
    pre = sum;
end
end
%% Setting areas outside the white boundry determined by region growing as white
segmented = newimage;
for i=1:size(newimage,1)
    for j=1:size(newimage,2)
    if tagging(i,j)==1
        segmented(i,j)=255;
    end
    end
end
ROI = zeros(size(newimage,1),size(newimage,2));
%% Getting ROI (Which will be the only black region left)
for i=1:size(newimage,1)
    for j=1:size(newimage,2)
    if segmented(i,j)==0
        ROI(i,j)=1;
    end
    end
end
%% Getting roi and roni to show on axes
ROIimage = boundry;
RONIimage = boundry;
for i=1:size(newimage,1)
    for j=1:size(newimage,2)
    if ROI(i,j)==1
        ROIimage(i,j)=255;
    elseif ROI(i,j)==0
        RONIimage(i,j)=255;
    end
    end
end
axes(handles.img4);
imshow(ROIimage);
axes(handles.img5);
imshow(RONIimage);
handles.ROI = ROI;
handles.boundry=boundry;
guidata(hObject,handles);

%% Watermark load
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path] =uigetfile('*.jpg;*.bmp;*','');
image = imread([path filename]);
axes(handles.wm);
imshow(image);
guidata(hObject,handles);



function digest = md5(message)
    % digest = md5(message)
    %  Compute the MD5 digest of the message, as a hexadecimal digest.
 
    % Follow the MD5 algorithm from RFC 1321 [1] and Wikipedia [2].
    %  [1] http://tools.ietf.org/html/rfc1321
    %  [2] http://en.wikipedia.org/wiki/MD5
 
    % m is the modulus for 32-bit unsigned arithmetic.
    m = 2 ^ 32;
 
    % s is the shift table for circshift(). Each shift is negative
    % because it is a left shift.
    s = [-7, -12, -17, -22
         -5,  -9, -14, -20
         -4, -11, -16, -23
         -6, -10, -15, -21];
 
    % t is the sine table. Each sine is a 32-bit integer, unsigned.
    t = floor(abs(sin(1:64)) .* m);
 
    % Initialize the hash, as a row vector of 32-bit integers.
    digest = [hex2dec('67452301') ...
              hex2dec('EFCDAB89') ...
              hex2dec('98BADCFE') ...
              hex2dec('10325476')];
 
    % If message cfmd5ontains characters, convert them to ASCII values.
    message = double(message);
    bytelen = numel(message);
 
    % Pad the message by appending a 1, then appending enough 0s to make
    % the bit length congruent to 448 mod 512. Because we have bytes, we
    % append 128 '10000000', then append enough 0s '00000000's to make
    % the byte length congruent to 56 mod 64.
    size(zeros(1, mod(55 - bytelen, 64)));
    size(message);
    message = [message, 128, zeros(1, mod(55 - bytelen, 64))];
 
    % Convert the message to 32-bit integers, little endian.
    % For little endian, first byte is least significant byte.
    message = reshape(message, 4, numel(message) / 4);
    message = message(1,:) + ...            % least significant byte
              message(2,:) * 256 + ...
              message(3,:) * 65536 + ...
              message(4,:) * 16777216;      % most significant byte
 
    % Append the bit length as a 64-bit integer, little endian.
    bitlen = bytelen * 8;
    message = [message, mod(bitlen, m), mod(bitlen / m, m)];
 
    % Process each 512-bit block. Because we have 32-bit integers, each
    % block has 16 elements, message(k + (0:15)).
    for k = 1:16:numel(message)
        % Copy hash.
        a = digest(1); b = digest(2); c = digest(3); d = digest(4);
 
        % Do 64 operations.
        for i = (1:64)
            % Convert b, c, d to row vectors of bits (0s and 1s).
            bv = dec2bin(b, 32) - '0';
            cv = dec2bin(c, 32) - '0';
            dv = dec2bin(d, 32) - '0';
 
            % Find f  = mix of b, c, d.
            %      ki = index in 0:15, to message(k + ki).
            %      sr = row in 1:4, to s(sr, :).
            if i <= 16          % Round 1
                f = (bv & cv) | (~bv & dv);
                ki = i - 1;
                sr = 1;
            elseif i <= 32      % Round 2
                f = (bv & dv) | (cv & ~dv);
                ki = mod(5 * i - 4, 16);
                sr = 2;
            elseif i <= 48      % Round 3
                f = xor(bv, xor(cv, dv));
                ki = mod(3 * i + 2, 16);
                sr = 3;
            else                % Round 4
                f = xor(cv, bv | ~dv);
                ki = mod(7 * i - 7, 16);
                sr = 4;
            end
 
            % Convert f, from row vector of bits, to 32-bit integer.
            f = bin2dec(char(f + '0'));
 
            % Do circular shift of sum.
            sc = mod(i - 1, 4) + 1;
            sum = mod(a + f + message(k + ki) + t(i), m);
            sum = dec2bin(sum, 32);
            sum = circshift(sum, [0, s(sr, sc)]);
            sum = bin2dec(sum);
 
            % Update a, b, c, d.
            temp = d;
            d = c;
            c = b;
            b = mod(b + sum, m);
            a = temp;
        end %for i
 
        % Add hash of this block to hash of previous blocks.
        digest = mod(digest + [a, b, c, d], m);
    end %for k
 
    % Convert hash from 32-bit integers, little endian, to bytes.
    digest = [digest                % least significant byte
              digest / 256
              digest / 65536
              digest / 16777216];   % most significant byte
    digest = reshape(mod(floor(digest), 256), 1, numel(digest));
 
    % Convert hash to hexadecimal.
    digest = dec2hex(digest);
    digest = reshape(transpose(digest), 1, numel(digest));
 



% --- Executes on button press in pushbutton4.


%% Embedding
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rng(5);
logo= getimage(handles.wm);
%% Logo thresholding
t = graythresh(logo);
logo = imbinarize(logo,t);

%% Logo converted to columns vector
logov = logo(:);
%% Logovector row
logovr=logov.';
%% Got image
image = handles.boundry;
boundryv = image(:);
%% Image converted to binary vector
boundryvr=boundryv.';
%% Setting binary lsb to 0
boundrylsb0=bitset(boundryvr,1,0);
%% Getting md5 value
hash=md5(boundrylsb0);
hashv = double(char(hash));
hashbit=de2bi(hashv,8);
hashbitcol=hashbit(:);
hashbitrow=hashbitcol.';
%% Need to concat the logo and this hash here
W=horzcat(logovr,hashbitrow);
%% Pseudo random vector
P = randi([0 1],size(W));
%% Final watermark
Wfinal=bitxor(W,P);
%% Image to scramble
testimage=image;
ROI = handles.ROI;
%% Getting region of non interest count
count = 0;
for i = 1:size(image,1)
    for j =1:size(image,2)
        if ROI(i,j) == 0
            count = count+1;    
        end
    end
end
%% Pixel locations of RONI
roni = zeros(1,count);
s = 1; % Index for the new number 
for i = 1:size(image,1)
    for j =1:size(image,2)
        if ROI(i,j)==0
            roni(s) = sub2ind(size(image),i,j);
            s=s+1;
        end
    end
end
%% Shuffling the indices
randomorder=randperm(numel(roni)); %Shuffling
d = 1; % Index for the new number 
for i = 1:size(image,1)
    for j =1:size(image,2)
        if ROI(i,j) ==0
            testimage(roni(d))=image(roni(randomorder(d)));
            d=d+1;
        end
    end
end
%% Embedding the watermark in the shuffled pixels
embedind=1;
for i = 1:size(image,1)
    for j =1:size(image,2)
        if ROI(i,j) ==0
            testimage(i,j)=bitset(testimage(i,j),1,Wfinal(embedind));
            embedind=embedind+1;
            if embedind > size(Wfinal)
                break;
            end
        end
    end
    if embedind > size(Wfinal)
                break;
    end
end
axes(handles.img6);
imshow(testimage);
%% Unshuffling to get original image
reassemble = testimage;
f= 1; % Index for the new number 
for i = 1:size(image,1) 
    for j =1:size(image,2)
        if ROI(i,j)==0
            reassemble(roni(randomorder(f)))=testimage(roni(f));
            f=f+1;
        end
    end
end
axes(handles.img7);
imshow(reassemble);
handles.P = P;
handles.shuffle  = randomorder;
guidata(hObject,handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path] =uigetfile('*.jpg;*.bmp;*','');
image = imread([path filename]);
axes(handles.check);
imshow(image);
guidata(hObject,handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rng(5);
%% Got image
image = getimage(handles.check);
boundry=image;
%% Column vector
boundryv = image(:);
%% Row vector
boundryvr=boundryv.';
%% LSB SET TO 0
boundrylsb0=bitset(boundryvr,1,0);
%% Hash
hash=md5(boundrylsb0);
hashv = double(char(hash));
hashbit=de2bi(hashv,8);
hashbitcol=hashbit(:);
%% Converted to binary 256 size
hashbitrow=hashbitcol.';
%% Image segmentation
t=graythresh(boundry);
newimage=boundry;
for i =1: size(boundry,1)
for j=1:size(boundry,2)
    if newimage(i,j)>t*255
        newimage(i,j)=255;
    else
        newimage(i,j)=0;
    end    
end
end
%% Binarize end

%% Segmentation
x = 0; y=0;
f = 0;
for i=1:size(newimage,1)
    for j=1:size(newimage,2)        
    if(newimage(i,j)==255)
        x=i;
        y=j;
        f = 1;
        break;
    end
    end
    if f==1
        break;
    end
end
%% RegionGrowing, First tagging white region
tagging = zeros(size(newimage,1),size(newimage,2));
tagging(x,y)=2;
pre = -1;
% TAGGING THE WHITE PIXELS / ARound the parenchyma
for k=1:50000
    
for i=1:size(newimage,1)
    for j=1:size(newimage,2)        
        if tagging(i,j)==2
            if i-1>0 && j-1>0 && newimage(i-1,j-1)==255
            tagging(i-1,j-1)=2;
            end
            if i-1>0 && newimage(i-1,j)==255
            tagging(i-1,j)=2;        
            end
            if i-1>0 && j+1<=size(newimage,2) && newimage(i-1,j+1)==255
            tagging(i-1,j+1)=2;
            end
            if j-1>0 && newimage(i,j-1)==255
            tagging(i,j-1)=2;
            end
            if j+1<=size(newimage,2) && newimage(i,j+1)==255
            tagging(i,j+1)=2;
            end
            if i+1<=size(newimage,1) && j-1>0 && newimage(i,j-1)==255
            tagging(i+1,j-1)=2;
            end
            if i+1<=size(newimage,1) && newimage(i+1,j)==255
            tagging(i+1,j)=2;
            end
            if i+1<=size(newimage,1) && j+1<=size(newimage,2) && newimage(i,j+1)==255
            tagging(i+1,j+1)=2;
            end
        end
    end
end
sum=0;
for i=1:size(newimage,1)
    for j=1:size(newimage,2)        
    if(tagging(i,j)==2)
        sum = sum+1;
    end
    end
end
if pre==sum
    break
else
    pre = sum;
end
end

%% Tagging the black pixels
tagging (1,1) = 1;
for k=1:50000
    
for i=1:size(newimage,1)
    for j=1:size(newimage,2)        
        if tagging(i,j)==1
            if i-1>0 && j-1>0 && newimage(i-1,j-1)==0
            tagging(i-1,j-1)=1;
            end
            if i-1>0 && newimage(i-1,j)==0
            tagging(i-1,j)=1;        
            end
            if i-1>0 && j+1<=size(newimage,2) && newimage(i-1,j+1)==0
            tagging(i-1,j+1)=1;
            end
            if j-1>0 && newimage(i,j-1)==0
            tagging(i,j-1)=1;
            end
            if j+1<=size(newimage,2) && newimage(i,j+1)==0
            tagging(i,j+1)=1;
            end
            if i+1<=size(newimage,1) && j-1>0 && newimage(i,j-1)==0
            tagging(i+1,j-1)=1;
            end
            if i+1<=size(newimage,1) && newimage(i+1,j)==0
            tagging(i+1,j)=1;
            end
            if i+1<=size(newimage,1) && j+1<=size(newimage,2) && newimage(i,j+1)==0
            tagging(i+1,j+1)=1;
            end
        end
    end
end
sum=0;
for i=1:size(newimage,1)
    for j=1:size(newimage,2)        
    if(tagging(i,j)==1)
        sum = sum+1;
    end
    end
end
if pre==sum
    break
else
    pre = sum;
end
end
%% Setting region grown to white
segmented = newimage;
for i=1:size(newimage,1)
    for j=1:size(newimage,2)
    if tagging(i,j)==1
        segmented(i,j)=255;
    end
    end
end
%% Tagging ROI
ROI = zeros(size(newimage,1),size(newimage,2));
for i=1:size(newimage,1)
    for j=1:size(newimage,2)
    if segmented(i,j)==0
        ROI(i,j)=1;
    end
    end
end
%% Pseudo Random vector
P = randi([0 1],[1,4352]);
testimage=image;
count = 0;
for i = 1:size(image,1)
    for j =1:size(image,2)
        if ROI(i,j) == 0
            count = count+1;    
        end
    end
end 
%% Counting number of pixels in RONI
roni = zeros(1,count);
s = 1; % Index for the new number 
for i = 1:size(image,1)
    for j =1:size(image,2)
        if ROI(i,j)==0
            roni(s) = sub2ind(size(image),i,j);
            s=s+1;
        end
    end
end
%% Shuffling roni
randomorder=randperm(numel(roni)); %Shuffling
d = 1; % Index for the new number 
for i = 1:size(image,1)
    for j =1:size(image,2)
        if ROI(i,j) ==0
            testimage(roni(d))=image(roni(randomorder(d)));
            d=d+1;
        end
    end
end
%% Extracting watermark
embedind=1;
Wext=zeros(1,4352);
for i = 1:size(image,1)
    for j =1:size(image,2)
        if ROI(i,j) ==0
            Wext(embedind)=bitget(testimage(i,j),1);
            embedind=embedind+1;
            if embedind > size(Wext)
                break;
            end
        end
    end
    if embedind > size(Wext)
                break;
    end
end

%% Getting hash vector value
Worig = bitxor(Wext,P);
%% Getting hash value of image > will be at end after 64x64 logo
Whash = Worig(1,4097:end);
size(Whash);
size(hashbitrow);
%% Logo reshaped to show it
Wlogo = reshape(Worig(1:4096),[64,64]);
if isequal(hashbitrow,Whash)
    set(handles.result,'string','Equal');
else
    set(handles.result,'string','Not equal');
end
%% Logo reconstructed

axes(handles.scram);
imshow(Wlogo);

% --- Executes on button press in pushbutton7.
%% Saving image
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imsave(handles.img7);
