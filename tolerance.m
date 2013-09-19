classdef tolerance
    properties
        nominal
        high
        low
        sigma
        mu
    end
    methods
        function self = tolerance(nominal, high, low)
            self.nominal = nominal;
            self.high = high;
            self.low = low;
            mu = (high + low)/2;
            self.mu = mu + nominal;
            offs = high-mu;
            self.sigma = offs/1.6449;
        end
        function pdf = pdf(self, X)
            pdf = normpdf(X, self.mu, self.sigma);
        end
        function cdf = cdf(self, X)
            cdf = normcdf(X, self.mu, self.sigma);
        end
%     end
%     methods(Static)
        function P = minus(A, B)
            P = A;
            P.nominal = A.nominal - B.nominal;
            P.mu= A.mu - B.mu;
            P.sigma = sqrt(A.sigma^2 + B.sigma^2);
            P.high = A.high - B.low;
            P.nominal = A.low - B.high;
        end
    end
end