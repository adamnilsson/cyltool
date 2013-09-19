classdef fdelement
    properties
        material
        dimension
        dim_offset
        type
        E
        v
        rho
    end
    methods
        function self = fdelement(type)
            if nargin < 1
                self.type = 'ring';
            else
                self.type = type;
            end
        end
    end
end