clear
n = 100
lims = [2 6]
dx = (lims(2) - lims(1))/(n-1)
d2T = toeplitz([-2 1 zeros(1,n-2)]) / (dx^2);

dT = toeplitz([0 -1 zeros(1,n-2)], [0 1 zeros(1,n-2)]) / (2*dx)

T = eye(n)

% Test on u" + 3u' + 4u = 0
% u(0) = 1, u(1) = 3
M = d2T - 2*pi*dT + (1-pi^2)*T
F = zeros(n,1)
BC = [1 1; n 3]
U = solvep(M, F, BC)

% Analytic solution 
A = 1
B = (3*exp(3)-cos(sqrt(7)))/sin(sqrt(7))
t = linspace(0,1);
% Y = exp(-3*X).*(A*cos(sqrt(7)*X) + B*sin(sqrt(7)*X))
Y = (exp(t*(pi + (281474976710656*pi^2 + 2496571692229359)^(1/2)/16777216))*(exp(pi - (281474976710656*pi^2 + 2496571692229359)^(1/2)/16777216) - 3))/(exp(pi - (281474976710656*pi^2 + 2496571692229359)^(1/2)/16777216) - exp(pi + (281474976710656*pi^2 + 2496571692229359)^(1/2)/16777216)) - (exp(t*(pi - (281474976710656*pi^2 + 2496571692229359)^(1/2)/16777216))*(exp(pi + (281474976710656*pi^2 + 2496571692229359)^(1/2)/16777216) - 3))/(exp(pi - (281474976710656*pi^2 + 2496571692229359)^(1/2)/16777216) - exp(pi + (281474976710656*pi^2 + 2496571692229359)^(1/2)/16777216))
clf
plot(t,Y)
hold on 
plot(linspace(lims(1), lims(2), n), U, 'r-O')



clf
%%
r = linspace(1-dx/2, 2+dx/2, n)
i_R = diag(1./r)
i_R2 = diag(1./(r.^2))
M1 = d2T + i_R*dT - i_R2*T
M1 = M1(2:n-1, :)


r2 = linspace(2-dx/2, 3+dx/2, n)
i_R2 = diag(1./r)
i_R22 = diag(1./(r.^2))
M2 = d2T + i_R2*dT - i_R22*T
M2 = M2(2:n-1, :)
% F2 = zeros(n-2,1)

B = zeros(2, 2*n);
B1 = zeros(1, 2*n);
B1([1 2]) = [-1 1]/dx
B2 = zeros(1, 2*n);
B2([2*n-1 2*n]) = [-1 1]/dx
B(1,n-1:n+2) = [-1 -1 1 1]*.5
B(2,n-1:n+2) = [-1 1 1 -1]/dx

w1 = .3
w2 = w1
F = zeros(2*n,1) - [r'*w1^2; r2'*w2^2]
F(1) = 0
F(n+1) = 0
F(2*n) = 0
delta = 0.3;
F(n) = delta

Z = zeros(n-2, n);
M = [B1; M1 Z; B; Z M2; B2]
% 
% si = 1; sy = 0;
% F(1) = -si*dx;
% F(n) = -sy*dx;
% M(1,[1 2]) = [-1 1];
% M(n,[n-1 n]) = [-1 1];
% M(1,[1 2]) = [1 0]
% M(n,[n-1 n]) = [0 1]

U = M\F
plot(U, 'b.-')