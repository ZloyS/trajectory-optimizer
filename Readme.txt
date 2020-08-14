Trajectory Optimization Tool v1.0.5
Made by Denis Groshev (KAIST Department of Aerospace Engineering, Spring 2020)

To access GUI: 'Trajectory_Optimizer_1' -> 'for_redistribution_files_only' -> Trajectory_Optimizer.exe
Files description:
1. atmosgrav.m - calculates gravity and atmospheric data (introduced into force_f).
2. Constants.xlsx - 1976 Atmosphere Data table (0~1000km).
3. Earth_clouds.jpg - texture for atmosphere (placed 86px above main texture).
4. Earth_texture.jpg - texture of Earth (R=6378px).
5. equalities.m - computational file for nonlcon.
6. final_orbit - computes final trajectory parameters after full burn of fuel.
7. force_f.m - initializer of ODEs for simulation.
8. force_f_opt.m - initializer of ODEs for optimization (they have different methods, that's why different files, TBD).
9. main_calculation.m - execution file for simulation.
10. main_calculation_optimization.m - executional file for optimization.
11. Project.slx - Simulink file for Part-1 only (used for testing purposes).
12. Trajectory_Optimizer.mlapp - GUI file to execute all functions.

For future development plans, access About section in the app.
To report bugs/suggestions/discussion, write on grdennis@kaist.ac.kr (working) or denis31082000@gmail.com (personal).

Thank you for using my app! Enjoy the the day!