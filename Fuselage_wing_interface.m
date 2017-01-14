function [T, y, x, z] = Fuselage_wing_interface(scale_factor)
% Written by Val Ismaiili
% Generates face and vertex data for the block connecting the fuselage to
% the wings

%% INPUTS
% scale_factor: Wing_span, used to scale block
%% OUTPUTS
% T: Nx3 matrix of faces (triangulations)
% x, y, z: Column vector of vertex ordinates

% define side lengths- in reality input conditions will be determined on
% scale desired by user
w = scale_factor/32; % Diameter of block, span-wise
d = scale_factor/18; % Chord length
h = scale_factor/100;

% define cube vertices
x = [-2 6 6 -2 -2 6 6 -2 1 1 3 3 1 1 3 3 0 0 4 4 4 4 0 0]*w/4;
y = [0 0 1 1 0 0 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1]*d;
z = [0 0 0 0 2 2 2 2 0 0 0 0 -5.65 -5.65 -5.65 -5.65 -5.65 -5.65 -5.65 -5.65 -6.85 -6.85 -6.85 -6.85]*h/3;
x = x - w/2;
z = z - h*2/3;


% form matrix selecting points of cube by specifying column numbers of as
% yet undefined matrix
T = [1 2 5; 1 4 5; 4 5 8; 2 5 6; 5 6 7; 5 7 8; 2 3 6; 3 6 7; 3 4 7; 4 7 8; 1 4 9; 2 11 12; 4 9 10; 2 3 12; 9 10 13; 10 13 14; 11 12 15; 12 15 16; 14 17 18; 13 14 17; 16 19 20; 15 16 19; 19 20 21; 20 21 22; 18 23 24; 17 18 23; 22 23 24; 21 22 23; 9 13 15; 9 11 15; 17 21 23; 17 19 21; 18 20 22; 18 22 24; 10 12 16; 10 14 16];
%T = [a b a+4; a a+4 b+4]

end