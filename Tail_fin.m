function [T, x, y, z] = Tail_fin(wing_span, naca_value, height)
% Written by Jerome Wynne
% Generates faces and vertices describing the tail fin.

%% INPUTS
% wing_span: Wing span of UAV. Used to scale component.
% naca_value: NACA aerofoil value for fin.
% height: Tail fin height.
%% OUTPUTS
% T: Nx3 matrix of faces (triangulations)
% x, y, z: Column vector of vertex ordinates

%% FUNCTION
%% Calculate fin dimensions from scale factor
terminus_width = wing_span*0.01;
origin_width = wing_span*0.08;

%% Create a NACA aerofoil
    iaf.designation=strcat('00',naca_value);
    iaf.n=60;
    iaf.HalfCosineSpacing=1;
    iaf.wantFile=1;
    iaf.datFilePath='./'; % Current folder
    iaf.is_finiteTE=0;

    af = naca4gen(iaf);


%% Break the NACA aerofoil into two sections - flap and front
front_fractn = 0.55;
pts_front = round(front_fractn.*size(af.xU, 1));
pts_flap = size(af.xU, 1) - pts_front;

% Create x, z matrices of points containing the front of the aerofoil
xf = [af.xU(pts_flap+1:end); af.xL(1:pts_front)];
zf = [af.zU(pts_flap+1:end); af.zL(1:pts_front)];

points_fore = size(xf, 1); % Number of points in the non-flap part of the aerofoil
points_rear = size([af.xU(1:pts_flap); af.xL(pts_front+1:end)], 1); % Number of points in the rear section

x = [xf; af.xU(1:pts_flap); af.xL(pts_front+1:end)]; % Add the rear portion of the aerofoil to our x, z matrices
z = [zf; af.zU(1:pts_flap); af.zL(pts_front+1:end)];

%% Extrude the aerofoil into three dimensions
levels = 50; % Number of levels of points the constitute the fin - the higher the number, the smoother the profile
tp = points_fore+points_rear; % Number of points in a complete cross-section

% create y-coordinates for each level
y = linspace(0,height,levels);
y = repmat(y, size(x,1), 1);

% replicate z and x coordinates for each level
x = repmat(x, 1, levels);
z = repmat(z, 1, levels);

% Ensure that terminus width is correct using this constant
k = -(1./y(end)).*log(terminus_width./origin_width);

% Scale aerofoils
phi = origin_width.*exp(-k.*y);
x = x.*phi;
z = z.*phi;

%% Transform each level to its correct position to give slanted tailfin
gradient_of_rear_edge = 0.3; % dz/dx
x_rear_edge = y(1,:).*gradient_of_rear_edge; % Describes linear rear taper of fin
fb_af_x = max(x); % Furthest back point on each level

translation_o = fb_af_x - x_rear_edge;
x = x - repmat(translation_o,size(x,1),1);
 
%% Create faces between each level
% Note that a level is each set of cross-section aerofoil points
T = [];
for c = 0:levels-2
    % Faces for the front part
    for k=1:points_fore-1
        t = [k k+tp k+1; k+tp+1 k+1 k+tp]; % Two triangles between this and the next level
            if k == points_fore-1 % If at the last point on the fin's front section
                % Create the triangle between the first and last point describing the front
                t = [t; k+1 k+2+points_rear 1; points_fore k+1+tp k+2+points_rear]; 
            end
        T = [T; t+(c*tp)]; % Make those triangles connect level c to level c+1
    end
     
    % Faces for the flap
    for k = points_fore+1:tp-1
        t = [k+1 k k+tp; k+1 k+tp k+tp+1];
        T = [T; t+(tp.*c)];
    end
end

ls = [0:levels-2];

%% Create faces on the top and bottom of the fin, for both the front part
% and the flap
xm = face_centre(x, [1 levels], points_fore); % Face centre determines the mid-point of a face
x = [x(:); xm(:, 1); xm(:,2)]; % [x; mp_front_bottom; mp_front_top; mp_flap_bottom; mp_flap_top]
y = [y(:); 0; height; 0; height];
z = [z(:); 0; 0; 0; 0];
cp = size(x,1);

% Bottom flap face
    for k = points_fore+1:tp-1
        T = [T; k k+1 cp-1];
    end
    T = [T; points_fore+1 tp cp-1];
    
% Top front face
    for k = ((levels-1)*tp)+1:((levels-1)*tp)+points_fore-1
            T = [T; k+1 k cp-2];
    end
    T = [T; ((levels-1).*tp)+1 ((levels-1)*tp)+points_fore cp-2];
    
% Top flap face
    for k = ((levels-1)*tp)+points_fore:(levels*tp)-1
            T = [T; k+1 k cp];
    end
    T = [T; (levels*tp) ((levels-1)*tp)+points_fore cp];

%% Cylindrical connector dimensions and points
con_res = 30;
con_length = wing_span*0.004;
rad_con = wing_span*0.0014;
rad_con = repmat(rad_con, 1, con_res);
th_con = linspace(-pi, pi, con_res);
[x_con, z_con] = pol2cart(th_con, rad_con);
y_con = zeros(size(x_con));
y_con = [ y_con -con_length*ones(size(y_con)) -con_length];
x_con = [x_con x_con 0];
z_con = [z_con z_con 0];

% Vectorised triangulation of the connector's circumference and top
ps = [1:(con_res-1)]'; % Point stack 
t_con = [ps ps+1 ps+con_res; ps+con_res ps+1 ps+con_res+1; ...
        ps+con_res ps+1+con_res (2*con_res*ones(size(ps)))+1];

%% Triangulating between the font of the aerofoil's base and the connector
max_camber_ss = find(af.z == max(af.z));
[aero_bound_th, aero_bound_r] = cart2pol(xf - af.x(max_camber_ss), zf); 

p1_last = [];
for k = 1:size(aero_bound_th,1)-1
    difference = abs((aero_bound_th(k)) - th_con);
    p1 = find(difference == min(difference));
    T = [T; k k+1 p1(1)+cp];
     if k~=1
         if p1 ~= p1_last(1)
             T = [T; p1(1)+cp p1_last+cp k];
         end
     end
    p1_last = p1(1);
end
T = [T; 1 cp+p1(1) points_fore; cp+p1(1)+1 cp+p1(1) 1];

x_con = x_con + xm(1);

% Flip face normals so that it prints properly
T = [T; t_con+cp];
T_1 = T(:,1);
T(:,1) = T(:, 2);
T(:,2) = T_1;

x = [x; x_con'];
y = [y; y_con'];
z = [z; z_con'];

%% Position for assembly
x = x + wing_span*0.4069;
y = y - 0.052*wing_span;

end