function Z = trunc(X,T)
% Truncation to [-T,T]
    Z = X;
    Z(Z > T)  =  T;
    Z(Z < -T) = -T;
end