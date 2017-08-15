function As = symm(A,T,order)
% Symmetry marginalization routine. The purpose is to reduce the feature
% dimensionality and make the features more populated. It can be applied to
% 1D -- 5D co-occurrence matrices (order \in {1,2,3,4,5}) with sign and 
% directional symmetries (explained below). 
% A must be an array of (2*T+1)^order, otherwise error is outputted.
%
% Marginalization by symmetry pertains to the fact that, fundamentally,
% the differences between consecutive pixels in a natural image (both cover
% and stego) d1, d2, d3, ..., have the same probability of occurrence as the
% triple -d1, -d2, -d3, ...
%
% Directional marginalization pertains to the fact that the 
% differences d1, d2, d3, ... in a natural (cover and stego) image are as
% likely to occur as ..., d3, d2, d1.

    ERR = 1;  % Flag denoting when size of A is incompatible with the input parameters T and order
    m = 2;
    B = 2*T + 1;

    switch order
        case 1  % First-order coocs are only symmetrized
            if numel(A) == 2*T+1
               As(1) = A(T+1);  % The only non-marginalized bin is the origin 0
               As(2:T+1) = A(1:T) + A(T+2:end);
               As = As(:);
               ERR = 0;
            end
        case 2
            if numel(A) == (2*T+1)^2
                As = zeros((T+1)^2, 1);
                As(1) = A(T+1,T+1); % The only non-marginalized bin is the origin (0,0)
                for i = -T : T
                    for j = -T : T
                        if (done(i+T+1,j+T+1) == 0) && (abs(i)+abs(j) ~= 0)
                            As(m) = A(i+T+1,j+T+1) + A(T+1-i,T+1-j);
                            done(i+T+1,j+T+1) = 1;
                            done(T+1-i,T+1-j) = 1;
                            if (i ~= j) && (done(j+T+1,i+T+1) == 0)
                                As(m) = As(m) + A(j+T+1,i+T+1) + A(T+1-j,T+1-i);
                                done(j+T+1,i+T+1) = 1;
                                done(T+1-j,T+1-i) = 1;
                            end
                            m = m + 1;
                        end
                    end
                end
                ERR = 0;
            end
        case 3
            if numel(A) == B^3
                done = zeros(size(A));
                As = zeros(1+3*T+4*T^2+2*T^3, 1);
                As(1) = A(T+1,T+1,T+1); % The only non-marginalized bin is the origin (0,0,0)
                for i = -T : T
                    for j = -T : T
                        for k = -T : T
                            if (done(i+T+1,j+T+1,k+T+1) == 0) && (abs(i)+abs(j)+abs(k) ~= 0)
                                As(m) = A(i+T+1,j+T+1,k+T+1) + A(T+1-i,T+1-j,T+1-k);
                                done(i+T+1,j+T+1,k+T+1) = 1;
                                done(T+1-i,T+1-j,T+1-k) = 1;
                                if (i ~= k) && (done(k+T+1,j+T+1,i+T+1) == 0)
                                    As(m) = As(m) + A(k+T+1,j+T+1,i+T+1) + A(T+1-k,T+1-j,T+1-i);
                                    done(k+T+1,j+T+1,i+T+1) = 1;
                                    done(T+1-k,T+1-j,T+1-i) = 1;
                                end
                                m = m + 1;
                            end
                        end
                    end
                end
                ERR = 0;
            end
        case 4
            if numel(A) == (2*T+1)^4
                done = zeros(size(A));
                As = zeros(B^2 + 4*T^2*(T+1)^2, 1);
                As(1) = A(T+1,T+1,T+1,T+1); % The only non-marginalized bin is the origin (0,0,0,0)
                for i = -T : T
                    for j = -T : T
                        for k = -T : T
                            for n = -T : T
                                if (done(i+T+1,j+T+1,k+T+1,n+T+1) == 0) && (abs(i)+abs(j)+abs(k)+abs(n)~=0)
                                    As(m) = A(i+T+1,j+T+1,k+T+1,n+T+1) + A(T+1-i,T+1-j,T+1-k,T+1-n);
                                    done(i+T+1,j+T+1,k+T+1,n+T+1) = 1;
                                    done(T+1-i,T+1-j,T+1-k,T+1-n) = 1;
                                    if ((i ~= n) || (j ~= k)) && (done(n+T+1,k+T+1,j+T+1,i+T+1) == 0)
                                        As(m) = As(m) + A(n+T+1,k+T+1,j+T+1,i+T+1) + A(T+1-n,T+1-k,T+1-j,T+1-i);
                                        done(n+T+1,k+T+1,j+T+1,i+T+1) = 1;
                                        done(T+1-n,T+1-k,T+1-j,T+1-i) = 1;
                                    end
                                    m = m + 1;
                                end
                            end
                        end
                    end
                end
                ERR = 0;
            end
        case 5
            if numel(A) == (2*T+1)^5
                done = zeros(size(A));
                As = zeros(1/4*(B^2 + 1)*(B^3 + 1), 1);
                As(1) = A(T+1,T+1,T+1,T+1,T+1); % The only non-marginalized bin is the origin (0,0,0,0,0)
                for i = -T : T
                    for j = -T : T
                        for k = -T : T
                            for l = -T : T
                                for n = -T : T
                                    if (done(i+T+1,j+T+1,k+T+1,l+T+1,n+T+1) == 0) && (abs(i)+abs(j)+abs(k)+abs(l)+abs(n)~=0)
                                        As(m) = A(i+T+1,j+T+1,k+T+1,l+T+1,n+T+1) + A(T+1-i,T+1-j,T+1-k,T+1-l,T+1-n);
                                        done(i+T+1,j+T+1,k+T+1,l+T+1,n+T+1) = 1;
                                        done(T+1-i,T+1-j,T+1-k,T+1-l,T+1-n) = 1;
                                        if ((i ~= n) || (j ~= l)) && (done(n+T+1,l+T+1,k+T+1,j+T+1,i+T+1) == 0)
                                            As(m) = As(m) + A(n+T+1,l+T+1,k+T+1,j+T+1,i+T+1) + A(T+1-n,T+1-l,T+1-k,T+1-j,T+1-i);
                                            done(n+T+1,l+T+1,k+T+1,j+T+1,i+T+1) = 1;
                                            done(T+1-n,T+1-l,T+1-k,T+1-j,T+1-i) = 1;
                                        end
                                        m = m + 1;
                                    end
                                end
                            end
                        end
                    end
                end
                ERR = 0;
            end
        otherwise
            As = [];
            fprintf('  Order of cooc is not in {1,2,3,4,5}.\n')
    end

    if ERR == 1
        As = [];
        fprintf('*** ERROR in symm: The number of elements in the array is not (2T+1)^order. ***\n')
    end

     As = As(:);
end