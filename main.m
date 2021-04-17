% main matlab file that calls all GUIs and functions
clear all
clc
% declaring the variables necessary

% Calling the first GUI to take in the values of the DH Parameteres
%screen1 = app1_exported;
screen1 = main_gui_exported
uiwait(screen1.UIFigure);

%closereq

% The toolbox asks for a workspace limits definition when there are
% prismatic joints in the robot
ws = [-3 3 -3 3 -3 3];
plot_options = {'workspace',ws};

% making the robot out of the matrix (using robotics toolbox)
%main_dh_table
%Get the values of scenario from the workspace
scenario = evalin('base', 'scenario'); 
if scenario == 1

    L = Link();
    main_dh_table = main_dh_table(2:height(array2table(main_dh_table)), :);
    num_links = height(array2table(main_dh_table)); 
    assignin('base', 'dof', num_links);
    for i = 1:num_links
        if is_revolute_array(i) == 1
            R = Revolute('d', main_dh_table(i,3), 'alpha', main_dh_table(i,2), 'a', main_dh_table(i,1), 'm', main_dh_table(i, 5), 'r', [main_dh_table(i, 10) main_dh_table(i, 11) main_dh_table(i, 12)], 'I', [main_dh_table(i, 7) main_dh_table(i, 8) main_dh_table(i, 9)], 'G', main_dh_table(i, 6), 'Jm', main_dh_table(i, 16), 'qlim', [main_dh_table(i, 17) main_dh_table(i, 18)]);
            L = [L;R];
        else
            P = Prismatic('theta', main_dh_table(i,4),  'alpha', main_dh_table(i,2), 'a', main_dh_table(i,1) , 'm', main_dh_table(i, 5), 'r', [main_dh_table(i, 10) main_dh_table(i, 11) main_dh_table(i, 12)], 'I', [main_dh_table(i, 7) main_dh_table(i, 8) main_dh_table(i, 9)], 'G', main_dh_table(i, 6), 'Jm', main_dh_table(i, 16), 'qlim', [main_dh_table(i, 17) main_dh_table(i, 18)]);
            L = [L;P];
        end
    end 
    L = L(:, 2:num_links + 1);
    %main_robot_arm = SerialLink(main_dh_table)
    main_robot_arm = SerialLink(L, 'name', "GoodRobot", 'plotopt', plot_options); 
    

    %Getting the g0 vector
    g0 = [main_dh_table(1, 13) main_dh_table(1, 14) main_dh_table(1,15)];
    assignin('base', 'g0', g0 ); 

elseif scenario==2
    %Make the robot
    L(1) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
    L(2) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
    main_robot_arm = SerialLink(L, 'name', "GoodRobot");
    dof = 2; 
    assignin('base', 'main_robot_arm', main_robot_arm );
    assignin('base', 'dof', dof);
    g0 = [0 0 -1];
    assignin('base', 'g0', g0); 

elseif scenario ==3
    L(1) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
    L(2) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
    L(3) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
    main_robot_arm = SerialLink(L, 'name', "GoodRobot",'plotopt', plot_options );
    dof = 3; 
    assignin('base', 'main_robot_arm', main_robot_arm);
    assignin('base', 'dof', dof);
    g0 = [0 0 -1];
    assignin('base', 'g0', g0); 
elseif scenario == 4
    fprintf('scenario 4');
    L = Link();
    dof = 2;
    PJ = Prismatic('theta', pi, 'a', 0, 'alpha', pi/2, 'qlim', [-5 5], 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
    L = [L;PJ];
    RJ = Revolute('d', 0, 'alpha', 0, 'a', 1, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
    L = [L;RJ];

    L = L(:,2:3);

    main_robot_arm = SerialLink(L, 'name', "GoodRobot", 'plotopt', plot_options);
    assignin('base', 'main_robot_arm', main_robot_arm );
    assignin('base', 'dof', dof);
    g0 = [-1 0 0];
    assignin('base', 'g0', g0);
    
elseif scenario == 9
    fprintf('scenario')
    dof = evalin('base', 'dof')
    dh_mike = evalin('base', 'dh_mike')
    
    link_inertias_mike = evalin('base', 'link_inertias')
    motor_inertias_mike = evalin('base', 'motor_inertias')
    limits_mike = evalin('base', 'limits')
    gear_ratios_mike = evalin('base', 'gear_ratios')
    link_masses_mike = evalin('base', 'link_masses')
    joint_type = evalin('base', 'joint_type')
    gravity_direction = evalin('base', 'gravity_field')
    dh_mike = dh_mike(2:dof+1, :)
    L = Link(); 
    for i=1:dof
        if joint_type(dof) == 'R'
            R = Revolute('d', double(dh_mike(i, 3)), 'a', double(dh_mike(i, 1)), 'alpha', double(dh_mike(i,2)), 'm', link_masses_mike(i), 'I', [link_inertias_mike(i,1) link_inertias_mike(i,2) link_inertias_mike(i,3)], 'G', gear_ratios_mike(i), 'Jm', motor_inertias_mike(i), 'qlim', [limits_mike(i,1) limits_mike(i, 2)], 'r', [double(dh_mike(i,1))/2 0 0]);
            L = [L;R]
        else
            P =  Prismatic('theta', double(dh_mike(i,4)), 'a', double(dh_mike(i,1)), 'alpha', double(dh_mike(i,2)),'m', link_masses_mike(i), 'I', [link_inertias_mike(i,1) link_inertias_mike(i,2) link_inertias_mike(i,3)], 'G', gear_ratios_mike(i), 'Jm', motor_inertias_mike(i), 'qlim', [limits_mike(i,1) limits_mike(i,2)], 'r', [0 0 double(dh_mike(i,1))/2]);
            L = [L;P]
        end
    end
    
    L = L(:, 2:dof+1);
    %main_robot_arm = SerialLink(main_dh_table)
    main_robot_arm = SerialLink(L, 'name', "GoodRobot", 'plotopt', plot_options); 
    assignin('base', 'g0', gravity_direction); 
   
end


%Display robot
if scenario ~=9
    %main_robot_arm.teach;
end
%Calling the dynamics function
main_dynamics(); 


screen2 = dynamics_control_gui_exported_4; 
