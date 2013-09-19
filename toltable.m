classdef toltable
    properties
        keys
        dims
        array_hi
        array_lo
    end
    methods
        function self = toltable()
            self.keys = {'G7', 'H7'}
            self.dims = [6, 10; 10, 14]
            self.array_hi = zeros(length(self.dims), length(self.keys));
            self.array_lo = zeros(length(self.dims), length(self.keys));;
        end
        
        function tol = get(self, key, dim)
            self
        end
    end
    methods(Static)
        function set(self, key, dim, high, low)
            for i = 1:length(self.keys)
                if strcmp(self.keys{i}, key)
                    break;
                end 
            end
            d = find(dim >= self.dims(:,1) & dim < self.dims(:,2));
            self.array_hi(d, i) = high;
            self.array_lo(d, i) = low;
        end
    end
end