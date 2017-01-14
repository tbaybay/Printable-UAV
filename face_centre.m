function x_mid = face_centre(x, l, points_fore)
% Written by Jerome Wynne
% Calculates mid-point of an aerofoil forms in a given coordinate
% direction.
% For use with tail_fin().
%% INPUTS
% Takes x in [l1 l2 l3 l4 ...] format, where l is a column vector of
% x-points for a given levels
% Output returned in [xf_mid xr_mid] format, where xf_... is a column
% vector containing all midpoints for the l levels. Note that these are
% in the order specified by l
%% OUTPUTS
% x_mid: Vector of x-values of the middle of each of the levels input

%% FUNCTION
points_per_level = size(x, 1);

xl = x(:, l); % One level of x points
xlf = xl(1:points_fore, :); % Points in front section of aerofoil
xlr = xl(points_fore+1:points_per_level, :); % Points in rear section of aerofoil

xmxf = max(xlf); % Returns a row vector containing max value of each level's front
xmnf = min(xlf); % same for minimum value
xmdf = (xmxf + xmnf)./2; % Mid value of front

xmxr = max(xlr); % Same as previous block for flap portion of fin
xmnr = min(xlr);
xmdr = (xmxr + xmnr)./2;

x_mid = [xmdf' xmdr'];
end