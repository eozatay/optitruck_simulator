function varargout = optiTruckGUI(varargin)
% OPTITRUCKGUI MATLAB code for optiTruckGUI.fig
%      OPTITRUCKGUI, by itself, creates a new OPTITRUCKGUI or raises the existing
%      singleton*.
%
%      H = OPTITRUCKGUI returns the handle to a new OPTITRUCKGUI or the handle to
%      the existing singleton*.
%
%      OPTITRUCKGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTITRUCKGUI.M with the given input arguments.
%
%      OPTITRUCKGUI('Property','Value',...) creates a new OPTITRUCKGUI or raises the
%      existing singleton*.  Starting from the left, property vFalue pairs are
%      applied to the GUI before optiTruckGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to optiTruckGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help optiTruckGUI

% Last Modified by GUIDE v2.5 04-Apr-2018 08:35:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @optiTruckGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @optiTruckGUI_OutputFcn, ...
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


% --- Executes just before optiTruckGUI is made visible.
function optiTruckGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to optiTruckGUI (see VARARGIN)

% Initially draws a map on plot 
axes(handles.axes1);
plot_google_map;
axis([28.7 29.4 40.9 41.3]);

% Choose default command line output for optiTruckGUI
handles.output = hObject;

handles.rg_chosen_id   = 1;
handles.wind_chosen_id = 1;

handles.cloud_totalDist = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes optiTruckGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = optiTruckGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in routebutton.
function routebutton_Callback(hObject, eventdata, handles)
% hObject    handle to routebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.startLoc
handles.endLoc

children1 = handles.figure1.Children;
ind = 1;
children = [];
for i=1:length(children1)
    if strcmp(handles.figure1.Children(i).Type, 'axes')
       ind = i;
       children = [children; handles.figure1.Children(i).Children];
    end
end


delList = [];
for i=1:length(children)
   if strcmp(children(i).Type, 'line')
       delete(children(i))
   end
end

url = ['http://146.185.158.112:5000/route/v1/driving/' num2str(handles.startLoc(1)) ',' num2str(handles.startLoc(2)) ';' num2str(handles.endLoc(1)) ',' num2str(handles.endLoc(2)) '?overview=full&geometries=geojson'];
options = weboptions('RequestMethod','get', 'MediaType','application/json', 'HeaderFields',{'Content-Type' 'application/json'}, 'Timeout', 20);

r = webread(url,options);
r.routes.geometry.coordinates

urlSL1 = 'http://bms.basarsoft.com.tr/Service/api/v1/ReverseGeocode?accId=fQ9nQOPsL06pvVW_mOfr9A&appCode=SGnr80OitkuAMsBhoqjSNw&Lon=';
urlSL2 = '&Lat=';
urlSL3 = '&Max=100';
options = weboptions('RequestMethod','get', 'HeaderFields',[{'Content-Type' 'text/plain'}; {'Cache-Control' 'no-cache'}], 'Timeout', 20);
spd=[];

% maxspeed = 0;
% for i=1:10:length(r.routes.geometry.coordinates)
%     %urlSL = [urlSL1 num2str(r.routes.geometry.coordinates(i,1)) urlSL2  num2str(r.routes.geometry.coordinates(i,2)) urlSL3 ];
%     %sl = webread(urlSL,options);
%     sl.YolHizlimit = 50;
% 
%     if sl.YolHizlimit > maxspeed
%        maxspeed = sl.YolHizlimit; 
%     end
%     
%     for j=1:10
%         if length(spd) < length(r.routes.geometry.coordinates)
%             spd = [spd sl.YolHizlimit]; 
%         end
%     end
% end

