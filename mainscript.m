%% 
% Example script for analyzing of three rings with grip contact.

clear 

omega = 0.0         % Rotational speed of coupling, not well tested.

%% Setup materials
steel = material();
steel.E = 210e9;        % Module of elasitcity
steel.v = .3;           % Poisson ration
steel.rho = 7.8e3;      % Density

alum = material();
alum.E = 70e9;
alum.v = .3;
alum.rho = 2.8e3;

carb = material();
carb.E = 1000e9;
carb.v = .3;
carb.rho = 3.0e3;

%% Geometry
% Define the rings in the analysis. 
ring1 = element(10e-3, 15e-3, steel)
ring2 = element(15e-3 - 10e-6, 17e-3, alum)
ring3 = element(17e-3 + 1e-6, 21e-3, steel)
ring4 = element(21e-3 - 5e-6, 22e-3, carb)
ring5 = element(22e-3, 31e-3, steel)
rings = [ring1, ring2, ring3, ring4, ring5]

mu = [0.05, 0.1, 0.1, 0.1]        % Friction coefficient
h = 20e-3               % Height of the coupling

%% Initiate some objects
nr = length(rings)
Fn = zeros(nr*2,1)
Kn = zeros(nr*2,nr*2)

%% First ring boundary conditions
Fn(1) = (3+rings(1).matrl.v)/8*rings(1).ri^2*rings(1).matrl.rho*omega^2
Kn(1,1) = rings(1).matrl.E/(1-rings(1).matrl.v^2)*(1+rings(1).matrl.v)
Kn(1,2) = rings(1).matrl.E/(1-rings(1).matrl.v^2)*(rings(1).matrl.v-1)/rings(1).ri^2

%% Assemble the middle rings into the analysis
for i=1:nr-1
    E1 = rings(i).matrl.E
    rho1 = rings(i).matrl.rho
    v1 = rings(i).matrl.v
    E2 = rings(i+1).matrl.E
    rho2 = rings(i+1).matrl.rho
    v2 = rings(i+1).matrl.v
    
    ri = rings(i).ri
    ry = rings(i).ry
    Ri = rings(i+1).ri
    Ry = rings(i+1).ry
    
    C1 = (1-v1^2)/E1*rho1*omega^2;
    C2 = (1-v2^2)/E2*rho2*omega^2;
    grip = Ri - ry
    
    Fn(2*i) = 1/8*C1*ry^3 - 1/8*C2*Ri^3 + grip
    Kn(2*i, 2*i-1:2*i+2) = [ry 1/ry -Ri -1/Ri]
    
    Kn(2*i+1, 2*i-1:2*i) = E1/(1-v1^2)*[(1+v1) (v1-1)/ry^2]
    Kn(2*i+1, 2*i+1:2*i+2) = E2/(1-v2^2)*[-(1+v2) -(v2-1)/Ri^2]
end

%% Last ring boundary conditions
Fn(2*nr) = (3+rings(nr).matrl.v)/8*rings(nr).ry^2*rings(nr).matrl.rho*omega^2
Kn(2*nr,2*nr-1) = rings(nr).matrl.E/(1-rings(nr).matrl.v^2)*(1+rings(nr).matrl.v)
Kn(2*nr,2*nr) = rings(nr).matrl.E/(1-rings(nr).matrl.v^2)*(rings(nr).matrl.v-1)/rings(nr).ry^2

%% Solve the system
X = Kn\Fn

%% Plot results
figure(1)
clf
subplot(3,1,1:2)
% Plot the stress distribution
title('Stress Distribution')
ylabel('Stress (Pa)')
grid
hold on
subplot(3,1,3)
% Plot the maximum allowed contact torques
title('Maximum Torque in Couplings')
ylabel('Torque (Nm)')
xlabel('Deformed Coordinates (m)')
hold on

figure(2)
% Plot the deformations
clf
hold on
title('Displacement Distribution')
xlim([0 rings(nr).ry])
xlabel('Deformed Coordinates (m)')
ylabel('Displacement (m)')
grid on

% Post processing
for i=1:nr
    E1 = rings(i).matrl.E;
    rho1 = rings(i).matrl.rho;
    v1 = rings(i).matrl.v;
    
    ri = rings(i).ri
    ry = rings(i).ry
    
    % C1 = Deformations due to rotations and centrifugal forces
    C1 = (1-v1^2)/E1*rho1*omega^2;
    
    i
    
    % r will be used as a symbolic variable
    syms r
    % Calculate deformation function
    u = [r 1/r]*X(2*i-1:2*i) - 1/8*C1*r^3
    % Calculate stress function
    sigma = E1/(1-v1^2)*[1+v1 (v1-1)/r^2]*X(2*i-1:2*i) - (3+v1)/8*r^2*rho1*omega^2
    
    % Sample the deformations and stresses at required resolution.
    n = 25;
    r_vect = linspace(ri,ry,n);                 % Sample points
    u_vect = double(subs(u, r, r_vect));
    s_vect = double(subs(sigma, r, r_vect));
    
    % Plot the results
    figure(1)
    subplot(3,1,1:2)
    hold on
    plot(r_vect + u_vect, s_vect, 'color', rand(3,1), 'LineWidth', 2)
    xlim([0 rings(nr).ry])
    figure(2)
    plot(r_vect + u_vect, u_vect, 'color', rand(3,1), 'LineWidth', 2)
end
% Calculate the contact torques
for i=1:nr-1
    u = [r 1/r]*X(2*i-1:2*i) - 1/8*C1*r^3;
    sigma = E1/(1-v1^2)*[1+v1 (v1-1)/r^2]*X(2*i-1:2*i) - (3+v1)/8*r^2*rho1*omega^2;
    
    ri = rings(i).ri
    ry = rings(i).ry
    
    % sy = contact pressure
    sy = double(subs(sigma, r, ry));
    
    % total normal-direction pressure in contact
    f = -sy*mu(i)*2*ry*pi*h;
    
    % torque in contact
    T = f*ry
    
    % plot result
    figure(1)
    subplot(3,1,3)
    hold on
    plot([ry ry], [0 T], 'linewidth', 5)
    xlim([0 rings(nr).ry])
end
grid on