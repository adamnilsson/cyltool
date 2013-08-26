
clear

Pi = 0
Py = 0
dy = 1e-3
rpm = 100.0

ri = 10e-3
ry = 15e-3
Ri = 15e-3 - 10e-6
Ry = 19e-3
ti = 19e-3 + 2e-6
ty = 22e-3

grip = Ri-ry
grip2 = ti-Ry

E = 210e9
v = .3
rho = 7e3
omega = rpm/60*2*pi

syms r

%%%
Fn = zeros(6,1)
Kn = zeros(6,6)

Fn(1) = Pi + (3+v)/8*ri^2*rho*omega^2
Kn(1,:) = E/(1-v^2)*[1+v (v-1)/ri^2 0 0 0 0]

%%% 1-2
C = (1-v^2)/E*rho*omega^2
Fn(2) = 1/8*C*ry^3 - 1/8*C*Ri^3 + grip
Kn(2,:) = [ry 1/ry -Ri -1/Ri 0 0]

Fn(3) = 0
Kn(3,:) = E/(1-v^2)*[1+v (v-1)/ry^2 -(1+v) -(v-1)/Ri^2 0 0]


%%% 2-3
C = (1-v^2)/E*rho*omega^2
Fn(4) = 1/8*C*Ry^3 - 1/8*C*ti^3 + grip2
Kn(4,:) = [0 0 Ry 1/Ry -ti -1/ti]

Fn(5) = 0
Kn(5,:) = E/(1-v^2)*[0 0 1+v (v-1)/Ry^2 -(1+v) -(v-1)/ti^2 ]


%%% 3
Fn(6) = Py + (3+v)/8*ty^2*rho*omega^2
Kn(6,:) = E/(1-v^2)*[0 0 0 0 1+v (v-1)/ty^2]


%%%

A = Kn\Fn

% C = subs((1-v^2)/E*rho*omega^2, [E, rho, omega, v], [210e9, 7e3, rpm/60*pi*2, .3])
u1 = [r 1/r 0 0   0 0]*A - 1/8*C*r^3
u2 = [0 0   r 1/r 0 0]*A - 1/8*C*r^3
u3 = [0 0   0 0   r 1/r]*A - 1/8*C*r^3

sigma1 = E/(1-v^2)*[1+v (v-1)/r^2 0 0 0 0]*A - (3+v)/8*r^2*rho*omega^2
sigma2 = E/(1-v^2)*[0 0 1+v (v-1)/r^2 0 0]*A - (3+v)/8*r^2*rho*omega^2
sigma3 = E/(1-v^2)*[0 0 0 0 1+v (v-1)/r^2]*A - (3+v)/8*r^2*rho*omega^2

n = 25
r1_vect = linspace(ri,ry,n)
u1_vect = double(subs(u1, r, r1_vect))
s1_vect = double(subs(sigma1, r, r1_vect))

r2_vect = linspace(Ri,Ry,n)
u2_vect = double(subs(u2, r, r2_vect))
s2_vect = double(subs(sigma2, r, r2_vect))

r3_vect = linspace(ti,ty,n)
u3_vect = double(subs(u3, r, r3_vect))
s3_vect = double(subs(sigma3, r, r3_vect))
clf
figure(1)
hold on
plot(r1_vect + u1_vect, s1_vect, 'r')
plot(r2_vect + u2_vect, s2_vect, 'b')
plot(r3_vect + u3_vect, s3_vect, 'g')