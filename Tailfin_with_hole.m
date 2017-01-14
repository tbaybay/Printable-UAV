% Describe tailfin
ax = 100;
bx = 300;
cx = 50;

ay = 300;
cy = 50;
dy = 50;

thickness = 20;

y = [0 ax bx bx bx-cx bx-cx bx bx bx-cx];
np = length(y);

x = [0 ay ay ay-cy ay-cy dy dy 0 0];
z = zeros(size(y));
y = [y y];
x = [x x];
z = [z thickness.*ones(size(z))];

T = [];

% Create taifin triangulation
for k=1:np
    if k==1
        T = [1 2 9; 2 9 6; 9 8 6; 7 8 6; 2 5 6; 2 3 5; 3 4 5];
        T = [T; k k+1 k+np; k+np k+np+1 k+1];
    elseif k==np
        T = [T; np 2*np 1; 1 1+np 2*np];
        T = [T; 1+np 2+np 9+np; 2+np 9+np 6+np; 9+np 8+np 6+np; 7+np 8+np 6+np; 2+np 5+np 6+np; 2+np 3+np 5+np; 3+np 4+np 5+np];
    else
        T = [T; k k+1 k+np; k+np k+np+1 k+1];
    end
end

Tailfin.T = T;
Tailfin.x = x;
Tailfin.y = y;
Tailfin.z = z;
Tailfin.np = np;

% Bore the first hole
Tailfin = holierThanThou([3 2 2+np 3+np], [4 5 5+np 4+np], Tailfin, -20, 2, 8, 20);

% Bore the second hole
Tailfin = holierThanThou([7 6 6+np 7+np], [8 9 9+np 8+np], Tailfin, -20, 4, 8, 20);

TR = triangulation(Tailfin.T, Tailfin.x', Tailfin.y', Tailfin.z');

tm = trimesh(TR);
axis off
axis equal tight

set(tm, 'FaceColor', 'red', 'EdgeColor', 'black');
alpha(0.5);