%inverse dynamics control
%clear all
%Make the robot
%L(1) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);
%L(2) = Revolute('d', 0, 'a', 1, 'alpha', 0, 'm', 50, 'r', [0.5 0 0], 'I', [10 10 10], 'G', 100, 'Jm', 0.01);

%main_robot_arm = SerialLink(L);
%n=2; 
ws = [-3 3 -3 3 -3 3];
plot_options = {'workspace',ws};

L = evalin('base', 'L'); 
main_robot_arm = SerialLink(L); 
n = evalin('base', 'dof');



initial_joint_position = zeros(n, 1);
H_intial = main_robot_arm.fkine(initial_joint_position);
x0 = [H_intial(1,4); H_intial(2,4); H_intial(3,4); 0; 0; 0];

des_x = evalin('base', 'xd'); 
%des_x = [0.12 1.7508 0 0 0 0]'; 
%desired xdot, xddot
des_xdot = [0 0 0 0 0 0]'; 
des_xddot= [0 0 0 0 0 0]';


%Possible source of error Check the dimensions
%Kp = 5*eye(6,6);
%Kd = 3*eye(6,6);

%Possible source of error Check the dimensions
Kpx = evalin('base', 'Kp'); 
Kdx = evalin('base', 'Kd'); 

Kp = Kpx*eye(6,6)
Kd = Kdx*eye(6,6)

distance_error = 1; 
threshold = 0.01;

% putting initial value of x as x0 
x = x0;
xdot = [0 0 0 0 0 0]';
% Getting initial joint values (TODO: There is probably a better method to get the joint values)
q = zeros(1, n);
qdot = zeros(1, n); 
i = 1;
dt = 0.01;
while distance_error > threshold && i < 1500
    %TODO: Should the error be 4x4 or 3x1
    error = des_x - x;
    fprintf('Q that goes in jacob0\n')
    q
    Ja = main_robot_arm.jacob0(q)
    %Ja = main_robot_arm.jacob0(q, 'rpy'); 
    default_tol = max(size(Ja))*eps(norm(Ja))
    Ja_inv = pinv(Ja, 0.01)
    %Ja_inv = inv(Ja)
    jacobian_derivative = main_robot_arm.jacob_dot(q, qdot);
    y = Ja_inv*(des_xddot - Kd*xdot + Kp*error - jacobian_derivative) 
    %y = (des_xddot - Kd*xdot + Kp*error - jacobian_derivative)/Ja
    %the B(q).qddot term
    B = main_robot_arm.inertia(q)
    term1 = B*y
    
    %coriolis term
    coriolis_term = main_robot_arm.coriolis(q, qdot)
    term2 = coriolis_term*transpose(qdot)
    
    %gravity term
    %Another source of error could be this  gravload term. Maybe use
    %gravjac
    gravity_term = main_robot_arm.gravload(q); 
    term3 = transpose(gravity_term)
    
    u = term1 + term2 + term3; 
    qddot = inv(B)*(u - term2 - term3);
    qdot = qdot + transpose(qddot)*dt;
    q = q + qdot*dt 
    %assignin('base', 'control_input', u); 
    
    %put the  
    
    %[ti, qi, qidot] = main_robot_arm.fdyn(1, @torque_func, q, qdot);
    %fprintf('aLso here');
    % qi(end,:);
    % q = qi(end,:); 
    % qdot= qidot(end,:);
     
     %get x
     x = main_robot_arm.fkine(q); 
     x_star = x(1:3, 4);
     xx_star = [x_star(1); x_star(2);x_star(3); 0; 0; 0];
     x = xx_star; 
     
     %get xdot
     temp_x_dot = Ja*transpose(qdot);
     xdot_star = temp_x_dot(1:3); 
     xx_star_dot = [xdot_star(1); xdot_star(2); xdot_star(3); 0; 0; 0];
     xdot = xx_star_dot; 
     distance_error = sqrt(transpose(error)*error); 
     
    
     %Log data
    distance_error = sqrt(transpose(error)*error); 
    log_q(:, i) = q; 
    log_qd(:, i) = qdot; 
    log_u(:,i) = u; 
    log_time(:,i) = dt*i;
    log_distance_error(i) = distance_error; 
    main_robot_arm.plot(q, 'workspace', ws)
    i = i+1
    hold on


end


assignin('base', 'log_distance_error', log_distance_error); 
assignin('base', 'log_time', log_time); 
assignin('base', 'log_u', log_u); 
assignin('base', 'log_q', log_q); 
assignin('base', 'log_qd', log_qd); 
fprintf('End Effector has reached its desired position')

function J_inv = pseudo_inv(Ja)
    J_inv = transpose(Ja)*inv(Ja*transpose(Ja));
end