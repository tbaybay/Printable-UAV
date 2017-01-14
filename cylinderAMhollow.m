function [faces,x,y,z]=cylinderAMhollow(stx,sty,stz,radius,len_cylinder,thick)
% Written by Alex Maddison
%Cylinders%
[x1,y1,z1]=cylinder(radius,100); %Outer%
[x2,y2,z2]=cylinder(radius-thick,100); %Inner%
n=length(x1);

x=stx+[x1(1,:) x1(2,:) x2(1,:) x2(2,:)];
y=sty+[y1(1,:) y1(2,:) y2(1,:) y2(2,:)];
z=stz+len_cylinder*[z1(1,:) z1(2,:) z2(1,:) z2(2,:)];
    
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