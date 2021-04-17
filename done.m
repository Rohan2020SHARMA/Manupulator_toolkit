%After pushing Done button
L = evalin('base', 'L'); 
main_robot_arm = SerialLink(L); 
n = evalin('base', 'dof');
q0 = zeros(1, n); 
qdot0 = zeros(1, n); 
T =4
%T = app.SimulationTimeEditField.Value; 
[ti, q, qdot ] = main_robot_arm.fdyn(T, @torquefunc, q0, qdot0); 

%send q qdot to workspace
assignin('base', 'plot_q_contant_torque', q);
assignin('base', 'plot_qdot_constant_torque', qdot);
assignin('base', 'plot_time_constant_torque', ti);




function tau = torquefunc(t, q, qdot, a)
u = evalin('base', 'user_control_input')
tau = transpose(u)
end