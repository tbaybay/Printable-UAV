% Written by Jerome Wynne and Jordan Bellamy
% GUI for parametric 3D-printed UAV program
function varargout = GUIFinal(varargin)
%% Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIFinal_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIFinal_OutputFcn, ...
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
% End initialization code

function GUIFinal_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for GUIFinal
handles.output = hObject;

%Create tab group
handles.tgroup = uitabgroup('Parent', handles.figure1,'TabLocation', 'left');
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'Assembly');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'Fuselage');
handles.tab3 = uitab('Parent', handles.tgroup, 'Title', 'Front Wings');
handles.tab4 = uitab('Parent', handles.tgroup, 'Title', 'Tail Fin');
handles.tab5 = uitab('Parent', handles.tgroup, 'Title', 'Tail Wing');

%Place panels into each tab
set(handles.P1,'Parent',handles.tab1);
set(handles.P2,'Parent',handles.tab2);
set(handles.P3,'Parent',handles.tab3);
set(handles.P4,'Parent',handles.tab4);
set(handles.P5,'Parent',handles.tab5);

%Reposition each panel to same location as panel 1
set(handles.P2,'position',get(handles.P1,'position'));
set(handles.P3,'position',get(handles.P1,'position'));
set(handles.P4,'position',get(handles.P1,'position'));
set(handles.P5,'position',get(handles.P1,'position'));

view_mode = 0; % 0: UAV view is not exploded. 1: UAV view is exploded
assignin('base', 'view_mode', view_mode);

% Update handles structure
guidata(hObject, handles);


%% Callbacks for interaction elements
function varargout = GUIFinal_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function generate_button_Callback(hObject, eventdata, handles)
% Converts input parameters to data that can then be exported as .stl files
% Reset view mode
view_mode = 0; % 0: UAV view is not exploded. 1: UAV view is exploded
assignin('base', 'view_mode', view_mode);

% Capture parameter inputs from GUI in a structure
Dimensions = struct;
Dimensions.wing_span = str2double(char(get(handles.wing_span_input,'String')));
Dimensions.main_wing_NACA = get(handles.main_wing_NACA_input, 'String');
Dimensions.taper = str2double(get(handles.taper_input, 'String'));
    Dimensions.taper = Dimensions.taper(1);
Dimensions.dihedral = str2double(get(handles.dihedral_input, 'String'));
Dimensions.tail_height = str2double(get(handles.tail_height_input, 'String'));
Dimensions.elevator_span = str2double(get(handles.elevator_span_input, 'String'));
Dimensions.winglet = get(handles.winglets_button,'Value');
    contents = cellstr(get(handles.mode_box,'String'));
    selected_listbox_item = contents{get(handles.mode_box,'Value')};
Dimensions.winglet_mode = selected_listbox_item;
Dimensions.colour_mode = get(handles.colour_button, 'Value');
Dimensions.winglet_function = get(handles.function_edit_box, 'String');

% Check if the person's being displayed - if so, deactive the check box
set(handles.person_button, 'Value', 0);

% UAV contains all point and face data, Graphic the plots of each component
[UAV,Graphic] = Parametric_UAV(Dimensions, handles);

% Store these structures in the workspace so other functions can access
% them
assignin('base', 'UAV', UAV);
assignin('base', 'Graphic', Graphic);
assignin('base', 'Dimensions', Dimensions);

