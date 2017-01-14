function [faces,x,y,z]=octogonAMhollow(oct_len,height_oct,thick,stx,sty,stz)
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

%TRIANGLE and PLOT%
TR=triangulation(faces,x.',y.',z.');
%tm=trimesh(TR);
hold on


axis equal