function Y = Quant(X,q,T)
% Quantization routine
% X ... variable to be quantized/truncated
% T ... threshold
% q ... quantization step (with type = 'scalar') or a vector of increasing
% non-negative integers outlining the quantization process.
% Y ... quantized/truncated variable
% Example 0: when q is a positive scalar, Y = trunc(round(X/q),T)
% Example 1: q = [0 1 2 3] quantizes 0 to 0, 1 to 1, 2 to 2, [3,Inf) to 3,
% (-Inf,-3] to -3, -2 to -2, -1 to -1. It is equivalent to Quant(.,3,1).
% Example 2: q = [0 2 4 5] quantizes 0 to 0, {1,2} to 1, {3,4} to 2,
% [5,Inf) to 3, and similarly with the negatives.
% Example 3: q = [1 2] quantizes {-1,0,1} to 0, [2,Inf) to 1, (-Inf,-2] to -1.
% Example 4: q = [1 3 7 15 16] quantizes {-1,0,1} to 0, {2,3} to 1, {4,5,6,7}
% to 2, {8,9,10,11,12,13,14,15} to 3, [16,Inf) to 4, and similarly the
% negatives.

    if numel(q) == 1
        if q > 0, Y = trunc(round(X/q),T);
        else fprintf('*** ERROR: Attempt to quantize with non-positive step. ***\n'),end
    else
        q = round(q);   % Making sure the vector q is made of integers
        if min(q(2:end)-q(1:end-1)) <= 0
            fprintf('*** ERROR: quantization vector not strictly increasing. ***\n')
        end
        if min(q) < 0, fprintf('*** ERROR: Attempt to quantize with negative step. ***\n'),end

        T = q(end);   % The last value determines the truncation threshold
        v = zeros(1,2*T+1);   % value-substitution vector
        Y = trunc(X,T)+T+1;   % Truncated X and shifted to positive values
        if q(1) == 0
            v(T+1) = 0; z = 1; ind = T+2;
            for i = 2 : numel(q)
                v(ind:ind+q(i)-q(i-1)-1) = z;
                ind = ind+q(i)-q(i-1);
                z = z+1;
            end
            v(1:T) = -v(end:-1:T+2);
        else
            v(T+1-q(1):T+1+q(1)) = 0; z = 1; ind = T+2+q(1);
            for i = 2 : numel(q)
                v(ind:ind+q(i)-q(i-1)-1) = z;
                ind = ind+q(i)-q(i-1);
                z = z+1;
            end
            v(1:T-q(1)) = -v(end:-1:T+2+q(1));
        end
        Y = v(Y);   % The actual quantization :)
    end
end