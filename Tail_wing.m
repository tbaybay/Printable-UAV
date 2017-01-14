function [x_all, y_all, z_all] = Tail_wing(wing_span, side, elevator_span)
% Written by Jordan Bellamy and Ciro Garcia-Agullo
% Generates vertices describing a tail wing
% Relies on surf2stl to generate faces

%% INPUTS
% wing_span: Wing span of UAV. Used to scale component.
% side: Which side the wing is on, looking from tail to nose
% elevator span: Wing span of the tail wings
%% OUTPUTS
% x_all, y_all, z_all: Column vector of vertex ordinates

%% FUNCTION
iaf.designation='0012';
iaf.n=30;
iaf.HalfCosineSpacing=1;
iaf.wantFile=1;
iaf.datFilePath='./'; % Current folder
iaf.is_finiteTE=0;

af = naca4gen(iaf);

chord_length = wing_span/16;
foil_width = elevator_span;

x_upper=(af.xU);
x_lower=(af.xL);

z_upper=(af.zU);
z_lower=(af.zL);

x_u_l=vertcat( x_upper, x_lower ).*chord_length;
z_u_l=vertcat( z_upper, z_lower ).*chord_length;

zeroes=zeros(2*length(af.xU), 1);

offset = chord_length/3;

oness = (ones(2*length(af.xU), 1))*wing_span/30;

num_points=length(x_u_l);
[x,y,z] = cylinder(wing_span*0.0015,num_points-1);

x(1,:)=[];
y(1,:)=[];
z(1,:)=[];

x=x';
y=y';
z=z';

adjusted_midpoint = x + offset;
offset = offset*ones(size(x));

y_all=horzcat(zeroes, zeroes, elevator_span + oness, elevator_span + oness, elevator_span + oness, elevator_span+(1.3*oness), elevator_span+(1.3*oness));
x_all=horzcat(offset, x_u_l, x_u_l, offset, adjusted_midpoint, adjusted_midpoint, offset);
z_all=horzcat(zeroes, z_u_l, z_u_l, zeroes, y, y, y);

z_all = z_all - 0.0575*wing_span;
x_all = x_all + wing_span*0.3491;

if strcmp(side, 'left')
    y_all = y_all - wing_span*1.3/30 - elevator_span;
else
    y_all = -y_all + wing_span*1.3/30 + elevator_span;
end

end