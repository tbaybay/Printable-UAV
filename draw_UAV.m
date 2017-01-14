function Graphic = draw_UAV(UAV, handles, colour_mode)
% Written by Jerome Wynne
% Plots and shades the UAV triangulations

%% INPUTS
% UAV: Structure of faces and vertices describing UAV components
% handles: GUI object handles
% colour_mode: 1 = coloured, 0 = black and white
%% OUTPUTS
% Graphic: Structure containing handles to plots

%% FUNCTION
%% Plot assembly figure
axes(handles.Assembly_axes);
set(gcf, 'GraphicsSmoothing', 'off'); % Counter-intuitively, the plot looks slightly better with smoothing off
cla
axis image
hold on
view(3);

Graphic = struct;
Graphic.tm1 = trimesh(UAV.wing_tip_left.T, UAV.wing_tip_left.x, UAV.wing_tip_left.y, UAV.wing_tip_left.z);
Graphic.tm2 = trimesh(UAV.wing_tip_right.T, UAV.wing_tip_right.x, UAV.wing_tip_right.y, UAV.wing_tip_right.z);
Graphic.tm3 = trimesh(UAV.wing_midFull_right.T, UAV.wing_midFull_right.x, UAV.wing_midFull_right.y, UAV.wing_midFull_right.z);
Graphic.tm4 = trimesh(UAV.wing_midFull_left.T, UAV.wing_midFull_left.x, UAV.wing_midFull_left.y, UAV.wing_midFull_left.z);
Graphic.tm5 = trimesh(UAV.wing_midHalf.T, UAV.wing_midHalf.x, UAV.wing_midHalf.y, UAV.wing_midHalf.z);
Graphic.tm6 = trimesh(UAV.Fuselage_wing_interface.T, UAV.Fuselage_wing_interface.x, UAV.Fuselage_wing_interface.y, UAV.Fuselage_wing_interface.z);
Graphic.tm8 = surf(UAV.Fuselage_front.x, UAV.Fuselage_front.y, UAV.Fuselage_front.z);
Graphic.tm7 = surf(UAV.Fuselage_back.x, UAV.Fuselage_back.y, UAV.Fuselage_back.z);
Graphic.tm9 = trimesh(UAV.tail_connector.T, UAV.tail_connector.x, UAV.tail_connector.y, UAV.tail_connector.z);
Graphic.tm10 = surf(UAV.tail_wing_left.x, UAV.tail_wing_left.y, UAV.tail_wing_left.z);
Graphic.tm11 = surf(UAV.tail_wing_right.x, UAV.tail_wing_right.y, UAV.tail_wing_right.z);
Graphic.tm12 = trimesh(UAV.tail_fin.T, UAV.tail_fin.x, UAV.tail_fin.y, UAV.tail_fin.z);

if colour_mode == 0
    for k=1:12
        str_field = strcat('tm',int2str(k));
        set(Graphic.(str_field), 'FaceColor', 'white', 'EdgeColor', 'black');
    end
else

    colormap jet
        
end
%% Plot figure in fuselage tab
axes(handles.fuselage_axes);
cla
axis equal
view(3);
hold on
g.p1 = trimesh(UAV.Fuselage_wing_interface.T, UAV.Fuselage_wing_interface.x, UAV.Fuselage_wing_interface.y, UAV.Fuselage_wing_interface.z);
g.p2 = surf(UAV.Fuselage_front.x, UAV.Fuselage_front.y, UAV.Fuselage_front.z);
g.p3 = surf(UAV.Fuselage_back.x, UAV.Fuselage_back.y, UAV.Fuselage_back.z);
g.p4 = trimesh(UAV.tail_connector.T, UAV.tail_connector.x, UAV.tail_connector.y, UAV.tail_connector.z);

for k=1:4
    str_field = strcat('p',int2str(k));
    set(g.(str_field), 'FaceColor', 'white', 'EdgeColor', [0.05 0.3 0]);
end

%% Plot figure in tail fin tab
axes(handles.tail_fin_axes);
cla
axis equal
hold on
view(0, 0);
s = trimesh(UAV.tail_fin.T, UAV.tail_fin.x, UAV.tail_fin.y, UAV.tail_fin.z);
set(s, 'EdgeColor', [0.4 0 0.4], 'FaceColor', 'white');

%% Plot figure in tail wing tab
axes(handles.tail_wing_axes);
cla
axis equal
hold on
view(-45, 24);
s = surf(UAV.tail_wing_right.x, UAV.tail_wing_right.y, UAV.tail_wing_right.z);    
set(s, 'EdgeColor', [0 0.4 0.4], 'FaceColor', 'white');

%% Plot figure in front wings tab
axes(handles.front_wings_axes);
cla
axis equal
hold on
view(0, 90);
g.p1 = trimesh(UAV.wing_tip_left.T, UAV.wing_tip_left.x, UAV.wing_tip_left.y, UAV.wing_tip_left.z);
g.p2 = trimesh(UAV.wing_tip_right.T, UAV.wing_tip_right.x, UAV.wing_tip_right.y, UAV.wing_tip_right.z);
g.p3 = trimesh(UAV.wing_midFull_right.T, UAV.wing_midFull_right.x, UAV.wing_midFull_right.y, UAV.wing_midFull_right.z);
g.p4 = trimesh(UAV.wing_midFull_left.T, UAV.wing_midFull_left.x, UAV.wing_midFull_left.y, UAV.wing_midFull_left.z);
g.p5 = trimesh(UAV.wing_midHalf.T, UAV.wing_midHalf.x, UAV.wing_midHalf.y, UAV.wing_midHalf.z);

for k=1:5
    str_field = strcat('p',int2str(k));
    set(g.(str_field), 'FaceColor', 'white', 'EdgeColor', [0.1 0.1 0.5]);
end

end