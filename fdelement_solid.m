classdef fdelement_solid
    properties
        material
        dimension
        dim_offset
        nodes
    end
    methods
        function self = fdelement_solid(nodes, dimension)
            self.nodes = nodes;
            self.dimension = dimension;
            
            % Setup materials
            steel = material();
            steel.E = 210e9;        % Module of elasitcity
            steel.v = .3;           % Poisson ration
            steel.rho = 7.8e3;      % Density
            steel.alpha = [1 1]     % Heat expansion constant
            self.material = steel;
        end
        function M = equation(self)
            n = self.nodes;
            dx = self.dimension(1)/(n-1)
            d2T = toeplitz([-2 1 zeros(1,n-2)]) / (dx^2);
            dT = toeplitz([0 -1 zeros(1,n-2)], [0 1 zeros(1,n-2)]) / (2*dx);
            T = eye(n);
            
            r = linspace(0,self.dimension(1), n);
            i_R = diag(1./r);
            i_R2 = diag(1./r.^2);
            
            
            M = d2T + i_R*dT - i_R2*T;
            M = M(2:n,2:n);
            M(n-1, :) = self.boundary();
        end
        function B = boundary(self)
            n = self.nodes;
            dx = self.dimension(1)/(n-1);
            B = zeros(1, n-1);
            B([n-2 n-1]) = [-1 1]/dx;
        end
        function F = force(self, u1)
            
            n = self.nodes;
            
            r = linspace(0,self.dimension(1), n);
            i_R = diag(1./r);
            i_R2 = diag(1./r.^2);
            
            h = linspace(1,1,n)';
            H = diag(h);
            dH = eye(n)*0;
            
            Ct1 = self.material.alpha(1) + self.material.alpha(2)*self.material.v
            Ct2 = self.material.alpha(1) - self.material.alpha(2)*self.material.v - self.material.alpha(2) - self.material.alpha(1)*self.material.v
            
            n = self.nodes;
            F = -diag(dH*Ct1 + i_R*H*Ct2);
            F(1) = [];
            F(n-1) = u1 - (self.material.alpha(1))*H(n,n);
            
        end
        function U_r =solution_resample(self, U)
            n = self.nodes;
            U_r = [0; U(1:n-2); (U(n-2) + U(n-1))/2];
        end
        function R = grid(self)
            n = self.nodes;
            dx = self.dimension(1)/(n-1);
            R = linspace(0, self.dimension(1)+ dx/2, n);
            R(n) = self.dimension(1);
            R = R';
        end
    end
end