function [T, x, y, z] = Tail_connector(scale_factor, startx,starty,startz)
% Written by Alex Maddison
% Generates face and vertex data for wing tip of the UAV

%% INPUTS
% scale_factor: Wing span of the UAV
% startx etc.: Position to plot connector
%% OUTPUTS
% T: Nx3 matrix of faces (triangulations)
% x, y, z: Column vector of vertex ordinates

%% FUNCTION
c_len=scale_factor*0.2;
oct_len=scale_factor*0.1;
oct_wid=scale_factor*0.0095;
thick=0.001*scale_factor;
dist_holes_side=0.03*scale_factor;
dist_hole_top=0.05*scale_factor;
hole_rad=0.0015*scale_factor;

 %It is suggested that
 c_rad=((2*thick)+((((oct_wid^2)/(1+(2^0.5))^2)+(oct_wid^2))^0.5))/2;
 %This will ensure a tight fit for the prism into the cylinder


%stx= centre of start of cylinder x coordinate
%sty=centre of start of cylinder y coordinate
%stz=centre of start of cylinder z coordinate
%c_rad=radius of cylinder
%c_len=length of cylinder
%oct_wid=overall width of octogonal prism
%oct_len=overall length of octagonal prism
%thick=thickness of walls
%dist_holes_side= distance of holes (centre) for rear wing from end octagonal prism
%dist_hole_top=distance of hole (centre) for tail fin from end of octagonal prism
%hole_rad=radius of holes


%Cylinder%
[faces1,x1,y1,z1]=cylinderAMhollow(startx,starty,startz,c_rad,c_len,thick);
p=length(x1);
%Octogon%
oct_side_len=oct_wid/(1+2*cosd(45));

if dist_holes_side>dist_hole_top
    [faces2,x2,y2,z2]=octogonAMhollow(oct_side_len,(oct_len-dist_holes_side-hole_rad),thick,(startx-0.5*oct_side_len),(starty-0.5*oct_wid),startz+c_len);
    faces2=faces2+p;
    p=p+length(x2);
    [faces3,x3,y3,z3]=octogonAMhollow_hole_bothsides(oct_side_len,2*hole_rad,thick,(startx-0.5*oct_side_len),(starty-0.5*oct_wid),startz+c_len+oct_len-dist_holes_side-hole_rad,hole_rad);
    faces3=faces3+p;
    p=p+length(x3);
    [faces4,x4,y4,z4]=octogonAMhollow(oct_side_len,dist_holes_side-dist_hole_top-(2*hole_rad),thick,(startx-0.5*oct_side_len),(starty-0.5*oct_wid),startz+c_len+oct_len-dist_holes_side+hole_rad);
    faces4=faces4+p;
    p=p+length(x4);
    [faces5,x5,y5,z5]=octogonAMhollow_hole_top(oct_side_len,2*hole_rad,thick,(startx-0.5*oct_side_len),(starty-0.5*oct_wid),startz+c_len+oct_len-dist_hole_top-hole_rad,hole_rad);
    faces5=faces5+p;
    p=p+length(x5);
    [faces6,x6,y6,z6]=octogonAMhollow(oct_side_len,dist_hole_top-hole_rad,thick,(startx-0.5*oct_side_len),(starty-0.5*oct_wid),startz+c_len+oct_len-dist_hole_top+hole_rad);
    faces6=faces6+p;
    p=p+length(x6);

else

    [faces2,x2,y2,z2]=octogonAMhollow(oct_side_len,(oct_len-dist_hole_top-hole_rad),thick,(startx-0.5*oct_side_len),(starty-0.5*oct_wid),startz+c_len);
faces2=faces2+p;
    p=p+length(x2);
    [faces3,x3,y3,z3]=octogonAMhollow_hole_top(oct_side_len,2*hole_rad,thick,(startx-0.5*oct_side_len),(starty-0.5*oct_wid),startz+c_len+oct_len-dist_hole_top-hole_rad,hole_rad);
    faces3=faces3+p;
    p=p+length(x3);
    [faces4,x4,y4,z4]=octogonAMhollow(oct_side_len,dist_hole_top-dist_holes_side-hole_rad,thick,(startx-0.5*oct_side_len),(starty-0.5*oct_wid),startz+c_len+oct_len-dist_hole_top+hole_rad);
    faces4=faces4+p;
    p=p+length(x4);
    [faces5,x5,y5,z5]=octogonAMhollow_hole_bothsides(oct_side_len,2*hole_rad,thick,(startx-0.5*oct_side_len),(starty-0.5*oct_wid),startz+c_len+oct_len-dist_holes_side-hole_rad,hole_rad);
    faces5=faces5+p;
    p=p+length(x5);
    [faces6,x6,y6,z6]=octogonAMhollow(oct_side_len,dist_holes_side-hole_rad,thick,(startx-0.5*oct_side_len),(starty-0.5*oct_wid),startz+c_len+oct_len-dist_holes_side+hole_rad);
    faces6=faces6+p;
    p=p+length(x6);

end

T=[faces1; faces2; faces3; faces4; faces5; faces6];
x=[x1 x2 x3 x4 x5 x6]';
y=[y1 y2 y3 y4 y5 y6]';
z=[z1 z2 z3 z4 z5 z6]';
    

y = y - scale_factor*0.0575;
z = z + scale_factor*0.1;
end