distLast = 0; 
dst = [0];
spd = [50];
grd = [handles.rg_constant_slider.Value];
wnd = [handles.wind_constant_slider.Value];
maxspeed = 0;
axes(handles.axes1);
for i=1:length(r.routes.geometry.coordinates)-1
    d = calculateDist(r.routes.geometry.coordinates(i, 2),r.routes.geometry.coordinates(i, 1),r.routes.geometry.coordinates(i+1, 2),r.routes.geometry.coordinates(i+1, 1));
    if d == 0
       continue; 
    end
    dst = [dst distLast + d];
    %spd = [spd 50];
    grd = [grd  handles.rg_constant_slider.Value];
    wnd = [wnd  handles.wind_constant_slider.Value];
    spd = [spd 50];
    distLast = dst(end);
    plot([r.routes.geometry.coordinates(i, 1) r.routes.geometry.coordinates(i+1, 1)], [r.routes.geometry.coordinates(i, 2) r.routes.geometry.coordinates(i+1, 2)],'r', 'Linewidth',3)
end

axes(handles.axes2);
plot(dst, spd);
axis([0 dst(end)+100 0 maxspeed+10]);

dur = r.routes.duration;
durHR = floor(dur/3600);
dur = dur - durHR*3600;
durMIN = floor(dur/60);
durSEC = dur - durMIN*60;

handles.sp_file_type = 1;
handles.cloud_dst = dst;
handles.cloud_tim = zeros(size(dst));
handles.cloud_grd = grd;
handles.cloud_wnd = wnd;
handles.cloud_spd = spd;
handles.cloud_stopdurations = [5,5,5,5];

handles.cloud_totalDist = dst(end);
handles.cloud_totalDur  = r.routes.duration;

handles.distance_text.String = [num2str(dst(end)/1000, '%.1f') ' KM'];
handles.duration_text.String = [num2str(durHR, '%02.0f') ':' num2str(durMIN, '%02.0f') ':' num2str(durSEC, '%02.0f')]; 

guidata(hObject,handles);




function dist = calculateDist(Lat1,Lon1,Lat2,Lon2)
    R = 1.609344 * 3900.35017*1000;   %km Radius of Earth
    dist = 2*R*asin(sqrt((sin((Lat2-Lat1)/2*pi/180))^2 + cos(Lat2*pi/180)*cos(Lat1*pi/180)* (sin((Lon2-Lon1)/2*pi/180))^2)) ;


% --------------------------------------------------------------------
function uitoggletool1_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.uitoggletool2(1).State = 'off';
uitoggletool2_OffCallback(hObject, eventdata, handles);

handles.startLoc = [0,0];
handles.hdt = datacursormode;
set(handles.hdt,'UpdateFcn',{@labeldtips, hObject, handles, 0, handles.text3});

guidata(hObject,handles);



% --------------------------------------------------------------------
function uitoggletool2_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.uitoggletool1(1).State = 'off';
uitoggletool1_OffCallback(hObject, eventdata, handles);

handles.endLoc = [0,0];
handles.hdt = datacursormode;
set(handles.hdt,'UpdateFcn',{@labeldtips, hObject, handles, 1, handles.text4});

guidata(hObject,handles);



% --------------------------------------------------------------------
function uitoggletool1_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(findall(gcf,'Type','hggroup'));

datacursormode off;

% --------------------------------------------------------------------
function uitoggletool2_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(findall(gcf,'Type','hggroup'));

datacursormode off;

function output_txt  = labeldtips(obj,event_obj, hObject, handles, s, txtField)
% Display an observation's Y-data and label for a data tip
% obj          Currently not used (empty)
% event_obj    Handle to event object


info_cursor = getCursorInfo(handles.hdt);

pos = info_cursor.Position;

if s == 0
    handles.startLoc = pos;
else
    handles.endLoc = pos;
end

output_txt{1} = ['X: ', num2str(pos(1))];
output_txt{2} = ['Y: ', num2str(pos(2))]; %this is the text next to the cursor

txtField.String   = getGeocoding(num2str(pos(1)), num2str(pos(2)));

guidata(hObject,handles);


function addr = getGeocoding(lng, lat)

