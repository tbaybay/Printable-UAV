function [T x y z] = Wing_midHalf(scale_factor, NACA_value)
% Written by Johan Crook
% Generates faces and vertices describing center section of wings
% Attaches to top of fuselage-wing connector

%% INPUTS
% wing_span: Wing span of UAV, used to scale part
% side: Which side of the UAV the wing is for, viewed from tail to nose
% main_wing_NACA: What NACA value the wing should have
% taper: The decimal gradient of wing taper (span/chord)
%
%% OUTPUTS
% T: Nx3 matrix of faces (triangulations)
% x, y, z: Column vector of vertex ordinates

%%FUNCTION

iaf.designation=NACA_value;
iaf.n=25;
iaf.HalfCosineSpacing=1;
iaf.wantFile=1;
iaf.datFilePath='./'; % Current folder
iaf.is_finiteTE=0;

af = naca4gen(iaf);

end_upper_z = size(af.zU, 1);
end_upper_x = size(af.xU, 1);

x = [af.xU; af.xC];
z = [af.zU; af.zC];
y = zeros(size(x));


L = scale_factor/16;
W = scale_factor/8;
y = [y; 0; L*ones(size(x)); L];
y = y - 0.5*L;

midpoint_z = (z(1)-z(end_upper_z))/2;
midpoint_x = (x(1)-x(end_upper_x))/2;

x = [x; midpoint_x;];

np = size(x, 1);

x = W*[x; x];
z = [z; midpoint_z;];
z = W*[z; z];

T = [];

for k = 1:np-1
    T = [T; k k+1 k+np; k+1 k+np k+np+1];
end

t = [];

for k = 1:np-1
   t = [t;k np k+1]; 
end

t = [t; t+np];
T = [T; t];
end