function equalities = equalities(x)
global beta_phase iPhase t_phase
global m_payload;
global orbit_R;
global rocket_params;
%% launchparams [m_struct_1,m_prop_1,m_struct_2,m_prop_2,Isp_1,Isp_2,T_1,T_2,t_burn_1,t_burn_2, A_e_1, A_e_2, rocket_name]
    m_payload = x(1)*1000;
%    t_phase = [0,10,20,30,50,75,100,140,175,191.34,193,195,220,260,310,350,390,420,490,560,605];
    t_phase = [0,0.05226*rocket_params(9),0.10452*rocket_params(9),0.15679*rocket_params(9),0.26131*rocket_params(9),0.39197*rocket_params(9),0.52263*rocket_params(9),0.73168*rocket_params(9),0.91460*rocket_params(9), rocket_params(9)-2,rocket_params(9),rocket_params(9)+2,rocket_params(9)+2+0.06097*rocket_params(10),rocket_params(9)+2+0.15854*rocket_params(10),rocket_params(9)+2+0.28049*rocket_params(10),rocket_params(9)+2+0.37805*rocket_params(10),rocket_params(9)+2+0.47561*rocket_params(10),rocket_params(9)+2+0.54878*rocket_params(10),rocket_params(9)+2+0.71951*rocket_params(10),rocket_params(9)+2+0.89024*rocket_params(10),rocket_params(9)+2+rocket_params(10)];
    beta_phase = [90,90,90.*x(2:20)];
    global lat;
    %% Assign initial values
    m0 = m_payload+rocket_params(1)+rocket_params(2)+rocket_params(3)+rocket_params(4);
    x_cord_0 = 6378*cosd(lat); % in spherical coordinates, lat = 90 - lat, negative for south
    y_cord_0 = 0;
    z_cord_0 = 6378*sind(lat);
    dx_0 = 0; 
    tout = [];
    dy_0 = 0.465101*cosd(lat); % Rotation speed at specific latitude, (+) for CCW
    %% Phase #0~9 0~191.34
    y0 = [x_cord_0, y_cord_0, z_cord_0, dx_0, dy_0, 0, m0];
    yout = [];
    n_phase = length(t_phase);
    for iPhase = 2:n_phase
        ti = t_phase(iPhase-1);
        tf = t_phase(iPhase);
        [TT,YY] = ode45(@force_f_opt, ti:tf, y0);
        tout = [tout; TT(end,:)];
        yout = [yout; YY(end,:)];
        y0 = YY(end,:);
        if iPhase == 10
            y0(7) = m_payload + rocket_params(3) + rocket_params(4);
        end 
    end
    %% Initializing output for graph
    final = yout(end,:); r0 = [final(1), final(2), final(3)]; v0 = [final(4), final(5), final(6)];
%   energy = norm(v0)^2/2-398600/norm(r0); % energy of system
%   a = -398600/(2*energy); H = cross(r0, v0) ;e = norm(cross(v0,H)/398600-r0/norm(r0));
%   apogee = a*(1+e); perigee = a*(1-e); 
    v_target = sqrt(398600/(6378+orbit_R));
    equalities(1) = (norm(r0)-(orbit_R+6378))/(orbit_R+6378);
    equalities(2) = (norm(v0)-v_target)/v_target; 
    equalities(3) = (r0*v0')/(norm(r0)*norm(v0));
%   equalities(3) = apogee-perigee;
end