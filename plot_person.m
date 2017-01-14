function plot_person(Dimension, handles)
% Written by Jerome Wynne
% Plots a life-size model of a person

%% INPUTS
% Dimension: Structure containing user inputs to GUI
% handles: Handles to GUI objects

%% FUNCTION
fv = stlread('person.stl');

y = fv.vertices(:, 2);
fv.vertices(:, 2) = fv.vertices(:, 3) + Dimension.wing_span./1.5;
fv.vertices(:, 3) = y - Dimension.wing_span./10;

handles.Assembly_axes;

patch(fv,'FaceColor',       'white', ...
         'EdgeColor',       [0.7 0.7 0.7]);
     
end