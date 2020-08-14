function dydt = force_f(t, yy)
global lat; global i; global beta_list; global orbit_R
global task; global beta_phase; global rocket_params
%% Condiitonal changes
x = yy(1); %x-cord
y = yy(2); %y-cord
z = yy(3); %z-cord
dx = yy(4); %x-velocity
dy = yy(5); %y-velocity
dz = yy(6); %z-velocity
m = yy(7); %mass
azimuth = asind(cosd(i)/cosd(lat)); % azimuth in inertial frame with no rotation

%azimuth = min(azimuth,180-azimuth);
%% Cosmodrome to inclination orbit:
mu = 398600;
veq_rot = 2*pi*6378/86164.09; % rotation of Earth on equator
v_orbit = -sqrt(mu/orbit_R); % speed at destination orbit
vxrot = v_orbit*sind(azimuth)-veq_rot*cosd(lat); % orbital speed with respect to rotation
vzrot = v_orbit*cosd(azimuth);
azimuth_rot = atand(vxrot/vzrot); % azimuth with relation to Earth rotation
%% Calculating area
if t<rocket_params(9)  
    S = rocket_params(13);
else
    S = rocket_params(14);
end
[p, rho, C_d, gx, gy, gz] = atmosgrav(x,y,z, dx,dy,dz, lat);
dynamic_pressure = rho*sqrt(dx^2+(dy-0.465101*cosd(lat))^2+dz^2)/2*1000/101325;
%% Calculating angles
%t_phase = [0,10,20,30,50,75,100,140,175,191.34,193,195,220,260,310,350,390,420,490,560,605];
t_phase = [0,0.05226*rocket_params(9),0.10452*rocket_params(9),0.15679*rocket_params(9),0.26131*rocket_params(9),0.39197*rocket_params(9),0.52263*rocket_params(9),0.73168*rocket_params(9),0.91460*rocket_params(9), rocket_params(9)-2,rocket_params(9),rocket_params(9)+2,rocket_params(9)+2+0.06097*rocket_params(10),rocket_params(9)+2+0.15854*rocket_params(10),rocket_params(9)+2+0.28049*rocket_params(10),rocket_params(9)+2+0.37805*rocket_params(10),rocket_params(9)+2+0.47561*rocket_params(10),rocket_params(9)+2+0.54878*rocket_params(10),rocket_params(9)+2+0.71951*rocket_params(10),rocket_params(9)+2+0.89024*rocket_params(10),rocket_params(9)+2+rocket_params(10)];
if task == 2 
    beta_phase = beta_list;
else
    beta_phase = [90,90,89.973,89.898,84.76,71.349,56.021,38.934,30.622,37.74,37.74,37.74,31.095,26.718,19.356,13.096,6.49,0.758,-10.614,-27.413,-27.413];
end
beta = interp1(t_phase, beta_phase, t); % linear interpolation
%% Calculating acceleration components
%% Drag
if sqrt(x^2+y^2+z^2)-6378 < 1000 % If below edge of atmosphere, drag exists
    a_drag_x = -0.5*rho*dx*sqrt(dx^2+dy^2+dz^2)*S*C_d/(1000*m); % divide by 1000 for km/s^2
    a_drag_y = -0.5*rho*dy*sqrt(dx^2+dy^2+dz^2)*S*C_d/(1000*m);
    a_drag_z = -0.5*rho*dz*sqrt(dx^2+dy^2+dz^2)*S*C_d/(1000*m);
else
    a_drag_x = 0;
    a_drag_y = 0;    
    a_drag_z = 0;
end
%% Thrust
k = 1;
if dynamic_pressure > 0.05*0.5 % 5% of maximum dynamic pressure of 0.5atm
    k = 0.67;% reduce thrust to 67% of nominal, SRBs also designed in such way
end
T_newton = 1000.*[rocket_params(7), rocket_params(8)];
A_e = [rocket_params(11),rocket_params(12)];
if t<rocket_params(9)-2 % if first stage
    a_thrust_x = k*(T_newton(1)-A_e(1)*p)*sind(beta)*sind(azimuth_rot)/(1000*m);
    a_thrust_y = k*(T_newton(1)-A_e(1)*p)*cosd(beta)*sind(azimuth_rot)/(1000*m);
    a_thrust_z = k*(T_newton(1)-A_e(1)*p)*cosd(azimuth_rot)/(1000*m);
    if i >90
        a_thrust_x = -a_thrust_x;
    end
elseif rocket_params(9)-2<=t && t<rocket_params(9)+2 % if coasting and decoupling
    a_thrust_x = 0;
    a_thrust_y = 0;
    a_thrust_z = 0;
elseif rocket_params(9)<=t && t<rocket_params(9)+rocket_params(10) % if second stage
    a_thrust_x = k*(T_newton(2)-A_e(2)*p)*sind(beta)*sind(azimuth_rot)/(1000*m);
    a_thrust_y = k*(T_newton(2)-A_e(2)*p)*cosd(beta)*sind(azimuth_rot)/(1000*m);
    a_thrust_z = k*(T_newton(2)-A_e(2)*p)*cosd(azimuth_rot)/(1000*m);
    if i >=90
        a_thrust_x = -a_thrust_x;
    end
elseif rocket_params(10)<=t % if orbital flight
    a_thrust_x = 0; 
    a_thrust_y = 0;
    a_thrust_z = 0;
else
    a_thrust_x = 0;
    a_thrust_y = 0;
    a_thrust_z = 0;
end

%% Gravity component
a_gravity_x = gx; % no need to divide by 1000 because already km/s^2
a_gravity_y = gy;
a_gravity_z = gz;


%% Initialize acceleration components
a_forces_x = a_gravity_x+a_thrust_x+a_drag_x;
a_forces_y = a_gravity_y+a_thrust_y+a_drag_y;
a_forces_z = a_gravity_z+a_thrust_z+a_drag_z;


%% Initialize mass flow rate
if t<rocket_params(9)-2
    dm = -rocket_params(2)/rocket_params(9);
elseif t>=rocket_params(9)+2 && t<rocket_params(9)+2+rocket_params(10)
    dm = -rocket_params(4)/rocket_params(10);
else
    dm = 0;
end

%% Initialize differential equation
dydt = [dx, dy, dz, a_forces_x, a_forces_y, a_forces_z, dm]';
end