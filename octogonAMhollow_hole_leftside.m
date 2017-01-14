function [faces,y,x,z]=octogonAMhollow_hole_leftside(oct_len,height_oct,thick,stx,sty,stz,hole_rad)
% Written by Alex Maddison

c_thick=cosd(67.5)*thick;
s_thick=sind(67.5)*thick;


x1=[stx stx+oct_len stx+oct_len+(oct_len*cosd(45)) stx+oct_len+(oct_len*cosd(45)) stx+oct_len stx stx-(oct_len*cosd(45)) stx-(oct_len*cosd(45)) stx];
y1=[sty sty sty+(oct_len*sind(45)) sty+oct_len+(oct_len*sind(45)) sty+oct_len+(2*oct_len*sind(45)) sty+oct_len+(2*oct_len*sind(45)) sty+oct_len+(oct_len*sind(45)) sty+(oct_len*sind(45)) sty];

x2=[stx+c_thick stx+oct_len-c_thick stx+oct_len+(oct_len*cosd(45))-s_thick stx+oct_len+(oct_len*cosd(45))-s_thick stx+oct_len-c_thick stx+c_thick stx-(oct_len*cosd(45))+s_thick stx-(oct_len*cosd(45))+s_thick stx+c_thick];
y2=[sty+s_thick sty+s_thick sty+(oct_len*sind(45))+c_thick sty+oct_len+(oct_len*sind(45))-c_thick sty+oct_len+(2*oct_len*sind(45))-s_thick sty+oct_len+(2*oct_len*sind(45))-s_thick sty+oct_len+(oct_len*sind(45))-c_thick sty+(oct_len*sind(45))+c_thick sty+s_thick];


n=length(x1);
z=[zeros(1,4*n)]; 

z(1:n)=stz;
z(2*n+1:3*n)=stz;
z(n+1:2*n)=stz+height_oct;
z(3*n+1:4*n)=stz+height_oct;

x=[x1 x1 x2 x2];
y=[y1 y1 y2 y2];



    
faces=ones((8*(n-2))+8,3);

%FACES END%
%Bottom%
faces(1:n-2,1)=(1:n-2);
faces(1:n-2,2)=(2:n-1);
faces(1:n-2,3)=(((2*n)+1):((3*n)-2));

faces((n-1):(2*(n-2)),1)=(2:n-1);
faces((n-1):(2*(n-2)),2)=(((2*n)+1):((3*n)-2));
faces((n-1):(2*(n-2)),3)=(((2*n)+2):((3*n)-1));

%Top%
faces(4*(n-2):5*(n-2),1)=(n:2*n-2);
faces(4*(n-2):(5*(n-2)),2)=(n+1:2*n-1);
faces(4*(n-2):(5*(n-2)),3)=(((3*n)):((4*n)-2));

faces((7*(n-2)):8*(n-2),1)=(n+1:2*n-1);
faces((7*(n-2)):8*(n-2),2)=(((3*n)):((4*n)-2));
faces((7*(n-2)):8*(n-2),3)=(((3*n)+1):((4*n)-1));

%Bottom face gap cover%
faces((8*(n-2))+5,1)=1;
faces((8*(n-2))+5,2)=n-1;
faces((8*(n-2))+5,3)=2*n+1;

faces((8*(n-2))+6,1)=n-1;
faces((8*(n-2))+6,2)=2*n+1;
faces((8*(n-2))+6,3)=3*n-1;

%Top face gap cover%
faces((8*(n-2))+7,1)=2*n;
faces((8*(n-2))+7,2)=2*n-1;
faces((8*(n-2))+7,3)=4*n-1;

faces((8*(n-2))+8,1)=2*n;
faces((8*(n-2))+8,2)=4*n-1;
faces((8*(n-2))+8,3)=4*n;



%FACES OUTER SIDES%
faces((2*(n-2))+1:(3*(n-2)),1)=(2:n-1);
faces((2*(n-2))+1:(3*(n-2)),2)=(3:n);
faces((2*(n-2))+1:(3*(n-2)),3)=(n+2:n+(n-1));

faces((3*(n-2))+1:(4*(n-2)),1)=(3:n);
faces((3*(n-2))+1:(4*(n-2)),2)=(n+2:n+(n-1));
faces((3*(n-2))+1:(4*(n-2)),3)=(n+3:2*n);

faces((8*(n-2))+1,1)=2;
faces((8*(n-2))+1,2)=n+1;
faces((8*(n-2))+1,3)=n+2;

faces((8*(n-2))+2,1)=1;
faces((8*(n-2))+2,2)=2;
faces((8*(n-2))+2,3)=n+1;

%FACES inner sides%
faces((5*(n-2))+1:(6*(n-2)),1)=(2*n+2:3*n-1);
faces((5*(n-2))+1:(6*(n-2)),2)=(2*n+3:3*n);
faces((5*(n-2))+1:(6*(n-2)),3)=(3*n+2:4*n-1);

faces((6*(n-2))+1:(7*(n-2)),1)=((2*n)+3:3*n);
faces((6*(n-2))+1:(7*(n-2)),2)=(3*n+2:4*n-1);
faces((6*(n-2))+1:(7*(n-2)),3)=(3*n+3:4*n);

