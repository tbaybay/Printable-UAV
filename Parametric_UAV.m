function [UAV, Graphic] =  Parametric_UAV(Dimensions, handles);
% Written by Jerome Wynne
% Generates the data (faces and vertices) for, and plots, a UAV

%% INPUTS
% Dimensions: Structure from GUI containing parameter inputs
% handles: Handles for all objects in GUI
%% OUTPUTS
% UAV: Structure of faces and vertices describing UAV components
% Graphic: Structure containing handles to plots

%% FUNCTION
UAV = struct;

%% Input verification using regular expressions
if regexp(Dimensions.main_wing_NACA, '^[^A-Za-z\W]{4}$') == 1; % 4-digit number only
else
    msgbox('Please enter a valid 4-digit NACA value.');
    error('Please enter a valid 4-digit NACA value.');
end

if regexp(int2str(Dimensions.wing_span), '[\d]+') == 1
    if int2str(Dimensions.wing_span) < 0
        msgbox('Please enter a valid wing span.');
        error('Please enter a valid wing span.');
    end
    % ^ A positive number only
else
    msgbox('Please enter a valid wing span.');
    error('Please enter a valid wing span.');
end

if (Dimensions.wing_span/8) - Dimensions.taper*(Dimensions.wing_span*15/32) < 0
    % ^ A taper that does not cause the wing to self-intersect
    msgbox(sprintf('Unable to create main wings - Dimensions.taper would create self-intersecting geometry. \nPlease enter a smaller Dimensions.taper value (0 - 0.265).'));
    error('Unable to create main wings - Dimensions.taper would create self-intersecting geometry');
end

if strcmp(Dimensions.main_wing_NACA, '9999') % Easter egg #1
    sound_da_police(); % Reads and plays sound clip
end

%% Encapsulation of each part's data in a structure for the whole UAV
% Wings
[UAV.wing_tip_left.T UAV.wing_tip_left.x UAV.wing_tip_left.y UAV.wing_tip_left.z] = ...
    Wing_tip(Dimensions, 'left');
[UAV.wing_tip_right.T UAV.wing_tip_right.x UAV.wing_tip_right.y UAV.wing_tip_right.z]= ...
    Wing_tip(Dimensions, 'right');
[UAV.wing_midFull_left.T UAV.wing_midFull_left.x UAV.wing_midFull_left.y UAV.wing_midFull_left.z] = ...
    Wing_midFull(Dimensions.wing_span, 'left', Dimensions.main_wing_NACA, Dimensions.taper);
[UAV.wing_midFull_right.T UAV.wing_midFull_right.x UAV.wing_midFull_right.y UAV.wing_midFull_right.z] = ...
    Wing_midFull(Dimensions.wing_span, 'right', Dimensions.main_wing_NACA, Dimensions.taper);
[UAV.wing_midHalf.T UAV.wing_midHalf.x, UAV.wing_midHalf.y UAV.wing_midHalf.z] = ...
    Wing_midHalf(Dimensions.wing_span, Dimensions.main_wing_NACA);

% Fuselage
[UAV.Fuselage_wing_interface.T, UAV.Fuselage_wing_interface.x, UAV.Fuselage_wing_interface.y, UAV.Fuselage_wing_interface.z] =...
    Fuselage_wing_interface(Dimensions.wing_span);
[UAV.tail_connector.T, UAV.tail_connector.y, UAV.tail_connector.z, UAV.tail_connector.x] = ...
    Tail_connector(Dimensions.wing_span, 0,0,0);
[UAV.Fuselage_front.x, UAV.Fuselage_front.y, UAV.Fuselage_front.z] = ...
    Fuselage_body(Dimensions.wing_span);
[UAV.Fuselage_back.x, UAV.Fuselage_back.y, UAV.Fuselage_back.z] = ...
    Fuselage_tail(Dimensions.wing_span);
    %fuselage_rear_mr(Dimensions.wing_span, 20, 40); % Fuselage function
    %with motor-sizing capacity

% Tail
[UAV.tail_wing_left.x, UAV.tail_wing_left.y, UAV.tail_wing_left.z] = ...
    Tail_wing(Dimensions.wing_span, 'left', Dimensions.elevator_span);
[UAV.tail_wing_right.x, UAV.tail_wing_right.y, UAV.tail_wing_right.z] = ...
    Tail_wing(Dimensions.wing_span, 'right', Dimensions.elevator_span);
[UAV.tail_fin.T, UAV.tail_fin.x, UAV.tail_fin.z, UAV.tail_fin.y] = ...
    Tail_fin(Dimensions.wing_span, '12', Dimensions.tail_height);

%% Plot the parts to the GUI and store handles to those plots in Graphic
Graphic = draw_UAV(UAV, handles, Dimensions.colour_mode);

end
