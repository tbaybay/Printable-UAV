function TF = holierThanThou(a, b, Tailfin, py, pz, radius, res)
% a is first face [i j k l] vector, where [i j k l] defines the face as you
% would draw it 
%
%       i-------j
%       |       |
%       |       |
%       l-------k
% b is the second face, defined in the same way as a
% Tailfin is a structure containing the existing object triangulation T, x
% coords x, y coords y, z coord z, and the number of points per level (in z-direction) np
% py and pz specify the position of the hole
% radius specifies the hole radius
% res specifies the number of points in the circles bounding the hole

% Good luck


% Remove faces associated with hole - if the function is being funny, change the
% order of the arguments cyclically (i.e. the order of the face indices)
Tr = [a(2) a(1) a(3); a(3) a(4) a(1)];
Tailfin.T = Remove_triangulation(Tailfin.T, Tr);

Tr = [b(1) b(2) b(4); b(4) b(3) b(2)];
Tailfin.T = Remove_triangulation(Tailfin.T, Tr);

% Create the hole
% Specify face coordinate subscripts
face1_ss = [a(1) a(2) a(3) a(4)]; % Have to be defined cyclically this such that barreling works later
face2_ss = [b(1) b(2) b(3) b(4)];

% Get the subscript of where the circles begin - it'll come in handy later
fhs = length(Tailfin.x)+1;

cx_pos = Tailfin.x(face1_ss(2));

position_y = py;
position_z = radius + pz;

cy_pos = Tailfin.y(face1_ss(1)) + position_y; % Position the hole relative to the first point specified on the first face
cz_pos = Tailfin.z(face1_ss(1)) + position_z;

% Create a half circle
yc = linspace(-radius, radius, res);
xc = min(Tailfin.x(face1_ss)).*ones(size(yc));
zc = sqrt(radius^2 - yc.^2);

% Turn that half circle into a full circl
yc = [fliplr(yc) yc];
zc = [zc -zc];
xc = [xc xc];

% Move that circle to the center of the face
zc = zc + cz_pos;
yc = yc + cy_pos;

% Append the circle to the other x, y, z coordinate vectors, and create
% another hole at the same y and z coordinates on the other x-face
Tailfin.x = [Tailfin.x xc xc+(Tailfin.x(face2_ss(1)) - Tailfin.x(face1_ss(1)))]; 
Tailfin.y = [Tailfin.y yc yc];
Tailfin.z = [Tailfin.z zc zc];


% Triangulate the result
corner = 4;

for k=fhs:fhs+(4*res)-1
    % First face
            % Corners
            if k-fhs < res*2-1 && k-fhs ~= res/2 && k-fhs ~= res && k-fhs ~= res*3/2
                 Tailfin.T = [Tailfin.T; face1_ss(corner) k k+1];
            % Connections
            elseif k-fhs == res/2 || k-fhs == res || k-fhs == res*3/2 || k-fhs == 2*res-1
                if k-fhs == 2*res-1 % Final connection
                    Tailfin.T = [Tailfin.T; k face1_ss(1) face1_ss(4)];
                    corner = 4;
                else % All other connections
                    Tailfin.T = [Tailfin.T; k face1_ss(corner-1) face1_ss(corner); face1_ss(corner-1) k k+1];
                    corner = corner-1;
                end
            end
     % Second face
            % Corners
            if k-fhs > 2*res-1 && k-fhs ~= 4*res-1 && k-fhs ~= (2*res)+ res/2 && ...
                            k-fhs ~= (2*res)+ res && k-fhs ~= (2*res)+ 1.5*res  
                 Tailfin.T = [Tailfin.T; face2_ss(corner) k k+1];
            % Connections
            elseif k-fhs == 4*res-1 || k-fhs == (2*res)+ res/2 || ...
                            k-fhs == (2*res)+ res || k-fhs == (2*res)+ 1.5*res  
                if k-fhs == 4*res-1
                    Tailfin.T = [Tailfin.T; k face2_ss(1) face2_ss(4)]; % Final connection
                else
                    Tailfin.T = [Tailfin.T; k face2_ss(corner-1) face2_ss(corner); face2_ss(corner-1) k k+1]; % All other connections
                    corner = corner - 1;
                end
            end      
end

% God that was exhausting

% Now let's do the bore triangulations
for k=fhs:fhs+(2*res)-2
        Tailfin.T = [Tailfin.T; k k+1 k+(2*res); k+1 k+(2*res) k+(2*res)+1];
end

TF = Tailfin;

end