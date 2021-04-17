%temp robot
%Make the robot
clear all

%Make the robot
L(1) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
L(2) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
main_robot_arm = SerialLink(L); 
n =2; 
dof = 2; 
assignin('base', 'main_robot_arm', main_robot_arm )
assignin('base', 'dof', dof);
assignin('base', 'user_control_input', [1 1])
xd = [0.1242 1.7508 0 0 0 0]'