% url = 'https://xlocate-eu-n-test.cloud.ptvgroup.com/xlocate/rs/XLocate/findLocation';
% 
% xy = struct('x',lng, 'y', lat);
% p  = struct('point', xy);
% c  = struct('coordinate', p);
% l  = struct('location', c, 'options', [], 'sorting', [], 'additionalFields', [],'callerContext', struct('properties',[struct('key', 'CoordFormat', 'value', 'OG_GEODECIMAL'), struct('key', 'Profile', 'value', 'default')])); 
% 
% %options = weboptions('MediaType','application/json');
% options = weboptions('RequestMethod','post', 'MediaType','application/json', 'HeaderFields',{'Authorization' 'Basic eHRvazo5NDNmMjNkZC0xODhjLTQ4MDctYjU1OS02YjM3ZWU4ZDIwZGQ=';'Content-Type' 'application/json'});
% 
% if length(r.resultList) == 1
%     addr = [r.resultList.street ,', ', r.resultList.city,', ', r.resultList.state,', ', r.resultList.country,', ', r.resultList.postCode];
% elseif length(r.resultList) > 1
%     addr = [r.resultList(1).street ,', ', r.resultList(1).city,', ', r.resultList(1).state,', ', r.resultList(1).country,', ', r.resultList(1).postCode];
% end

url = ['https://geocode-maps.yandex.ru/1.x/?format=json&geocode=' num2str(lng) ',' num2str(lat) '&lang=tr-TR'];
options = weboptions('RequestMethod','get', 'MediaType','application/json', 'HeaderFields',{'Content-Type' 'application/json'});

r = webread(url,options);

addr = '';
if length(r.response.GeoObjectCollection.featureMember) >= 1
   addr = r.response.GeoObjectCollection.featureMember(1).GeoObject.metaDataProperty.GeocoderMetaData.text; 
end


% --- Executes on button press in rg_constant.
function rg_constant_Callback(hObject, eventdata, handles)
% hObject    handle to rg_constant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.rg_constant.Value
   handles.rg_random.Value = 0;
   handles.rg_cloud.Value = 0;
   handles.rg_file.Value = 0;
   
   handles.rg_chosen_id = 1;
else
   handles.rg_random.Value = 1;
   handles.rg_cloud.Value = 0; 
   handles.rg_file.Value = 0;
   
   handles.rg_chosen_id = 2;
end

guidata(hObject,handles);

 


% Hint: get(hObject,'Value') returns toggle state of rg_constant


