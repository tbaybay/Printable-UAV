function [faces,y,x,z]=octogonAMhollow_hole_bothsides(oct_len,height_oct,thick,stx,sty,stz,hole_rad)
% Written by Alex Maddison

c_thick=cosd(67.5)*thick;
s_thick=sind(67.5)*thick;

x1=[stx stx+oct_len stx+oct_len+(oct_len*cosd(45)) stx+oct_len+(oct_len*cosd(45)) stx+oct_len stx stx-(oct_len*cosd(45)) stx-(oct_len*cosd(45)) stx];
y1=[sty sty sty+(oct_len*sind(45)) sty+oct_len+(oct_len*sind(45)) sty+oct_len+(2*oct_len*sind(45)) sty+oct_len+(2*oct_len*sind(45)) sty+oct_len+(oct_len*sind(45)) sty+(oct_len*sind(45)) sty];

x2=[stx+c_thick stx+oct_len-c_thick stx+oct_len+(oct_len*cosd(45))-s_thick stx+oct_len+(oct_len*cosd(45))-s_thick stx+oct_len-c_thick stx+c_thick stx-(oct_len*cosd(45))+s_thick stx-(oct_len*cosd(45))+s_thick stx+c_thick];
y2=[sty+s_thick sty+s_thick sty+(oct_len*sind(45))+c_thick sty+oct_len+(oct_len*sind(45))-c_thick sty+oct_len+(2*oct_len*sind(45))-s_thick sty+oct_len+(2*oct_len*sind(45))-s_thick sty+oct_len+(oct_len*sind(45))-c_thick sty+(oct_len*sind(45))+c_thick sty+s_thick];


n=length(x1);
z=zeros(1,4*n); 

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
faces((2*(n-2))+1:(3*(n-2)),3)=(n+2:2*n-1);

faces((3*(n-2))+1:(4*(n-2)),1)=(3:n);
faces((3*(n-2))+1:(4*(n-2)),2)=(n+2:n+(n-1));
faces((3*(n-2))+1:(4*(n-2)),3)=(n+3:2*n);

% faces((8*(n-2))+1,1)=2;
% faces((8*(n-2))+1,2)=n+1;
% faces((8*(n-2))+1,3)=n+2;
% 
% faces((8*(n-2))+2,1)=1;
% faces((8*(n-2))+2,2)=2;
% faces((8*(n-2))+2,3)=n+1;

%FACES inner sides%
faces((5*(n-2))+1:(6*(n-2)),1)=(2*n+2:3*n-1);
faces((5*(n-2))+1:(6*(n-2)),2)=(2*n+3:3*n);
faces((5*(n-2))+1:(6*(n-2)),3)=(3*n+2:4*n-1);

faces((6*(n-2))+1:(7*(n-2)),1)=((2*n)+3:3*n);
faces((6*(n-2))+1:(7*(n-2)),2)=(3*n+2:4*n-1);
faces((6*(n-2))+1:(7*(n-2)),3)=(3*n+3:4*n);

% faces((8*(n-2))+3,1)=2*n+2;
% faces((8*(n-2))+3,2)=2*n+1;
% faces((8*(n-2))+3,3)=3*n+2;
% 
% faces((8*(n-2))+4,1)=2*n+1;
% faces((8*(n-2))+4,2)=3*n+1;
% faces((8*(n-2))+4,3)=3*n+2;

%HOLE 1%
if 2*hole_rad>(oct_len-2*c_thick)
    
end
    
if hole_rad==0
    
else
    
    %Delete faces for hole%
