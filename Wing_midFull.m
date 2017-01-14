function [T, x, y, z] = Wing_midFull(wing_span, side, main_wing_NACA, taper)
% Written by Johan Crook
% Generates faces and vertices describing inner section of wings

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
%NACA aerofoil generator
iaf.designation=main_wing_NACA;
% designation='0008';
iaf.n=25;
iaf.HalfCosineSpacing=1;
iaf.wantFile=1;
iaf.datFilePath='./'; % Current folder
iaf.is_finiteTE=0;

af = naca4gen(iaf);

%define arrays in x, y and z
end_upper_z = size(af.zU, 1);  %defines final value of z array in NACA generator. used to allow me to identify tyhe last value of x array and find diffference betwwen 1st and last --> define midpoint
end_upper_x = size(af.xU, 1);  %defines final value of x array in NACA generator.

x = [af.xU; af.xL]; %combines upper and lower x values --> 1 array
z = [af.zU; af.zL]; %combines upper and lower x values --> 1 array
y = zeros(size(x)); %generates y array size of x with only zeros

L = wing_span/4;
W = wing_span/8;

y = [y; 0; L*ones(size(x)); L]; %defines y array on face y = 0 then adds another y array the size of x at distance L from 1st face (defines second cross-section face)

midpoint_z = (z(1)-z(end_upper_z))/2; %define midpoint of 1st and last z values
midpoint_x = (x(1)-x(end_upper_x))/2; %define midpoint of 1st and last x values

x = [x; midpoint_x;]; %adds x midpoint to x array so i can esily refeer to x coordinate of midpoint using "x(end)"
z = [z; midpoint_z;]; %adds midpoint to end of z array

np = size(x, 1); %defines scalar value for size of x array --> 

%duplicate x and z to allow gnereation of second surface
x(:,2) = x;
x = W*x; %adds another array of size x to end of x array, to allow generation of second face --> create depth of aerofoil
z(:,2) = z;
z = W*z; %duplicates z array. allows y=ones(size(x)) to correlate to x and z arrays to generate second aerofoil face


x(:,2) = x(:,2)*(W - taper*L)./W;
m1 = max(x(:,2));
m2 = max(x(:,1));
x(:,2) = x(:,2) + m2 - m1;
z(:,2) = z(:,2)*(W - taper*L)./W;

T = []; %creates empty array

for k = 1:np-2
    T = [T; k k+np k+1; k+1 k+np+1 k+np]; %creates points in T array for triangulation function for aerofoil surface
end

t=[]; %creates empty array

for k = 1:np-1
    t = [t;k k+1 np]; %creates points in T array for triangulation function for aerofoil cross-section face
end

t = [t; t+np]; %generates array of t for triangulation of end faces. "t + np" refers to points of t in elevated surface
T = [T; t]; %combines T and t arrays so i can use single variable in triangulation funtion
x = [x(:,1); x(:,2)];
z = [z(:,1); z(:,2)];
y = -y + max(y);

y = y - wing_span*9/32; % Position in prep. for assembly

if strcmp('right', side)
    y = -y;
end

end