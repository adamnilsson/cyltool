%% ELEMENT
% Defines a ring in the analysis.
classdef element
    properties
        ri       %   double ri       - Inside radius in meters 
        ry       %   double ry       - Outside radius in meters
        matrl    %   material matrl  - Material object
    end
    methods
        function self = element(ri, ry, matrl)
            %% element
            %   element(ri, ry, matrl)
            %   double ri       - Inside radius in meters 
            %   double ry       - Outside radius in meters
            %   material matrl  - Material object
            self.ri = ri;
            self.ry = ry;
            self.matrl = matrl;
        end
    end
end