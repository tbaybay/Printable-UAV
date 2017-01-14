res_c = 100;
rad = 10;
th = linspace(0, 2*pi, res_c);

[x, y] = pol2cart(th, rad.*ones(size(th)));

plot(x, y);

hold on


res_border = 100;
thb = linspace(0, 2*pi, res_border);
xr = 20 + thb.*abs(cosh(thb))/100;

[xb, yb] = pol2cart(thb, xr.*ones(size(thb)));

plot(xb, yb);

% Begin by converting back to polar

% Hole first
[th, r] = cart2pol(x, y);

% Then boundary
[thb, rb] = cart2pol(xb, yb);

T = [];
p1_last = 0;

for k = 1:size(th, 2)
   
    difference = abs(th(k) - thb);
    
    p1 = find(difference == min(difference));
    
    T = [T; k k+1 size(th,2)+p1];
    
    if p1 ~= p1_last
        T = [T; p1_last+size(th,2) p1+size(th,2) k];
    end
    
    p1_last = p1;
end

xt = [x xb];
yt = [y yb];
zt = zeros(size(yt));


xf = [xt xt];
yf = [yt yt];
zf = [zt zt+100];

pos = size(x, 2)+1; % pos+np = second border's start
np = size(xt, 2); % pos+np+nb-1 = second border's end
nb = size(xb, 2);

T = [T; T+np];

for kb=1:size(xb, 2)-1
    T = [T; kb+pos+np kb+pos+1 kb+pos; kb+pos+np kb+pos+1 kb+pos+np+1];
end

T([end, end-1], :) = [];
T = [T; pos pos+np pos+1; pos+np pos+np+1 pos+1];

for kb=1:res_c
   T = [T; kb+1 kb kb+np; kb+np kb+1 kb+np+1];
end


%zf(1,res_c+1:res_c+nb) = (rb.^3)./10000;
%zf(1, res_c+np+1:res_c+np+nb) = zf(1, res_c+np+1:res_c+np+nb) - ((rb./2).^3)./10000;

TR = triangulation(T, xf', yf', zf');

tm = trimesh(TR);
axis equal
axis off

set(tm, 'FaceColor', 'red', 'EdgeColor', 'black');
alpha(0.8);

stlwrite('test.stl', T, [xf', yf', zf']);