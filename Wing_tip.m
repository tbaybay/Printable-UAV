function [T, x, y, z] = Wing_tip(Dimensions, side)
% Written by Alex Tross-Youle, Emma Milner, and Jerome Wynne
% Generates face and vertex data for wing tip of the UAV

%% INPUTS
% Dimensions: Structure from GUI containing parameter inputs
% side: Which side of the UAV the wing tip is for, looking from tail
% towards the nos
%% OUTPUTS
% T: Nx3 matrix of faces (triangulations)
% x, y, z: Column vector of vertex ordinates

%% FUNCTION
%% Create an input for the NACA aerofoil generator
iaf.designation=Dimensions.main_wing_NACA;
iaf.n=60;
iaf.HalfCosineSpacing=1;
iaf.wantFile=1;
iaf.datFilePath='./'; % Current folder
iaf.is_finiteTE=0;

af = naca4gen(iaf);

%% Specify aerofoil dimensions
length = Dimensions.wing_span*7/32;
terminus_width = Dimensions.wing_span/8 - Dimensions.taper*Dimensions.wing_span/4;
if terminus_width == 0
    terminus_width = Dimensions.wing_span/8;
end
levels = 30;
winglet_length = length*0.15; 
winglet_alpha = 80; % winglet angle

%% Specifying the points that describe the wing
% Create x and z matrices containing points describing aerofoil
x = af.x;
z = af.z;

% Get the number of points in one level
np= size(x, 1);

% Create y-coordinates for each level
y = linspace(0,length,levels);
y = repmat(y, size(x,1), 1);

% Replicate z and x coordinates for each level
x = repmat(x, 1, levels);
z = repmat(z, 1, levels);

%% Scale and transform aerofoils according to taper
x = x.*(terminus_width - Dimensions.taper*y);
max_x = max(x);
diff = max(max_x) - max_x;
if Dimensions.taper < 0
    diff = zeros(size(diff));
end
x = x + repmat(diff, size(x,1), 1);
z = z.*(terminus_width - Dimensions.taper*y);

% Add tip and base mid-point coordinates to our matrices so that faces can
% be triangulated
xm = face_centre(x, [1 levels], np); % A function I wrote to figure out the mid point of aerofoils automatically
x = [x(:); xm(1); xm(2)]; % Stick the x mid-points coordinates onto the end of our existing x matrix
y = [y(:); 0; length;]; % Stick the y mid-points coordinates onto the end of our existing x matrix - these are the base and tip y values
z = [z(:); 0; 0;];
cp = size(x,1); % Get the size of our complete matrix of points

%% Create the triangles describing the wing's faces
T = [];
% Create the faces around the wing's edges
for c = 0:levels-2
    for k=1:np-1
        t = [k k+1 k+np; k+1 k+np+1 k+np];
        T = [T; t+(c*np)];
    end
end

% Create the faces at the tip and base of the wing
for k=1:np-1
    T = [T; k k+1 cp-1; cp-2-k cp-1-k cp];
end
T = [T; 1 np cp-1; cp-1-np cp-2 cp];

%% Winglet
% Does the user want a winglet?
if Dimensions.winglet_mode == 1
    winglet_ss = find(y >= length - winglet_length);
    b1 = y((iaf.n.*2)+2) - y((iaf.n.*2)+1); %Pinpoints step size
    b2 = b1*cosd(winglet_alpha); %works out required length in y axis to maintain correct magnitude of wingtip
    b = b1 - abs(b2); %difference needed
    f=(y(winglet_ss)-y(winglet_ss(1) - 1))/b1;
    y(winglet_ss) = y(winglet_ss) - f*b; %This needs to occur every step to reduce the winglet length???
    z(winglet_ss) = z(winglet_ss) + tand(winglet_alpha).*(y(winglet_ss) - (length-winglet_length-b));
    z(winglet_ss) = z(winglet_ss) - z(min(winglet_ss));
end

%% Apply dihedral angle
% Normalise winglet length for selected Dimensions.dihedral angle
z = z + (tand(Dimensions.dihedral).*y.*cosd(Dimensions.dihedral));
x_function_trans_factor = 0;

%% Make GUI mode-related adjustments
% Check if user has specified their own function
if regexp(Dimensions.winglet_function, '^[k(\s)=].+') == 1;
    start_of_expression = regexp(Dimensions.winglet_function, '=');
    expression_input = Dimensions.winglet_function((start_of_expression+1):end)
    x_function_trans_factor = eval(expression_input);
else
    if strcmp('Wavey', Dimensions.winglet_mode)
        full_circle_y = 2.*pi.*y./max(y); % Maps the y values between 0 and 2 pi
        x_function_trans_factor = sin(full_circle_y)*Dimensions.wing_span./32;
    elseif strcmp('Linear', Dimensions.winglet_mode)
    elseif strcmp('Quadratic', Dimensions.winglet_mode)
        n_y = y/max(y);
        x_function_trans_factor = (n_y.^2)*Dimensions.wing_span./16;
    end

end

%% Position for assembly
x = x - terminus_width + x_function_trans_factor + Dimensions.wing_span/8;
y = y + Dimensions.wing_span*9./32;
if strcmp(side, 'left')
    y = -y;
end
    
end
