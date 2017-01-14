function [UAV, Graphic] = explosion_animation(UAV, Graphic, wing_span, mode, handles, colour_mode)
% Written by Jerome Wynne
% Animation between exploded and assembled view
% Returns updated UAV data and plots

%% INPUTS (inc. OUTPUTS)
% UAV: Structure of faces and vertices describing UAV components
% handles: Handles for all objects in GUI
% colour_mode: 1 = coloured, 0 = black and white
% mode: Explosion mode (Explode or assemble)
% wing_span: Wing_span of UAV. Used to scale velocities.
% Graphic: Structure containing handles to plots

%% FUNCTION
set(handles.explode_button, 'Enable', 'off'); % Prevents user from calling animation again

dt = 0.01; % Pseudo-time increment for animation
exaggeration = 10; % Determines magnitude of explosion

axes(handles.Assembly_axes);
pause(0.5); % Gives the RAM time to dump stuff from previous operations - allows loop to start smoothly

for t = 0:0.01:0.3
    % Clear previous plots
    delete(Graphic.tm1);
    delete(Graphic.tm2);
    delete(Graphic.tm3);
    delete(Graphic.tm4);
    delete(Graphic.tm10);
    delete(Graphic.tm11);
    delete(Graphic.tm8);
    delete(Graphic.tm5);
    delete(Graphic.tm12);
    
    % Calculate velocity
    v = exaggeration*(1 - exp(t-0.3));
    if mode == 1 % Explosion animation
    else
        v = -v; % Collapse animation
    end
    % Calculate new positions
    UAV.wing_tip_left.y = UAV.wing_tip_left.y - v*dt*wing_span/2;
    UAV.wing_midFull_right.y = UAV.wing_midFull_right.y + v*dt*wing_span/4;
    UAV.wing_midFull_left.y = UAV.wing_midFull_left.y - v*dt*wing_span/4;
    UAV.wing_tip_right.y = UAV.wing_tip_right.y + v*dt*wing_span/2;
    UAV.tail_wing_right.y = UAV.tail_wing_right.y + v*dt*wing_span/2;
    UAV.tail_wing_left.y = UAV.tail_wing_left.y - v*dt*wing_span/2;
    UAV.Fuselage_front.x = UAV.Fuselage_front.x - v*dt*wing_span/4;
    UAV.wing_midHalf.z = UAV.wing_midHalf.z + v*dt*wing_span/5;
    UAV.tail_fin.z = UAV.tail_fin.z + v*dt*wing_span/5;
    
    % Plot components in new positions
    Graphic.tm1 = trimesh(UAV.wing_tip_left.T, UAV.wing_tip_left.x, UAV.wing_tip_left.y, UAV.wing_tip_left.z);
    Graphic.tm2 = trimesh(UAV.wing_tip_right.T, UAV.wing_tip_right.x, UAV.wing_tip_right.y, UAV.wing_tip_right.z);
    Graphic.tm3 = trimesh(UAV.wing_midFull_right.T, UAV.wing_midFull_right.x, UAV.wing_midFull_right.y, UAV.wing_midFull_right.z);
    Graphic.tm4 = trimesh(UAV.wing_midFull_left.T, UAV.wing_midFull_left.x, UAV.wing_midFull_left.y, UAV.wing_midFull_left.z);
    Graphic.tm10 = surf(UAV.tail_wing_left.x, UAV.tail_wing_left.y, UAV.tail_wing_left.z);
    Graphic.tm11 = surf(UAV.tail_wing_right.x, UAV.tail_wing_right.y, UAV.tail_wing_right.z);
    Graphic.tm8 = surf(UAV.Fuselage_front.x, UAV.Fuselage_front.y, UAV.Fuselage_front.z);
    Graphic.tm5 = trimesh(UAV.wing_midHalf.T, UAV.wing_midHalf.x, UAV.wing_midHalf.y, UAV.wing_midHalf.z);
    Graphic.tm12 = trimesh(UAV.tail_fin.T, UAV.tail_fin.x, UAV.tail_fin.y, UAV.tail_fin.z);
    
    % Colour plots
    if colour_mode == 0
        set([Graphic.tm5 Graphic.tm12 Graphic.tm1 Graphic.tm2 Graphic.tm3 Graphic.tm4 Graphic.tm10 Graphic.tm11 Graphic.tm8], 'FaceColor', 'white', 'EdgeColor', 'black');
    else
        colormap jet
    end
    
    pause(0.05);
end

set(handles.explode_button, 'Enable', 'on');

end