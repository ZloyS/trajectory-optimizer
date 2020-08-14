# trajectory-optimizer  
  
## Program description:  
Application can plot optimal ascend trajectory (maximize payload) with the input of starting point on the globe, final orbit parameters (inclination, apoapsis, periapsis) by varying steering angle throughout stages of flight. Also, for demonstration purposes, it is capable of simulating flight with predefined parameters, requiring payload mass as input.  
For simplicity of use as educational tool, it has numerous predefined launch vehicles and launch areas throughout the world (varying from equatorial zone to subpolar regions).  
For future plans, I am going to implement optimization using linear steering law and adding coasting optimization for up to 4 stages. Also, current speed of computing (3 minutes at least) leaves huge space of improvements.  
  
## To access GUI:  
'Trajectory_Optimizer_1' -> 'for_redistribution_files_only' -> Trajectory_Optimizer.exe  
  
## File definitions:  
atmosgrav.m - returns atmospheric/gravity acceleration values based on current velocity/altitude.  
constants.xlsx - tabular information of atmospheric constants based on 1976 version (0~1000km).  
Earth_clouds.jpg - texture of clouds, set to 70% transparency to represent atmosphere.  
Earth_texture.jpg - texture of Earth surface, for globe.  
equalities.m - calculates nonlinear constraints in Optimization part (nonlcon).  
final_orbit.m - plots final orbit based on last ascend point.  
force_f.m - solves ODE system for Simulation part.  
force_f_opt.m - solves ODE system for Optimization part (they have different methods, that's why different files, TBD).  
launch_icon.png - Icon of the app, for MATLAB App Designer.  
launch_telemetry.xlsx - optional output file with telemetry of current ascend.  
main_calculation.m - execution of Simulation part.  
main_calculation_optimization.m - execution of Optimization part.  
Project.slx - Simulink-based alternative for simulation part. (testing purposes only)  
Trajectory_Optimizer.mlapp - GUI file to execute all functions.  
  
## Contact  
For future development plans, access 'About' section in the app.  
To report bugs/suggestions/discussion, write on grdennis@kaist.ac.kr (working) or denis31082000@gmail.com (personal) or create pull request.  
