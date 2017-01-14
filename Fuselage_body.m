function [z, y, x] =  Fuselage_body(wing_span)
% Written by Joss Roberts and Lucy Sayes
% Generates vertex data for front of fuselage

%% INPUTS
% wing_span: Wing span of UAV, used to scale part
%% OUTPUTS
% x, y, z: Point data describing surface

%% FUNCTION
scale_factor=10;
cylinder_length = scale_factor*5;
cylinder_radius = scale_factor*8;
N=100;


%        NOSE
% Outer
[x1,y1,z1] = sphere(N);
x1 = x1(1:round(end/2), :);
y1 = y1(1:round(end/2), :);
z1 = z1(1:round(end/2), :);
x1 = cylinder_radius*x1;
y1 = 0.5*cylinder_radius*y1;
z1 = 2*cylinder_radius*z1;

% % Inner
[x2,y2,z2] = sphere(N);
r2 = cylinder_radius-(cylinder_radius*0.1);
x2 = x2(1:round(end/2), :);
y2 = y2(1:round(end/2), :);
z2 = z2(1:round(end/2), :);
x2 = r2*x2;
y2 = 0.5*r2*y2;
z2 = 2*cylinder_radius*z2;


%       BODY

[x3,y3,z3] = cylinder([cylinder_radius-(cylinder_radius*0.1),cylinder_radius-(cylinder_radius*0.1)], N);
z3(2, :) = z3(1, :) + cylinder_length;
y3 = 0.5*y3;
z3 = 1.5*z3;


for i=1 : round(5) 
x3(:, i) = (4*scale_factor)+(0.1*3);
end
% 
y3(:, round(5)) = y3(:, round(6));
y3(:, round(4)) = y3(:, round(5))+(scale_factor+(0.1*scale_factor));
y3(:, round(3)) = y3(:, round(4));
x3(:, round(3)) = x3(:, round(4))-(2*scale_factor+(0.1*scale_factor));
x3(:, round(2)) = x3(:, round(3));
x3(:, round(1)) = x3(:, round(2));

for i= 1 : 2
    x3(:, i) = x3(:, round(2));
end

for i= round(N-3) : (N+1);
x3(:, i) = (4*scale_factor)+(0.1*3);
end

y3(:, round((length(y3))-4)) = y3(:, round((length(y3))-5));
y3(:, round((length(y3))-3)) = y3(:, round((length(y3))-4))-(scale_factor+(0.1*scale_factor));
y3(:, round((length(y3))-2)) = y3(:, round((length(y3))-3));
x3(:, round((length(x3))-2)) = x3(:, round((length(x3))-3))-(2*scale_factor+(0.1*scale_factor));
x3(:, round((length(x3))-1)) = x3(:, round((length(x3))-2));

for i= round(N) : N+1
    x3(:, i) = x3(:, round((length(x3))-1));
end

[x4,y4,z4] = cylinder([cylinder_radius,cylinder_radius], (N));
z4(2, :) = z4(1, :) + cylinder_length;
y4 = 0.5*y4;
z4 = 1.5*z4;

for i=1 : round(4) 
x4(:, i) = 4*scale_factor;
end
% 
y4(:, round(4)) = y4(:, round(5));
y4(:, round(3)) = y4(:, round(4))+scale_factor;
y4(:, round(2)) = y4(:, round(3));
x4(:, round(2)) = x4(:, round(3))-scale_factor;

for i= 1 : 2
    x4(:, i) = x4(:, round(2));
end

for i= round(N-2) : (N+1);
x4(:, i) = 4*scale_factor;
end

y4(:, round((length(y4))-3)) = y4(:, round((length(y4))-4));
y4(:, round((length(y4))-2)) = y4(:, round((length(y4))-3))-scale_factor;
y4(:, round((length(y4))-1)) = y4(:, round((length(y4))-2));
x4(:, round((length(x4))-1)) = x4(:, round((length(x4))-2))-scale_factor;

for i= round(N) : N+1
    x4(:, i) = x4(:, round((length(x4))-1));
end

x=vertcat(x1,x2,x3,x4);
y=vertcat(y1,y2,y3,y4);
z=vertcat(z1,z2,z3,z4);

%% Scaling + Positioning
x = x*wing_span/2400;
y = y*wing_span/1260;
z = z*wing_span/1260;

x = x - (cylinder_radius*wing_span/1900);
end