function [TT, YY, beta] = main_calculation(m_payload, dt, latitude,inclination, mode, launchparams)
    global data; data = xlsread('Constants.xlsx'); global beta_phase
    global lat; global i; lat = latitude; i = inclination; global orbit_R; orbit_R = 1000;
    global task; task = mode; % to choose if simulation or optimization
    global rocket_params; rocket_params = launchparams;
    %% launchparams [m_struct_1,m_prop_1,m_struct_2,m_prop_2,Isp_1,Isp_2,T_1,T_2,t_burn_1,t_burn_2, A_e_1, A_e_2, rocket_name]
    %time_interval = [0,10,20,30,50,75,100,140,175,191.34,193,195,220,260,310,350,390,420,490,560,605]; 
    time_interval = [0,0.05226*rocket_params(9),0.10452*rocket_params(9),0.15679*rocket_params(9),0.26131*rocket_params(9),0.39197*rocket_params(9),0.52263*rocket_params(9),0.73168*rocket_params(9),0.91460*rocket_params(9), rocket_params(9)-2,rocket_params(9),rocket_params(9)+2,rocket_params(9)+2+0.06097*rocket_params(10),rocket_params(9)+2+0.15854*rocket_params(10),rocket_params(9)+2+0.28049*rocket_params(10),rocket_params(9)+2+0.37805*rocket_params(10),rocket_params(9)+2+0.47561*rocket_params(10),rocket_params(9)+2+0.54878*rocket_params(10),rocket_params(9)+2+0.71951*rocket_params(10),rocket_params(9)+2+0.89024*rocket_params(10),rocket_params(9)+2+rocket_params(10)];
    beta = beta_phase;
    %% Phase #1 0~10
    m0 = m_payload+rocket_params(1)+rocket_params(2)+rocket_params(3)+rocket_params(4);
    x_cord_0 = 6378*cosd(latitude); % in spherical coordinates, lat = 90 - lat, negative for south
    y_cord_0 = 0;
    z_cord_0 = 6378*sind(latitude);
    dx_0 = 0; 
    dy_0 = 0.465101*cosd(latitude); % Rotation speed at specific latitude, (+) for CCW
    %% Phase #0~9 0~191.34
    y0 = [x_cord_0, y_cord_0, z_cord_0, dx_0, dy_0, 0, m0];
    [tt1, yy1] = ode45(@force_f, (time_interval(1):dt:time_interval(10)), y0);
    %% Phase #10 191.34~193
    y0 = yy1(end,:);
    [tt10, yy10] = ode45(@force_f, (time_interval(10):dt:time_interval(11)), y0);
    %% Phase #11 193~195
    y0 = yy10(end,:);
    y0(7) = m_payload + rocket_params(3) + rocket_params(4);    
    [tt11, yy11] = ode45(@force_f, (time_interval(11):dt:time_interval(12)), y0);
    %% Phase #12 195~605
    y0 = yy11(end,:);
    [tt12, yy12] = ode45(@force_f, (time_interval(12):dt:time_interval(21)), y0);
    %% Initializing output for graph
    TT = [tt1',tt10',tt11',tt12'];
    YY = [yy1',yy10',yy11',yy12'];
    %% Explanation of yy components:
    % yy(:,1) - x-cord, yy(:,2) - y, yy(:,3) - z
    % yy(:,4) - dx-cord, yy(:,5) - dy, yy(:,6) - dz   
    % yy(:,7) - mass
end