% --- Executes on button press in rg_random.
function rg_random_Callback(hObject, eventdata, handles)
% hObject    handle to rg_random (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.rg_random.Value
   handles.rg_constant.Value = 0;
   handles.rg_cloud.Value = 0;
   handles.rg_file.Value = 0;
   
   handles.rg_chosen_id = 2;
else
   handles.rg_constant.Value = 1;
   handles.rg_cloud.Value = 0; 
   handles.rg_file.Value = 0;
   
   handles.rg_chosen_id = 1;
end

guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of rg_random


% --- Executes on button press in rg_cloud.
function rg_cloud_Callback(hObject, eventdata, handles)
% hObject    handle to rg_cloud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.rg_cloud.Value
   handles.rg_constant.Value = 0;
   handles.rg_random.Value = 0;
   handles.rg_file.Value = 0;
   
   handles.rg_chosen_id = 3;

else
   handles.rg_constant.Value = 1;
   handles.rg_random.Value = 0; 
   handles.rg_file.Value = 0;
   
   handles.rg_chosen_id = 1;
end

guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of rg_cloud


% --- Executes on button press in rg_file.
function rg_file_Callback(hObject, eventdata, handles)
% hObject    handle to rg_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.rg_file.Value
   handles.rg_constant.Value = 0;
   handles.rg_random.Value = 0;
   handles.rg_cloud.Value = 0;
   
   handles.rg_chosen_id = 4;

else
   handles.rg_constant.Value = 1;
   handles.rg_random.Value = 0;
   handles.rg_cloud.Value = 0;
   
   handles.rg_chosen_id = 1;
end

guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of rg_file


% --- Executes on button press in wind_constant_checkbox.
function wind_constant_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to wind_constant_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.wind_constant_checkbox.Value
   handles.wind_random_checkbox.Value = 0;
   handles.wind_cloud_checkbox.Value = 0;
   handles.wind_file_checkbox.Value = 0;
   
   handles.wind_chosen_id = 1;
else
   handles.wind_random_checkbox.Value = 1;
   handles.wind_cloud_checkbox.Value = 0;
   handles.wind_file_checkbox.Value = 0;

   
   handles.wind_chosen_id = 2;
end

guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of wind_constant_checkbox


% --- Executes on button press in wind_random_checkbox.
function wind_random_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to wind_random_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.wind_random_checkbox.Value
   handles.wind_constant_checkbox.Value = 0;
   handles.wind_cloud_checkbox.Value = 0;
   handles.wind_file_checkbox.Value = 0;
   
   handles.wind_chosen_id = 2;
else
   handles.wind_constant_checkbox.Value = 1;
   handles.wind_cloud_checkbox.Value = 0;
   handles.wind_file_checkbox.Value = 0;
   
   handles.wind_chosen_id = 1;
end

guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of wind_random_checkbox


% --- Executes on button press in wind_cloud_checkbox.
function wind_cloud_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to wind_cloud_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.wind_cloud_checkbox.Value
   handles.wind_random_checkbox.Value = 0;
   handles.wind_constant_checkbox.Value = 0;
   handles.wind_file_checkbox.Value = 0;
   
   handles.wind_chosen_id = 3;
else
   handles.wind_random_checkbox.Value = 0;
   handles.wind_constant_checkbox.Value = 1;
   handles.wind_file_checkbox.Value = 0;
   
   handles.wind_chosen_id = 1;
end

guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of wind_cloud_checkbox

% --- Executes on button press in wind_file_checkbox.
function wind_file_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to wind_cloud_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.wind_file_checkbox.Value
   handles.wind_random_checkbox.Value = 0;
   handles.wind_constant_checkbox.Value = 0;
   handles.wind_cloud_checkbox.Value = 0;
   
   handles.wind_chosen_id = 4;
else
   handles.wind_random_checkbox.Value = 0;
   handles.wind_constant_checkbox.Value = 1;
   handles.wind_cloud_checkbox.Value = 0;
   
   handles.wind_chosen_id = 1;
end

guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of wind_file_checkbox



% --- Executes on slider movement.
function rg_constant_slider_Callback(hObject, eventdata, handles)
% hObject    handle to rg_constant_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
get(hObject,'Value')
handles.rg_constant.Value = 1;
handles.rg_random.Value = 0;
handles.rg_cloud.Value = 0;
handles.rg_file.Value = 0;

handles.rg_chosen_id = 1;

handles.rg_const_label.String= [num2str(hObject.Value, '%.1f') ' rad'];

guidata(hObject,handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function rg_constant_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rg_constant_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'Min', -5);
set(hObject, 'Max',  5);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function wind_constant_slider_Callback(hObject, eventdata, handles)
% hObject    handle to wind_constant_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.wind_constant_checkbox.Value = 1;
handles.wind_random_checkbox.Value = 0;
handles.wind_cloud_checkbox.Value = 0;
handles.wind_file_checkbox.Value = 0;

handles.wind_chosen_id = 1;

handles.wind_const_label.String= [num2str(hObject.Value, '%.0f') ' kph'];

guidata(hObject,handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function wind_constant_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wind_constant_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Min', -50);
set(hObject, 'Max',  50);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function rd_sin_per_slider_Callback(hObject, eventdata, handles)
% hObject    handle to rd_sin_per_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.rg_constant.Value = 0;
handles.rg_random.Value = 1;
handles.rg_cloud.Value = 0;
handles.rg_file.Value = 0;

handles.rg_chosen_id = 2;

handles.rd_sin_per_text.String= [num2str(hObject.Value, '%.0f') ' m'];

guidata(hObject,handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function rd_sin_per_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rd_sin_per_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function rd_sin_amp_slider_Callback(hObject, eventdata, handles)
% hObject    handle to rd_sin_amp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.rg_constant.Value = 0;
handles.rg_random.Value = 1;
handles.rg_cloud.Value = 0;
handles.rg_file.Value = 0;

handles.rg_chosen_id = 2;

handles.rd_sin_amp_text.String= [num2str(hObject.Value, '%.1f') ' m'];


guidata(hObject,handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function rd_sin_amp_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rd_sin_amp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function wind_sin_per_slider_Callback(hObject, eventdata, handles)
% hObject    handle to wind_sin_per_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.wind_constant_checkbox.Value = 0;
handles.wind_random_checkbox.Value = 1;
handles.wind_cloud_checkbox.Value = 0;
handles.wind_file_checkbox.Value = 0;

handles.wind_chosen_id = 2;

handles.wind_sin_per_text.String= [num2str(hObject.Value, '%.0f') ' m'];

guidata(hObject,handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function wind_sin_per_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wind_sin_per_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function wind_sin_amp_slider_Callback(hObject, eventdata, handles)
% hObject    handle to wind_sin_amp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.wind_constant_checkbox.Value = 0;
handles.wind_random_checkbox.Value = 1;
handles.wind_cloud_checkbox.Value = 0;
handles.wind_file_checkbox.Value = 0;

handles.wind_chosen_id = 2;

handles.wind_sin_amp_text.String= [num2str(hObject.Value, '%.0f') ' kph'];

guidata(hObject,handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function wind_sin_amp_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wind_sin_amp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in confirm_button.
function confirm_button_Callback(hObject, eventdata, handles)
% hObject    handle to confirm_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(['Chosen Road Grade Indx:' num2str(handles.rg_chosen_id)]);
disp(['Chosen Wind Indx:' num2str(handles.wind_chosen_id)]);


if handles.cloud_totalDist == 0
    %warndlg({'Message line 1';'Message line 2'}, 'Warning!', 'modal');
    warndlg({'Route information is missing. Make sure that a valid route is chosen!'}, 'Warning!', 'modal');
    
else
    roadGradeData = struct('Indx', handles.rg_chosen_id, 'Constant', handles.rg_constant_slider.Value, ...
                           'Period', handles.rd_sin_per_slider.Value, 'Amplitude', handles.rd_sin_amp_slider.Value);

    windData = struct('Indx', handles.wind_chosen_id, 'Constant', handles.wind_constant_slider.Value, ...
                           'Period', handles.wind_sin_per_slider.Value, 'Amplitude', handles.wind_sin_amp_slider.Value); 

    routeData = struct('Distance', handles.cloud_dst, 'Speed', handles.cloud_spd, 'Time', handles.cloud_tim, ...
                       'Total_Distance', handles.cloud_totalDist, 'Total_Duration', handles.cloud_totalDur, ...
                       'Grade', handles.cloud_grd, 'Wind', handles.cloud_wnd,...
                       'Filetype', handles.sp_file_type,'StopDurations', handles.cloud_stopdurations);                   

    guiOut = struct('RoadGradeInfo', roadGradeData, 'WindInfo', windData, 'RouteInfo', routeData);


    assignin('base', 'gui_data', guiOut);    
    
    warndlg({'Settings are saved to workspace!'}, 'Warning!', 'modal');

end






% handles.cloud_totalDist = dst(end);
% handles.cloud_totalDur  = r.routes.duration;
% assignin('base', 'gui_rg_chosen_id', handles.rg_chosen_id);
% assignin('base', 'gui_wind_chosenindx', handles.rg_chosen_id);
% assignin('base', 'cloud_speed', spd)
% assignin('base', 'cloud_wind', wnd)
% assignin('base', 'cloud_grade', grd)
% assignin('base', 'gui_cloud_distance', dst)
% assignin('base', 'gui_cloud_speed', spd)
% assignin('base', 'gui_cloud_wind', wnd)
% assignin('base', 'gui_cloud_grade', grd)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fileName = hObject.String{hObject.Value};
disp(fileName);

validFileChosen = 0;
if ~strcmp(fileName, '')
   validFileChosen = 1; 
   disp('Valid File Chosen');
   
   handles.sp_constant_checkbox.Value = 0;
   handles.sp_sin_checkbox.Value = 0;
   handles.sp_nedc_checkbox.Value = 0;
   handles.sp_cloud_checkbox.Value = 0;
   handles.sp_file_checkbox.Value = 1;

   handles.sp_chosen_id = 5;
   
   handles.sp_file_type = 0;
   [val, raw, txt] = xlsread(['PredefinedRoutes/' fileName]);
   if strcmp(txt{1,1}, 'Distance')
       handles.sp_file_type = 1;
       handles.cloud_dst = val(:,1);
       handles.cloud_tim = zeros(length(handles.cloud_dst),1);
       handles.cloud_spd = val(:,2);
       handles.cloud_grd = zeros(size(handles.cloud_dst));
       handles.cloud_wnd = zeros(size(handles.cloud_dst));
       handles.cloud_totalDist = val(end,1);
       handles.cloud_totalDur  = 1e9;
       handles.cloud_stopdurations = [5,5,5,5,5];
       
       
       handles.distance_text.String = [num2str(val(end,1)/1000, '%.1f') ' KM'];
       handles.duration_text.String = 'Not Defined'; 
       
       axes(handles.axes2);
       plot(handles.cloud_dst/1000, handles.cloud_spd,'r', 'Linewidth',3)
       ylabel('Speed [kph]')
       xlabel('Dist [km]')
       
   elseif strcmp(txt{1,1}, 'Time')
       handles.sp_file_type = 2;
       handles.cloud_tim = val(:,1);
       handles.cloud_dst = zeros(length(handles.cloud_tim),1);
       handles.cloud_spd = val(:,2);
       handles.cloud_grd = zeros(size(handles.cloud_tim));
       handles.cloud_wnd = zeros(size(handles.cloud_tim));
       handles.cloud_totalDist = 1e9;
       handles.cloud_totalDur  = val(end,1);
       handles.cloud_stopdurations = [5,5,5,5,5];

       
       
       dur = val(end,1);
       durHR = floor(dur/3600);
       dur = dur - durHR*3600;
       durMIN = floor(dur/60);
       durSEC = dur - durMIN*60;       
       
       handles.distance_text.String = 'Not Defined'; 
       handles.duration_text.String = [num2str(durHR, '%02.0f') ':' num2str(durMIN, '%02.0f') ':' num2str(durSEC, '%02.0f')]; 
       
       axes(handles.axes2);
       plot(handles.cloud_tim, handles.cloud_spd,'r', 'Linewidth',3)
       ylabel('Speed [kph]')
       xlabel('Time [sec]')
       
   else
       warndlg({'File has wrong format. Make sure that the first row is consists of the headers and the first column of first row is either Distance or Time'}, 'Warning!', 'modal');
   end
   
end

guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

hObject.String = {''};
listing = dir('PredefinedRoutes');
for i=1:length(listing)
   if contains(listing(i).name,'.xlsx')
       hObject.String{end+1} = listing(i).name;
   end
end

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sp_constant_checkbox.
function sp_constant_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to sp_constant_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sp_constant_checkbox

if handles.sp_constant_checkbox.Value
   handles.sp_sin_checkbox.Value = 0;
   handles.sp_nedc_checkbox.Value = 0;
   handles.sp_cloud_checkbox.Value = 0;
   handles.sp_file_checkbox.Value = 0;
   
   handles.sp_chosen_id = 1;
else
   handles.sp_sin_checkbox.Value = 1;
   handles.sp_nedc_checkbox.Value = 0; 
   handles.sp_cloud_checkbox.Value = 0;
   handles.sp_file_checkbox.Value = 0;
   
   handles.rg_chosen_id = 2;
end

guidata(hObject,handles);


% --- Executes on button press in sp_sin_checkbox.
function sp_sin_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to sp_sin_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sp_sin_checkbox

if handles.sp_sin_checkbox.Value
   handles.sp_constant_checkbox.Value = 0;
   handles.sp_nedc_checkbox.Value = 0;
   handles.sp_cloud_checkbox.Value = 0;
   handles.sp_file_checkbox.Value = 0;
   
   handles.sp_chosen_id = 2;
else
   handles.sp_constant_checkbox.Value = 1;
   handles.sp_nedc_checkbox.Value = 0; 
   handles.sp_cloud_checkbox.Value = 0;
   handles.sp_file_checkbox.Value = 0;
   
   handles.rg_chosen_id = 1;
end

guidata(hObject,handles);


% --- Executes on button press in sp_nedc_checkbox.
function sp_nedc_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to sp_nedc_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sp_nedc_checkbox
if handles.sp_nedc_checkbox.Value
   handles.sp_constant_checkbox.Value = 0;
   handles.sp_sin_checkbox.Value = 0;
   handles.sp_cloud_checkbox.Value = 0;
   handles.sp_file_checkbox.Value = 0;
   
   handles.sp_chosen_id = 3;
else
   handles.sp_constant_checkbox.Value = 1;
   handles.sp_sin_checkbox.Value = 0; 
   handles.sp_cloud_checkbox.Value = 0;
   handles.sp_file_checkbox.Value = 0;
   
   handles.rg_chosen_id = 1;
end

guidata(hObject,handles);


% --- Executes on button press in sp_file_checkbox.
function sp_cloud_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to sp_file_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sp_file_checkbox
if handles.sp_cloud_checkbox.Value
   handles.sp_constant_checkbox.Value = 0;
   handles.sp_sin_checkbox.Value = 0;
   handles.sp_nedc_checkbox.Value = 0;
   handles.sp_file_checkbox.Value = 0;
   
   handles.sp_chosen_id = 4;
else
   handles.sp_constant_checkbox.Value = 1;
   handles.sp_sin_checkbox.Value = 0; 
   handles.sp_nedc_checkbox.Value = 0;
   handles.sp_file_checkbox.Value = 0;
   
   handles.rg_chosen_id = 1;
end

guidata(hObject,handles);


% --- Executes on button press in sp_cloud_checkbox.
function sp_file_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to sp_cloud_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sp_cloud_checkbox
if handles.sp_file_checkbox.Value
   handles.sp_constant_checkbox.Value = 0;
   handles.sp_sin_checkbox.Value = 0;
   handles.sp_nedc_checkbox.Value = 0;
   handles.sp_cloud_checkbox.Value = 0;
   
   handles.sp_chosen_id = 5;
else
   handles.sp_constant_checkbox.Value = 1;
   handles.sp_sin_checkbox.Value = 0; 
   handles.sp_nedc_checkbox.Value = 0;
   handles.sp_cloud_checkbox.Value = 0;
   
   handles.rg_chosen_id = 1;
end

guidata(hObject,handles);


% --- Executes on slider movement.
function sp_constant_slider_Callback(hObject, eventdata, handles)
% hObject    handle to sp_constant_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.sp_constant_checkbox.Value = 1;
handles.sp_sin_checkbox.Value = 0;
handles.sp_nedc_checkbox.Value = 0;
handles.sp_cloud_checkbox.Value = 0;
handles.sp_file_checkbox.Value = 0;

handles.sp_chosen_id = 1;

handles.sp_const_label.String= [num2str(hObject.Value, '%.0f') ' kph'];

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function sp_constant_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sp_constant_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sp_sin_per_slider_Callback(hObject, eventdata, handles)
% hObject    handle to sp_sin_per_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.sp_constant_checkbox.Value = 0;
handles.sp_sin_checkbox.Value = 1;
handles.sp_nedc_checkbox.Value = 0;
handles.sp_cloud_checkbox.Value = 0;
handles.sp_file_checkbox.Value = 0;

handles.sp_chosen_id = 2;

handles.sp_sin_per_text.String= [num2str(hObject.Value, '%.0f') ' m'];

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sp_sin_per_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sp_sin_per_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sp_sin_amp_slider_Callback(hObject, eventdata, handles)
% hObject    handle to sp_sin_amp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.sp_constant_checkbox.Value = 0;
handles.sp_sin_checkbox.Value = 1;
handles.sp_nedc_checkbox.Value = 0;
handles.sp_cloud_checkbox.Value = 0;
handles.sp_file_checkbox.Value = 0;

handles.sp_chosen_id = 2;

handles.sp_sin_amp_text.String= [num2str(hObject.Value, '%.0f') ' kph'];

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function sp_sin_amp_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sp_sin_amp_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
