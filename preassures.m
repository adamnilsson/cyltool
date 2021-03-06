
clear

Pi = 0
Py = -60e6
rpm = 6000

ri = 10e-3
ry = 15e-3
% parameters

% lammes solution
% sigma_r = 1/(D^2-d^2)*(pi*d^2-py*D^2) - d^2*D^2/(4*(D^2-d^2))*(pi-py)/r^2
% sigma_f = 1/(D^2-d^2)*(pi*d^2-py*D^2) + d^2*D^2/(4*(D^2-d^2))*(pi-py)/r^2

syms r E v rho omega
M = E/(1-v^2)*[1+v (v-1)/r^2]
Fg = (3+v)/8*r^2*rho*omega^2

K = [subs(M, r, ri); subs(M, r, ry)]
Kn = subs(K, [E, v], [210e9, .3])
% Fgn = [0; 0]
Fgn = [subs(Fg, [r, rho, omega, v], [ri, 7e3, rpm/60*2*pi, .3]); 
       subs(Fg, [r, rho, omega, v], [ry, 7e3, rpm/60*2*pi, .3])]

Fbn = [Pi; Py]

Fn = Fbn + Fgn 
A = Kn\Fn

C = subs((1-v^2)/E*rho*omega^2*r^2, [E, rho, omega, v], [210e9, 7e3, rpm/60*pi*2, .3])
u = [r 1/r]*A + C
n = 25
r_vect = linspace(ri,ry,n)
u_vect = double(subs(u, r, r_vect))

ampl = 100
[X,Y] = meshgrid(r_vect+u_vect*ampl, [0,1])
Z = [u_vect; u_vect]
clf
contourf(X,Y,Z, n,'linecolor','none')
hold on
plot([0, 0], [-1., 1.1], '-.', 'linewidth', 3)


r_max = max(max(r_vect+u_vect*ampl), max(r_vect))
% r_min = min(-r_max*.05, -.1)
r_min = -r_max*.05
xlim([r_min,r_max])
ylim([-.1, 1.1])

draw_grid(ri, ry, 0, 1, 10, 4)