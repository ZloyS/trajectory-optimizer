function [p, rho, C_d, gx, gy, gz]= atmosgrav(x, y, z, dx, dy, dz, lat)
global data;
%% Initialize gravity correction coefficients for Helmert's equation
alpha = 5.2792e-3;
beta = 2.32e-5;
% lat = 0; % Set as equator for testing
correction = 1+alpha*(sind(lat))^2+beta*(sind(lat))^4; % on equator, correction = 1 (original gravity)
%% Gravity acceleration
Re = 6378;
mu = 398600;
g = mu/(x^2+y^2+z^2);
h = sqrt(x^2+y^2+z^2)-Re;
if x == 0
    gx = 0;
else
    gx = -g*x/(sqrt(x^2+y^2+z^2))*correction;
end
if y == 0
    gy = 0;
else
    gy = -g*y/(sqrt(x^2+y^2+z^2))*correction;
end
if z == 0
    gz = 0;
else
    gz = -g*z/(sqrt(x^2+y^2+z^2))*correction;
end
%% Atmospheric values
if h>0 && h <= 1000
%    T = interp1(data(:,1), data(:,2), sqrt(x^2+z^2)-Re);
    p = interp1(data(:,1), data(:,3), h);
    rho = interp1(data(:,1), data(:,4), h);
    a = interp1(data(:,1), data(:,5), h);
else
%   T = 0;
    p = 0;
    rho = 0;
    a = 1;
end

%% Initialize Mach-Cd values
M = sqrt(dx^2+dy^2+dz^2)/a;
M_reference = [0, 0.7, 0.95, 1.1, 1.2, 1.4, 1.7, 2.5, 4.0, 50.0]; 
C_d_reference = [0.35, 0.45, 0.75, 1.1, 1.15, 1.05, 0.9, 0.65, 0.55, 0.55];
if h < 1000
    C_d = interp1(M_reference, C_d_reference, M);
else
    C_d = 0;
end