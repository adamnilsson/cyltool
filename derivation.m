clear
syms E v r T dT_dr ar af sr sf er ef der_dr def_dr u u_r du_dr d2u_dr2

er = du_dr
der_dr = d2u_dr2
ef = u/r
def_dr = du_dr/r - u/(r^2)

syms Ct1 Ct2
T = Ct1*r + Ct2
dT_dr = Ct1


% S = E/(1-v^2)*[1 v; v 1]*[er; ef]
% dS_dr = E/(1-v^2)*[1 v; v 1]*[der_dr; def_dr]
ar = 0
T = 0
af = 0

S = E/(1-v^2)*[1 v; v 1]*[er + ar*T; ef + af*T]
dS_dr = E/(1-v^2)*[1 v; v 1]*[der_dr + ar*dT_dr; def_dr + af*dT_dr]
sr = S(1)
sf = S(2)
dsr_dr = dS_dr(1)

lhs = simplify((dsr_dr + sr/r - sf/r))


lhs = simplify((dsr_dr + sr/r - sf/r)*(v^2-1)/E)
expand(lhs)

subs(expand(lhs), [T dT_dr], [0 0])

syms c0 c1 c2 c3 c4 c5
C = []


% C = [c0; c1; c2; c3; c4; c5];
% C = [c0; c1; c2];
% C = [c0; c1; c2; c3];
C = [c1; c2; c3; c4];
% C = [c0; c1; c2; c3; c4; c5];
% un = [r^(-2) r^-1 1 r r^2 r^3]*C
% un = [r^(-2) r^-1 1 r r^2 r^3]*C
un = [1 r r^2 r^3]*C
% un = [r^-1 1 r r^2 r^3]*C
% un = [r^(-2) r^-1 1 r r^2 r^3]*C

expr = simplify(subs(lhs, [u, du_dr, d2u_dr2], [un, diff(un), diff(un,r,2)]))
jac_lhs = jacobian(lhs, C)
jac = jacobian(expr, C)
residual = simplify(expr - jac*C)
res_p = subs(residual, [Ct1, Ct2, ar, af, v], [.2 2 1 1.2 .3])
plot(double(vpa(subs(res_p, r, linspace(1, 2)))))



x0 = 0.1
x1 = 0.2

syms x

% Shape functions
N = [(x1-x)/(x1-x0) (x0-x)/(x0-x1)]
subs(N, x, [x0; x1])
N.'*N

int(N.'*N, x0, x1)






