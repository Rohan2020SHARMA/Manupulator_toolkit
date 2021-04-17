function main_dynamics()
%clear all
%Question 1 of the Assignment5 
%syms a1 a2

% Link variables 
%%%%%%%%%%%%    TEMP    %%%%%%%%%%%%%%%%%%%
%L = Link();
%num_links = 2;
%PJ = Prismatic('theta', pi, 'a', 0, 'alpha', pi/2);
%L = [L;PJ];
%RJ = Revolute('d', 0, 'alpha', 0, 'a', a2 );
%L = [L;RJ];

%L = L(:,2:3);

% TODO Get the robot arm from the workspace
robot_arm = evalin('base', 'main_robot_arm');

%get the array of links
L = evalin('base', 'L')


%robot_arm = SerialLink(L, 'name', 'two link');
n = evalin('base', 'dof'); 
P0 = [0 0 0]'; 
q = sym('q', [1 n]);
qdot = sym('qdot', [1 n]);
qddot = sym('qddot', [1 n]);

%get values of gear ratio from the robot_arm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:n
    mL(i) = L(i).m;
    mM(i) = 0; %%% Mass of motor assumed to be 0 
    I(:,:, i) = L(i).I;
    Im(i) = L(i).Jm; 
    IL(:,:, i) = L(i).I
    IM(i) = Im(i);
    kr(i) = L(i).G; 
     
end




%kr = sym('kr', [1 n]); 
g = 9.81;
direction_g0 = evalin('base', 'g0');
g0= g*transpose(direction_g0); 


%z0 = sym([0; 0; 1]);
z0 = [0 0 1]; 
%g0 = [-9.81 0 0]; % Need z0 
%kr = [1 1]; 
%%%%%%%%%%% Getting all transformation matrices %%%%%%%%%%%%%%%%%%%%%%%%%%%
% A multi-dimensional T array
for i= 1:n
    % Calculate transformation between joint i-1 and i
    tempT = robot_arm.A(i, q);
    % Get the right transformations wrt base frame 
    if i>1
        TT(:,:,i) = TT(:, :, i-1)*tempT;
    else
        TT(:, :, i) = tempT;
    end
    
end

fprintf('TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTThis should be simplified')

TT = simplify(TT)

%%%%%%%%%%%%%%%% Getting Link and frame position   (PL and P)%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i= 1:n
     T = TT(:,:,i);
     z(:, i) = T(1:3, 3);
     P(:,i) = T(1:3, 4);
     
     % Calculating PL
     if i==1
         %fprintf('This should be 1x3///////////////')
         P(:,i);
        PL(:,i) = (P(:,i) + P0)/2;     %%Possible source of error........
     else
        PL(:, i) = (P(:,i) + P(:,i-1))/2;
     end 
end




%%%%%%%%%%%%% Getting the Jacobians   %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------Calculating JpL ---------------------------
for i = 1:n
    %temp_jpl is the jacobian matrix for the link i which is then added to
    %the multidimensional jacobian matrix at the end of the loop
    temp_jpl = sym(zeros(3,n));
    for j=1:n
        if j<=i
            if isprismatic(L(j))
                %calculating the current Jpl
                if j == 1
                    temp_jpl(:,j) = z0;
                else
                    temp_jpl(:, j) = z(j-1);
                end
            elseif isrevolute(L(j))
                if j==1
                    temp_jpl(:,j) = cross(z0, (PL(:,i) - P0));
                else
                    z(:,j-1);
                    PL(:,i);
                    P(:,j-1);
                    temp_jpl(:,j) = cross(z(:,j-1), (PL(:,i) - P(:,j-1)));
                end
            end
        else
            temp_jpl(:,j) = [ 0 0 0]';
        end
    end
    JpL(:,:,i) = temp_jpl;
end
%fprintf('JpL');
JpL;


% ------------------- Calculating JoL -------------------------------
for i= 1:n
    temp_jol = sym(zeros(3,n));
    for j =1:n
        if j<=i % as when i> j the values are all zeros
            if isprismatic(L(j))
                temp_jol(:,j) = [0 0 0]';
            elseif isrevolute(L(j))
                if j == 1
                    temp_jol(:,j) = z0; 
                else
                    temp_jol(:,j) = z(:, j-1);
                end
            end
        else
            temp_jol(:,j) = [0 0 0]'; 
        end
    end
    JoL(:, :, i) = temp_jol; 
end
JoL