%     faces((8*(n-2))+1,:)=1;
%     faces((8*(n-2))+2,:)=1;
%     faces((8*(n-2))+3,:)=1;
%     faces((8*(n-2))+4,:)=1;
    
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
   
   close_val=ones(1,2*m);
   close_pos=ones(1,2*m);
   
    for i=1:m
        [close_val(i),close_pos(i)]=min((((x_cy(i)-[x1 x1]).^2)+((z_cy(i)-z(1:2*n)).^2)+((y_cy(i)-[y1 y1]).^2)).^0.5);
        if i==1
            faces(8*(n-2)+8+i,1)=close_pos(i);
            faces(8*(n-2)+8+i,2)=11;
            faces(8*(n-2)+8+i,3)=4*n+i;
        elseif i==ceil(m/4)||(i==ceil(3*(m/4)))
            faces(8*(n-2)+i+8,1)=close_pos(i);
            faces(8*(n-2)+i+8,2)=close_pos(i)+1;
            faces(8*(n-2)+i+8,3)=4*n+i;
        elseif x_cy(i)==(oct_len/2)-hole_rad &&i<m
            faces(8*(n-2)+i+8,1)=close_pos(i);
            faces(8*(n-2)+i+8,2)=close_pos(i)+n;
            faces(8*(n-2)+i+8,3)=4*n+i;
        else
            faces(8*(n-2)+i+8,1)=close_pos(i);
            faces(8*(n-2)+i+8,2)=4*n+i-1;
            faces(8*(n-2)+i+8,3)=4*n+i;
        end
    
    end
    
    %FACES AROUND HOLE INSIDE%
    for i=m+1:2*m
        [close_val(i),close_pos(i)]=min((((x_cy(i)-[x2 x2]).^2)+((z_cy(i)-z(2*n+1:4*n)).^2)+((y_cy(i)-[y2 y2]).^2)).^0.5);
        if i==m+1
            faces(8*(n-2)+8+i,1)=2*n+close_pos(i);
            faces(8*(n-2)+8+i,2)=29;
            faces(8*(n-2)+8+i,3)=4*n+i;
        elseif i==m+ceil(m/4)||(i==m+ceil(3*(m/4)))
            faces(8*(n-2)+i+8,1)=2*n+close_pos(i);
            faces(8*(n-2)+i+8,2)=2*n+close_pos(i)+1;
            faces(8*(n-2)+i+8,3)=4*n+i;
        elseif x_cy(i)==(oct_len/2)-hole_rad && i>m
            faces(8*(n-2)+i+8,1)=2*n+close_pos(i);
            faces(8*(n-2)+i+8,2)=3*n+close_pos(i);
            faces(8*(n-2)+i+8,3)=4*n+i;
        else
            faces(8*(n-2)+i+8,1)=2*n+close_pos(i);
            faces(8*(n-2)+i+8,2)=4*n+i-1;
            faces(8*(n-2)+i+8,3)=4*n+i;
        end
    
    end
    
    %FACES INSIDE HOLE%
    q=8*(n-2)+2*m+4;
    k=4*n;
    faces((q+1:q+m-2),1)=(k+2:k+m-1);
    faces((q+1:q+m-2),2)=(k+3:k+m);
    faces((q+1:q+m-2),3)=(k+m+2:k+2*m-1);

    faces((q+m+1:q+2*m-2),1)=(k+3:k+m);
    faces((q+m+1:q+2*m-2),2)=(k+m+2:k+2*m-1);
    faces((q+m+1:q+2*m-2),3)=(k+m+3:k+2*m);

    faces(q+2*m-1,1)=k+2;
    faces(q+2*m-1,2)=k+1;
    faces(q+2*m-1,3)=k+m+2;

    faces((q+2*m),1)=k+1;
    faces((q+2*m),2)=k+m+1;
    faces((q+2*m),3)=k+m+2;
    
end

%HOLE 2%
if 2*hole_rad>(oct_len-2*c_thick)
    disp('ERROR HOLE TOO LARGE, CAN NOT BE MADE'); 
end
    
if hole_rad==0
    