function write_stl_button_Callback(hObject, eventdata, handles)
% Exports the parts of the UAV to the local directory as .stl files
UAV = evalin('base', 'UAV;');
stlwrite('UAV_tail_fin.stl', UAV.tail_fin.T, [UAV.tail_fin.x UAV.tail_fin.y UAV.tail_fin.z]);
surf2stl('UAV_tail_wing_left.stl', UAV.tail_wing_left.x, UAV.tail_wing_left.y, UAV.tail_wing_left.z);
surf2stl('UAV_tail_wing_right.stl', UAV.tail_wing_right.x, UAV.tail_wing_right.y, UAV.tail_wing_right.z);
surf2stl('UAV_fuselage_front.stl', UAV.Fuselage_front.x, UAV.Fuselage_front.y, UAV.Fuselage_front.z);
surf2stl('UAV_fuselage_back.stl', UAV.Fuselage_back.x, UAV.Fuselage_back.y, UAV.Fuselage_back.z);
stlwrite('UAV_tail_connector.stl', UAV.tail_connector.T, [UAV.tail_connector.x UAV.tail_connector.y UAV.tail_connector.z]);
stlwrite('UAV_wing_tip_left.stl', UAV.wing_tip_left.T, [UAV.wing_tip_left.x UAV.wing_tip_left.y UAV.wing_tip_left.z]);
stlwrite('UAV_wing_tip_right.stl', UAV.wing_tip_right.T, [UAV.wing_tip_right.x UAV.wing_tip_right.y UAV.wing_tip_right.z]);
stlwrite('UAV_wing_midFull_left.stl', UAV.wing_midFull_left.T, [UAV.wing_midFull_left.x UAV.wing_midFull_left.y UAV.wing_midFull_left.z]);
stlwrite('UAV_wing_midFull_right.stl', UAV.wing_midFull_right.T, [UAV.wing_midFull_right.x UAV.wing_midFull_right.y UAV.wing_midFull_right.z]);
stlwrite('UAV_wing_midHalf.stl', UAV.wing_midHalf.T, [UAV.wing_midHalf.x UAV.wing_midHalf.x UAV.wing_midHalf.x]);
msgbox('.stl files successfully written.');

function explode_button_Callback(hObject, eventdata, handles)
% Plays explosion/assembly animation

wing_span = str2double(char(get(handles.wing_span_input,'String')));
colour_mode = get(handles.colour_button, 'Value');
assignin('base', 'wing_span', wing_span);
assignin('base', 'handles', handles);
assignin('base', 'colour_mode', colour_mode);
axes(handles.Assembly_axes);

if evalin('base', 'view_mode') == 0
    evalin('base', '[UAV Graphic] = explosion_animation(UAV, Graphic, wing_span, 1, handles, colour_mode);');
    view_mode = 1;
else
    evalin('base', '[UAV Graphic]= explosion_animation(UAV, Graphic, wing_span, 0, handles, colour_mode);');
    view_mode = 0;
end
assignin('base', 'view_mode', view_mode);

function clear_button_Callback(hObject, eventdata, handles)
% Clears all plots
axes(handles.Assembly_axes);
cla
axes(handles.fuselage_axes);
cla
axes(handles.tail_fin_axes);
cla
axes(handles.tail_wing_axes);
cla
axes(handles.front_wings_axes);
cla

% Uncheck boxes
set(handles.person_button, 'Value', 0);
set(handles.colour_button, 'Value', 0);

% Reset view mode
view_mode = 0; % 0: UAV view is not exploded. 1: UAV view is exploded
assignin('base', 'view_mode', view_mode);

function person_button_Callback(hObject, eventdata, handles)

visibility_state = get(hObject,'Value');
wing_span = evalin('base', 'Dimensions.wing_span;');

if visibility_state == 1
    % Read in person.stl model
    fv = stlread('person.stl');

    y = fv.vertices(:, 2);
    fv.vertices(:, 2) = (wing_span./1.8) - fv.vertices(:, 3);
    fv.vertices(:, 3) = y - 0.1*wing_span;
    fv.vertices(:, 1) = fv.vertices(:, 1) - 0.1*wing_span;

    axes(handles.Assembly_axes);

    p = patch(fv,'FaceColor',       'white', ...
             'EdgeColor',       [0.7 0.7 0.7]);
         
    assignin('base', 'p', p);
else
    p = evalin('base', 'p');
    delete(p);
end

%% Empty callbacks from here on out

function wing_span_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function figure1_SizeChangedFcn(hObject, eventdata, handles)

function main_wing_NACA_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function taper_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dihedral_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tail_height_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function elevator_span_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function winglets_button_Callback(hObject, eventdata, handles)

function mode_box_Callback(hObject, eventdata, handles)

function mode_box_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function colour_button_Callback(hObject, eventdata, handles)

function tail_height_input_Callback(hObject, eventdata, handles)

function dihedral_input_Callback(hObject, eventdata, handles)

function taper_input_Callback(hObject, eventdata, handles)

function wing_span_input_Callback(hObject, eventdata, handles)

function main_wing_NACA_input_Callback(hObject, eventdata, handles)

function elevator_span_input_Callback(hObject, eventdata, handles)



function function_edit_box_Callback(hObject, eventdata, handles)
% hObject    handle to function_edit_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of function_edit_box as text
%        str2double(get(hObject,'String')) returns contents of function_edit_box as a double


% --- Executes during object creation, after setting all properties.
function function_edit_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to function_edit_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
