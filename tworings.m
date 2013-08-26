
clear

Pi = 0
Py = 0
dy = 1e-3
rpm = 0.0

ri = 10e-3
ry = 15e-3
Ri = 15e-3 - 10e-6
Ry = 19e-3

grip = Ri-ry

E = 210e9
v = .3
rho = 7e3
omega = rpm/60*2*pi

syms r

%%%
Fn = zeros(4,1)
Kn = zeros(4,4)

Fn(1) = Pi + (3+v)/8*ri^2*rho*omega^2
Kn(1,:) = E/(1-v^2)*[1+v (v-1)/ri^2 0 0]




C = (1-v^2)/E*rho*omega^2
Fn(2) = 1/8*C*ry^3 - 1/8*C*Ri^3 + grip
Kn(2,:) = [ry 1/ry -Ri -1/Ri]


Fn(3) = 0
Kn(3,:) = E/(1-v^2)*[1+v (v-1)/ry^2 -(1+v) -(v-1)/Ri^2 ]


Fn(4) = Py + (3+v)/8*Ry^2*rho*omega^2
Kn(4,:) = E/(1-v^2)*[0 0 1+v (v-1)/Ry^2]


%%%

A = Kn\Fn

% C = subs((1-v^2)/E*rho*omega^2, [E, rho, omega, v], [210e9, 7e3, rpm/60*pi*2, .3])
u1 = [r 1/r 0 0]*A - 1/8*C*r^3
u2 = [0 0   r 1/r]*A - 1/8*C*r^3

sigma1 = E/(1-v^2)*[1+v (v-1)/r^2 0 0]*A - (3+v)/8*r^2*rho*omega^2
sigma2 = E/(1-v^2)*[0 0 1+v (v-1)/r^2]*A - (3+v)/8*r^2*rho*omega^2

n = 25
r1_vect = linspace(ri,ry,n)
u1_vect = double(subs(u1, r, r1_vect))
s1_vect = double(subs(sigma1, r, r1_vect))

r2_vect = linspace(Ri,Ry,n)
u2_vect = double(subs(u2, r, r2_vect))
s2_vect = double(subs(sigma2, r, r2_vect))
clf
figure(1)
hold on
plot(r1_vect + u1_vect, s1_vect)
plot(r2_vect + u2_vect, s2_vect)
% plot(r1_vect, r1_vect+u1_vect)
% plot(r2_vect, r2_vect + u2_vect)
% 
% ampl = 1
% [X,Y] = meshgrid(r_vect+u_vect*ampl, [0,1])
% Z = [u_vect; u_vect]
% clf
% contourf(X,Y,Z, n,'linecolor','none')
% hold on
% plot([0, 0], [-1., 1.1], '-.', 'linewidth', 3)
% 
% 
% r_max = max(max(r_vect+u_vect*ampl), max(r_vect))
% % r_min = min(-r_max*.05, -.1)
% r_min = -r_max*.05
% xlim([r_min,r_max])
% ylim([-.1, 1.1])
% 
% draw_grid(ri, ry, 0, 1, 10, 4)