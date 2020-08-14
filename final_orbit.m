function [Ys, apseline, T] = final_orbit(x,y,z,vx,vy,vz)
%% Plot trajectory of spacecraft using Runge-Kutta 4th Order method
mu = 398601.2; %km^3/sec^2
r0 = [x,y,z]; v0 = [vx,vy,vz]; % initial position of distance and velocity
energy = norm(v0)^2/2-mu/norm(r0); % energy of system
a = -mu/(2*energy);
T = 2*pi*sqrt(a^3/mu);
p0 = [x,y,z,vx,vy,vz];
t0 = 0;
tf = 3*T; %three revolutions
dh = 10; %time step, seconds
ts = t0:dh:tf; %incremental time data
N = numel(ts); % size of time data samples
Ys = zeros(6,N); % time series data for Y-vectors for all time steps.
%2x1 Y vector and N time steps -> Ys:
Ys(:,1) = p0; %initial value constraint
for ii = 1:N-1
    t_ii = ts(ii); % time @ ii-th time step
    Y_ii = Ys(:,ii); % current state Y @ ii-th time step
    k1 = dh*dynamics(t_ii,Y_ii);
    k2 = dh*dynamics(t_ii + 0.5*dh, Y_ii+0.5*k1);
    k3 = dh*dynamics(t_ii + 0.5*dh, Y_ii+0.5*k2);
    k4 = dh*dynamics(t_ii + dh, Y_ii +k3);  
    Ys(:,ii+1)=Y_ii + (k1+2*k2+2*k3+k4)/6;
end
altitudes = sqrt(Ys(1,:).^2+Ys(2,:).^2+Ys(3,:).^2);
a1 = find(altitudes==min(altitudes));
a2 = find(altitudes==max(altitudes)); 
ax = [Ys(1,a1), Ys(1,a2)]; ay = [Ys(2,a1), Ys(2,a2)]; az = [Ys(3,a1), Ys(3,a2)]; apseline = [ax' ay' az']';
end
%% dynamics without drag coefficient
function dYdt = dynamics(t, Y)
    % state Y: 2x1 vector
    y1 = Y(1);
    y2 = Y(2);
    y3 = Y(3);
    y4 = Y(4);
    y5 = Y(5);
    y6 = Y(6); 
    % output state derivative dYdt: 2x1 vector.
    dYdt = [y4 
            y5 
            y6
            -398601.2*y1/(sqrt(y1^2+y2^2+y3^2))^3
            -398601.2*y2/(sqrt(y1^2+y2^2+y3^2))^3
            -398601.2*y3/(sqrt(y1^2+y2^2+y3^2))^3];
end
