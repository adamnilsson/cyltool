classdef material
    properties
        E
        v
        rho
        alpha
    end
    methods(Static)
        function lib = library()
            % returns a standard material library in si units 
            % Setup standard materials
            steel = material();
            steel.E = 210e9;        % Module of elasitcity
            steel.v = .3;           % Poisson ration
            steel.rho = 7.8e3;      % Density

            aluminum = material();
            aluminum.E = 70e9;
            aluminum.v = .3;
            aluminum.rho = 2.8e3;

            carbon = material();
            carbon.E = 1000e9;
            carbon.v = .3;
            carbon.rho = 3.0e3;
            
            lib = {};
            lib.steel = steel;
            lib.aluminum = aluminum;
            lib.carbon = carbon;
        end
    end
end