function draw_grid(ri, ry, z0, z1, nr, nz)
    [X, Y] = meshgrid(linspace(ri,ry, nr), linspace(z0,z1, nz));
    Z = zeros(nz, nr);
%     mesh(X,Y,Z)
    plot(X,Y, '.');