else
    
    %Delete faces for hole%
    faces((2*(n-2))+4,:)=1;
    faces((3*(n-2))+4,:)=1;
    faces((5*(n-2))+4,:)=1;
    faces((6*(n-2))+4,:)=1;
    
    %Create and position cylinder%
    [x_cy,z_cy,y_cy]=cylinder(hole_rad,100);
    m=length(x_cy);
    x_cy=stx+[x_cy(1,:) x_cy(2,:)]+0.5*oct_len;
    y_cy=sty+thick*[y_cy(2,:) y_cy(1,:)]+((1+(2^0.5))*oct_len)-thick;
    z_cy=stz+[z_cy(1,:) z_cy(2,:)]+0.5*height_oct;
        
    x=[x x_cy];
    y=[y y_cy];
    z=[z z_cy];
    faces=[faces; ones(4*m+28,3)];
   %FACES AROUND HOLE OUTSIDE%
   j=(8*(n-2)+4*m+8);
   k=2*m;
   i=0;
    for i=1:m
        [close_val(i),close_pos(i)]=min((((x_cy(i)-[x1 x1]).^2)+((z_cy(i)-z(1:2*n)).^2)+((y_cy(i)-[y1 y1]).^2)).^0.5);
        if i==1
            faces(j+i,1)=close_pos(i);
            faces(j+i,2)=14;
            faces(j+i,3)=k+4*n+i;
        elseif i==ceil(m/4)
            faces(j+i,1)=close_pos(i);
            faces(j+i,2)=close_pos(i)+1;
            faces(j+i,3)=k+4*n+i;
        elseif i==ceil(3*(m/4)) 
            faces(j+i,1)=close_pos(i);
            faces(j+i,2)=close_pos(i)-1;
            faces(j+i,3)=k+4*n+i;
        elseif x_cy(i)==(oct_len/2)-hole_rad &&i<m
            faces(j+i,1)=close_pos(i);
            faces(j+i,2)=close_pos(i)+n;
            faces(j+i,3)=k+4*n+i;
        else
            faces(j+i,1)=close_pos(i);
            faces(j+i,2)=k+4*n+i-1;
            faces(j+i,3)=k+4*n+i;
        end
    
    end
    
    %FACES AROUND HOLE INSIDE%
    for i=m+1:2*m
        [close_val(i),close_pos(i)]=min((((x_cy(i)-[x2 x2]).^2)+((z_cy(i)-z(2*n+1:4*n)).^2)+((y_cy(i)-[y2 y2]).^2)).^0.5);
        if i==m+1
            faces(j+i,1)=2*n+close_pos(i);
            faces(j+i,2)=32;
            faces(j+i,3)=k+4*n+i;
        elseif i==m+ceil(m/4)
            faces(j+i,1)=2*n+close_pos(i);
            faces(j+i,2)=2*n+close_pos(i)+1;
            faces(j+i,3)=k+4*n+i;
        elseif i==m+ceil(3*(m/4))
            faces(j+i,1)=2*n+close_pos(i);
            faces(j+i,2)=2*n+close_pos(i)-1;
            faces(j+i,3)=k+4*n+i;
        elseif x_cy(i)==(oct_len/2)-hole_rad &&i>m
            faces(j+i,1)=2*n+close_pos(i);
            faces(j+i,2)=2*n+close_pos(i)+n;
            faces(j+i,3)=k+4*n+i;
        else
            faces(j+i,1)=2*n+close_pos(i);
            faces(j+i,2)=k+4*n+i-1;
            faces(j+i,3)=k+4*n+i;
        end
    
    end
    
    %FACES INSIDE HOLE%
    q=j+2*m+4;
    p=4*n+2*m;
    faces((q+1:q+m-2),1)=(p+2:p+m-1);
    faces((q+1:q+m-2),2)=(p+3:p+m);
    faces((q+1:q+m-2),3)=(p+m+2:p+2*m-1);

    faces((q+m+1:q+2*m-2),1)=(p+3:p+m);
    faces((q+m+1:q+2*m-2),2)=(p+m+2:p+2*m-1);
    faces((q+m+1:q+2*m-2),3)=(p+m+3:p+2*m);

    faces(q+2*m-1,1)=p+2;
    faces(q+2*m-1,2)=p+1;
    faces(q+2*m-1,3)=p+m+2;

    faces((q+2*m),1)=p+1;
    faces((q+2*m),2)=p+m+1;
    faces((q+2*m),3)=p+m+2;
    
end
%TRIANGLE and PLOT%
TR=triangulation(faces,y.',x.',z.');
%hold on

axis equal