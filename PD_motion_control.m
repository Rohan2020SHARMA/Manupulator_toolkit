%Motion Control 
%clear all
clc
%Assumptions: 
%1 Start from all Q = 0
%2 

%Make the robot
%L(1) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
%L(2) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);

%main_robot_arm = SerialLink(L); 
%ALGEdit: Added workspace
ws = [-2 2 -2 2 -2 2];
plot_options = {'workspace',ws};

L = evalin('base', 'L'); 
main_robot_arm = SerialLink(L); 
n = evalin('base', 'dof');
%n =2; 

%TODO Should have a mechanism to check if the end effector position is
%reachable

%Get desired and initial position

%x0 = [2 0 0 0 0 0]'; 
%xd = [0.1242 1.7508 0 0 0 0]'
xd = evalin('base', 'xd');
initial_joint_position = zeros(n, 1);
H_intial = main_robot_arm.fkine(initial_joint_position)
x0 = [H_intial(1,4); H_intial(2,4); H_intial(3,4); 0; 0; 0];


%Possible source of error Check the dimensions
Kpx = evalin('base', 'Kp'); 
Kdx = evalin('base', 'Kd'); 

Kp = Kpx*eye(6,6)
Kd = Kdx*eye(6,6)
loop_error = 1; 
threshold = 0.01;

% putting initial value of x as x0 
x = x0;
% Getting initial joint values (TODO: There is probably a better method to get the joint values)
q = zeros(1, n);
qdot = zeros(1, n); 
i = 1; 
while loop_error > threshold && i < 500
    %TODO: Should the error be 4x4 or 3x1
    error = xd - x;
    Ja = main_robot_arm.jacob0(q, 'rpy'); 
    JaT = transpose(Ja);
    term1 = JaT*Kp*(error); 
    term2 = JaT*Kd*Ja*transpose(qdot); 
    
    %TODO: Check the gravity term
    term3 = main_robot_arm.gravjac(q); 
    u = term1 -term2 + transpose(term3); 
    assignin('base', 'control_input', u); 
    [ti, qi, qidot] = main_robot_arm.fdyn(1, @torque_func, q, qdot); 
    %fprintf('QQ');
    q = qi(end,:); 
    qdot= qidot(end,:);
    x = main_robot_arm.fkine(q); 
    x_star = x(1:3, 4);
    xx_star = [x_star(1); x_star(2);x_star(3); 0; 0; 0];
    %Get loop error
    loop_error = max(abs(xd -xx_star)); 
    x = xx_star; 
    
    %Log data
    distance_error = sqrt(transpose(error)*error); 
    log_q(:, i) = q; 
    log_qd(:, i) = qdot; 
    log_u(:,i) = u; 
    log_time(:,i) = i-1;
    log_distance_error(i) = distance_error; 
    i=i+1 
    main_robot_arm.plot(q, 'workspace', ws);
    hold on
    
end

assignin('base', 'log_distance_error', log_distance_error); 
assignin('base', 'log_time', log_time); 
assignin('base', 'log_u', log_u); 
assignin('base', 'log_q', log_q); 
assignin('base', 'log_qd', log_qd); 

%dynamic_fig = 
%ax1 = uiaxes(dynamic_fig)
%fplot(ax1, log_time(1,:), log(distance_error(1,:)))


% The torque fucntion
function tau = torque_func(t, q, qdot, a)
    u = evalin('base', 'control_input');
    tau = transpose(u) 
end

