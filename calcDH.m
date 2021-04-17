function dh = calcDH(dof,jtype,z,linklen)

% Initialize matrices
th = sym(zeros(dof,1));
d = sym(zeros(dof,1));
a = sym(zeros(dof,1));
alpha = sym(zeros(dof,1));
x = sym(zeros(3,dof+1));

q = sym('q',[1 dof],'real');

% Initial x-axis in base frame
x(:,1) = [1;0;0];

for i = 1:dof
    if norm(cross(z(:,i),z(:,i+1))) == 0
        x(:,i+1) = x(:,i);
    else
        x(:,i+1) = cross(z(:,i),z(:,i+1));
    end
    
    lx = x(:,i+1);
    if sign(lx(lx~=0)) == -1
        alpha(i) = -acosd(dot(z(:,i+1),z(:,i)));
    else
        alpha(i) = acosd(dot(z(:,i+1),z(:,i)));
    end
    
    if jtype(i) == "P"
        d(i) = q(i);
        a(i) = 0;
        th(i) = acosd(dot(x(:,i),x(:,i+1)));
    elseif jtype(i) == "R"
        th(i) = q(i);
        a(i) = linklen(i);
    end
end

dh = ["a" "alpha" "d" "theta";a alpha d th];

assignin('base', 'dh_mike', dh); 
% NOTES:
% 
% 1. dof - Number of single DOF joints of robotic arm entered by the user.
% 2. jtype - 1 x DOF string array of type of each joint (prismatic or
%    revolute) entered by the user.
% 3. z - 3 x DOF array of unit vectors of positive z-axis of each joint
%    with respect to the base frame entered by the user. First column will 
%    always be [0 0 1]'. The positive z-axis of a joint is the axis of 
%    positive rotation (revolute) or translation (prismatic).
% 4. linklen - 1 x DOF double array of lengths of each link entered by the
%    user.