faces((8*(n-2))+3,1)=2*n+2;
faces((8*(n-2))+3,2)=2*n+1;
faces((8*(n-2))+3,3)=3*n+2;

faces((8*(n-2))+4,1)=2*n+1;
faces((8*(n-2))+4,2)=3*n+1;
faces((8*(n-2))+4,3)=3*n+2;

%HOLE%

if 2*hole_rad>(oct_len-2*c_thick)
    disp('ERROR HOLE TOO LARGE, CAN NOT BE MADE'); 
end
    
if hole_rad==0
    
else
    
    %Delete faces for hole%
    faces((8*(n-2))+1,:)=1;
    faces((8*(n-2))+2,:)=1;
    faces((8*(n-2))+3,:)=1;
    faces((8*(n-2))+4,:)=1;
    
    %Create and position cylinder%
    [x_cy,z_cy,y_cy]=cylinder(hole_rad,100);
    m=length(x_cy);
    x_cy=stx+[x_cy(1,:) x_cy(2,:)]+0.5*oct_len;
    y_cy=sty+thick*[y_cy(1,:) y_cy(2,:)];
    z_cy=stz+[z_cy(1,:) z_cy(2,:)]+0.5*height_oct;
        
    x=[x x_cy];
    y=[y y_cy];
    z=[z z_cy];
    faces=[faces; ones(2*m+2*(m-2)+32,3)];
   %FACES AROUND HOLE OUTSIDE%
    for i=1:m
        [close_val(i),close_pos(i)]=min(20+(((x_cy(i)-[x1 x1]).^2)+((z_cy(i)-z(1:2*n)).^2)).^0.5);
        if i==1
            faces(8*(n-2)+8+i,1)=close_pos(i);
            faces(8*(n-2)+8+i,2)=11;
            faces(8*(n-2)+8+i,3)=4*n+i;
        elseif x_cy(i)==oct_len/2 && i<m
            faces(8*(n-2)+i+8,1)=close_pos(i);
            faces(8*(n-2)+i+8,2)=close_pos(i)+1;
            faces(8*(n-2)+i+8,3)=4*n+i;
        elseif x_cy(i)==(oct_len/2)-hole_rad &&i<m
            faces(8*(n-2)+i+8,1)=close_pos(i);
            faces(8*(n-2)+i+8,2)=10;
            faces(8*(n-2)+i+8,3)=4*n+i;
        else
            faces(8*(n-2)+i+8,1)=close_pos(i);
            faces(8*(n-2)+i+8,2)=4*n+i-1;
            faces(8*(n-2)+i+8,3)=4*n+i;
        end
    
    end
    
    %FACES AROUND HOLE INSIDE%
    for i=m+1:2*m
        [close_val(i),close_pos(i)]=min((((x_cy(i)-[x2 x2]).^2)+((z_cy(i)-z(2*n+1:4*n)).^2)).^0.5);
        if i==m+1
            faces(8*(n-2)+8+i,1)=2*n+close_pos(i);
            faces(8*(n-2)+8+i,2)=29;
            faces(8*(n-2)+8+i,3)=4*n+i;
        elseif x_cy(i)==oct_len/2 && i>m
            faces(8*(n-2)+i+8,1)=2*n+close_pos(i);
            faces(8*(n-2)+i+8,2)=2*n+close_pos(i)+1;
            faces(8*(n-2)+i+8,3)=4*n+i;
        elseif x_cy(i)==(oct_len/2)-hole_rad &&i>m
            faces(8*(n-2)+i+8,1)=2*n+close_pos(i);
            faces(8*(n-2)+i+8,2)=28;
            faces(8*(n-2)+i+8,3)=4*n+i;
        else
            faces(8*(n-2)+i+8,1)=2*n+close_pos(i);
            faces(8*(n-2)+i+8,2)=4*n+i-1;
            faces(8*(n-2)+i+8,3)=4*n+i;
        end
    
    end
    
    %FACES INSIDE HOLE%
    q=4*n+2*m+30;
    k=4*n;
    faces((q+1:q+m-2),1)=(k+2:k+m-1);
    faces((q+1:q+m-2),2)=(k+3:k+m);
    faces((q+1:q+m-2),3)=(k+m+2:k+2*m-1);

    faces((q+m+1:q+2*m-2),1)=((k+m)+3:k+2*m);
    faces((q+m+1:q+2*m-2),2)=(k+m+2:k+2*m-1);
    faces((q+m+1:q+2*m-2),3)=(k+m+3:k+2*m);

    faces(q+2*m-1,1)=k+2;
    faces(q+2*m-1,2)=k+1;
    faces(q+2*m-1,3)=k+m+2;

    faces((q+2*m),1)=k+1;
    faces((q+2*m),2)=k+m+1;
    faces((q+2*m),3)=k+m+2;
    
end
    
    
    



%TRIANGLE and PLOT%
TR=triangulation(faces,y.',x.',z.');
%tm=trimesh(TR);
hold on

axis equal