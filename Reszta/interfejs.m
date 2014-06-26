function varargout = interfejs(varargin)
% INTERFEJS MATLAB code for interfejs.fig
%      INTERFEJS, by itself, creates a new INTERFEJS or raises the existing
%      singleton*.
%
%      H = INTERFEJS returns the handle to a new INTERFEJS or the handle to
%      the existing singleton*.
%
%      INTERFEJS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFEJS.M with the given input arguments.
%
%      INTERFEJS('Property','Value',...) creates a new INTERFEJS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interfejs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interfejs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interfejs

% Last Modified by GUIDE v2.5 21-Jun-2014 22:45:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interfejs_OpeningFcn, ...
                   'gui_OutputFcn',  @interfejs_OutputFcn, ...
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


% --- Executes just before interfejs is made visible.
function interfejs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interfejs (see VARARGIN)

% Choose default command line output for interfejs
handles.output = hObject;
handles.jest=0;
handles.qim=5;
handles.skalar=0.13;
handles.klucz=924622;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interfejs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interfejs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in wybierz_zdjecie.
function wybierz_zdjecie_Callback(hObject, eventdata, handles)
% hObject    handle to wybierz_zdjecie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,filepath]=uigetfile('*.jpg');
if(filename~=0)
    handles.file=fullfile(filepath, filename);
else
    while(filename==0)
    warning('Wybierz plik');
    [filename,filepath]=uigetfile('*.jpg');
    handles.file=fullfile(filepath, filename);
    end
end
handles.jest=1;
guidata(hObject, handles);

function qim_Callback(hObject, eventdata, handles)
% hObject    handle to qim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qim as text
%        str2double(get(hObject,'String')) returns contents of qim as a double

handles.qim=str2double(get(hObject,'string'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function qim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


function skalar_Callback(hObject, eventdata, handles)
% hObject    handle to skalar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of skalar as text
%        str2double(get(hObject,'String')) returns contents of skalar as a double
handles.skalar=str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function skalar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to skalar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


function klucz_Callback(hObject, eventdata, handles)
% hObject    handle to klucz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of klucz as text
%        str2double(get(hObject,'String')) returns contents of klucz as a double
handles.klucz=str2double(get(hObject,'String'));
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function klucz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to klucz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in kodowanie.
function kodowanie_Callback(hObject, eventdata, handles)
% hObject    handle to kodowanie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
filename=0;
while(filename==0 & handles.jest==0)
    warning('Wybierz plik');
    [filename,filepath]=uigetfile('*.jpg');
    handles.file=fullfile(filepath, filename);
    
end    
znakowanie(handles.file,handles.skalar,handles.qim,handles.klucz);


% --- Executes on button press in rekonstrukcja.
function rekonstrukcja_Callback(hObject, eventdata, handles)
% hObject    handle to rekonstrukcja (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
filename=0;
while(filename==0 & handles.jest==0)
    warning('Wybierz plik');
    [filename,filepath]=uigetfile('*.jpg');
    handles.file=fullfile(filepath, filename);
    
end    
naprawa(handles.file,handles.skalar,handles.qim,handles.klucz);

% --- Executes on button press in wyjscie.
function wyjscie_Callback(hObject, eventdata, handles)
% hObject    handle to wyjscie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
quit;
