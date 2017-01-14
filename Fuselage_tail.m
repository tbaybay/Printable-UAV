function [z y x] = Fuselage_tail(wing_span)
% Written by Joss Roberts and Lucy Sayes
% Generates vertex data for back of fuselage

%% INPUTS
% wing_span: Wing span of UAV, used to scale part
%% OUTPUTS
% x, y, z: Point data describing surface

%% FUNCTION

scale_factor=10;
cylinder_length = scale_factor*5;
cylinder_radius = scale_factor*8;
tail_length = scale_factor*9;
N=100;
c_rad=((0.08*scale_factor)+(((((scale_factor*0.4)^2)/(1+(2^0.5))^2)+((scale_factor*0.4)^2))^0.5))/2;

%       TAIL

%inner

[x5,y5,z5] = cylinder([0, (0.9*cylinder_radius), c_rad, 0], N);
z5(1, :) = z5(1, :) + cylinder_length*1.1;
z5(2, :) = z5(1, :);
z5(3, :) = z5(1, :) + 0.4*tail_length;
x5(3, :) = x5(3, :) - 0.9*((cylinder_radius-(cylinder_radius*0.1)));
x5(4, :) = x5(3, :);
z5(4, :) = z5(3, :);
y5(2, :) = y5(2, :) * 0.5;
%y5(2, :) = y5(2, :) * 0.5;
%x5 = x5;
%y5 = 0.5*y5;
z5 = 1.5*z5;
%plot3(x5,y5,z5,'g')


%outer

[x6,y6,z6] = cylinder([0,cylinder_radius,cylinder_radius*0.2, cylinder_radius*0.2, cylinder_radius*0.2, 0],N);
z6(1, :) = z6(1, :) + cylinder_length;
z6(2, :) = z6(1, :);
z6(3, :) = z6(1, :) + tail_length;
z6(4, :) = z6(3, :);
z6(5, :) = z6(1, :) + 0.45*tail_length;
z6(6, :) = z6(5, :);
x6(3, :) = x6(3, :) - (0.45*cylinder_radius);
x6(5, :) = x6(3, :);
x6(6, :) = x6(3, :);
x6(4, :) = x6(3, :);
z6(4, :) = z6(3, :);
y6(2, :) = y6(2, :) * 0.5;

y6 = 0.5*y6;
z6 = 1.5*z6;


%%       MOTOR HOUSING

% Inner

[x7,y7,z7] = cylinder([(cylinder_radius-(cylinder_radius*0.1)),cylinder_radius*0.1,0],N);
z7(1, :) = z7(1, :) + cylinder_length;
z7(2, :) = z7(1, :) + 0.5*tail_length;
x7(2, :) = x7(2, :) + 0.8*((cylinder_radius-(cylinder_radius*0.1)));
x7(3, :) = x7(2, :);
z7(3, :) = z7(2, :);
y7(1, :) = y7(1, :) * 0.5;
z7 = 1.5*z7;

% Outer

[x8,y8,z8] = cylinder([cylinder_radius,(10.5*2),10.5,10.5,0],N); %dimensions of motor
z8(1, :) = z8(1, :) + cylinder_length;
z8(2, :) = z8(1, :) + 1.3*tail_length;
x8(2, :) = x8(2, :) + (0.3*cylinder_radius);
x8(3, :) = x8(2, :);
z8(3, :) = z8(2, :);
z8(4, :) = z8(3, :);
z8(5, :) = z8(4, :);
x8(4, :) = x8(3, :);
x8(5, :) = x8(4, :);
y8(1, :) = y8(1, :) * 0.5;
z8 = 1.5*z8;


%% Combine point matrices
hold on
x=vertcat(x5,x6,x7,x8);
y=vertcat(y5,y6,y7,y8);
z=vertcat(z5,z6,z7,z8);

x = x*wing_span/2400;
y = y*wing_span/1260;
z = z*wing_span/1260;

x = x - (cylinder_radius*wing_span/1900);

end