% ------------------ Calculating JpM --------------------------------
for i = 1:n
    %temp_jpm is the jacobian matrix for the link i which is then added to
    %the multidimensional jacobian matrix at the end of the loop
    temp_jpm = sym(zeros(3,n));
    for j=1:n
        if j<i
            if isprismatic(L(j))
                %calculating the current Jpl
                if j == 1
                    temp_jpm(:,j) = z0;
                else
                    temp_jpm(:, j) = z(j-1);
                end
            elseif isrevolute(L(j))
                if j==1
                    temp_jpm(:,j) = cross(z0, (P(:,i-1) - P0));
                else
                    z(:,j-1);
                    PL(:,i);
                    P(:,j-1);
                    temp_jpm(:,j) = cross(z(:,j-1), (P(:,i-1) - P(:,j-1)));
                end
            end
        else
            temp_jpm(:,j) = [ 0 0 0]';
        end
    end
    JpM(:,:,i) = temp_jpm; 
end
%fprintf('JpM')
JpM


% -------------------- Calculating JoM --------------------------------
n;
for  i = 1:n
    temp_jom = sym(zeros(3,n));
    for j = 1:n
        if j < i
            JoL(:, j, i);
            temp_jom(:,j) = JoL(:, j, i);
        elseif j == i
            if i == 1
                temp_jom(:,j) = kr(i)*z0; 
            else
                z(:, i-1)
                temp_jom(:,j) = kr(i)*z(:, i-1);
            end
        else
            temp_jom(:,j) = [0 0 0]'; 
        end
    end
    JoM(:,:,i) = temp_jom ;
end
%fprintf('JoM')
JoM;



%mL = sym('mL', [1 n]);
%mM = sym('mM', [1 n]);
%I = sym('I', [1 n]);

%Im = sym('Im', [1 n]);

%%%Mike's test variables ---delete
%IL = sym('IL', [1 n]);
%IM = sym('IM', [1 n]);


for i=1:n
    % Get the Ri matrix
    T = TT(:,:,i);
    R = T(1:3, 1:3);
    if i == 1
        Tm = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
    else
        Tm = TT(:,:, i-1);
    end
    
    Rm = Tm(1:3, 1:3);
    B_temp(:,:,i) = mL(i)*transpose(JpL(:, :, i))*JpL(:,:,i)  + transpose(JoL(:,:,i))*R*I(i)*transpose(R)*JoL(:,:,i)  + mM(i)*transpose(JpM(:,:,i))*JpM(:,:,i)   + transpose(JoM(:,:,i))*Rm*Im(i)*transpose(Rm)*JoM(:,:,i);
end

%----------------------------- Calculating B Matrix --------------------------------------

B = zeros(n, n);
for i= 1:n
    B = B + B_temp(:,:,i); 
end
B;

BB = zeros(n, n);
% Compute B (pre-determine moments of inertia with respect to base frame)
for i = 1:n
    BB = BB + (mL(i)*transpose(JpL(:,:,i))*JpL(:,:,i) + transpose(JoL(:,:,i))*IL(i)*JoL(:,:,i) + mM(i)*transpose(JpM(:,:,i))*JpM(:,:,i) + transpose(JoM(:,:,i))*IM(i)*JoM(:,:,i));
end
BB;

C = sym(zeros(n,n));
% Compute C (centrifugal/Coriolis effects)
for i = 1:n
    for j = 1:n
        for k = 1:n
            C(i,j) = C(i,j) + 0.5*(diff(B(i,j),q(k)) + diff(B(i,k),q(j)) - diff(B(j,k),q(i)))*qdot(k);
        end
    end
end
C;


G = zeros(n,n);
%%%%DELETE%%%%%%
%x0 = [-1; 0; 0];
%g0 = g*x0;
% Compute G (gravity)
for i = 1:n
    %G = G - mL(i)*transpose(g0)*JpL(:,:,i)% - mM(i)*transpose(g0)*JpM(:,:, i);
    G = G - mL(i)*transpose(g0)*JpL(:,:,i) - mM(i)*transpose(g0)*JpM(:,:, i);
end
G;
size_C = size(C);
size_B = size(B);
size_G = size(G);
% Compute equations of motion
for i = 1:n
    eom = B*transpose(qddot) + C*transpose(qdot)  + transpose(G);
end


%Saving all the important variables to the workspace
%saving B matrix
main_u = eom(:,1)
main_u = simplify(main_u)
assignin('base', 'main_B_matrix', B);
assignin('base', 'main_C_matrix', C); 
assignin('base', 'main_G_matrix', G);
assignin('base', 'main_u', main_u);



end
