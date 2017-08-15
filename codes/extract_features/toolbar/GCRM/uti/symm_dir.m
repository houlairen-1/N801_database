function As = symm_dir(A,T,order)
% Symmetry marginalization routine. The purpose is to reduce the feature
% dimensionality and make the features more populated.
% A is an array of features of size (2*T+1)^order, otherwise error is outputted.
%
% Directional marginalization pertains to the fact that the 
% differences d1, d2, d3, ... in a natural (both cover and stego) image
% are as likely to occur as ..., d3, d2, d1.

% Basically, we merge all pairs of bins (i,j,k, ...) and (..., k,j,i) 
% as long as they are two different bins. Thus, instead of dim =
% (2T+1)^order, we decrease the dim by 1/2*{# of non-symmetric bins}.
% For order = 3, the reduced dim is (2T+1)^order - T(2T+1)^(order-1),
% for order = 4, it is (2T+1)^4 - 2T(T+1)(2T+1)^2.

    B = 2*T+1;
    done = zeros(size(A));
    switch order
        case 3, red = B^3 - T*B^2;          % Dim of the marginalized set is (2T+1)^3-T*(2T+1)^2
        case 4, red = B^4 - 2*T*(T+1)*B^2;  % Dim of the marginalized set is (2T+1)^4-2T*(T+1)*(2T+1)^2
        case 5, red = B^5 - 2*T*(T+1)*B^3;
    end
    As = zeros(red, 1);
    m = 1;

    switch order
        case 3
            for i = -T : T
                for j = -T : T
                    for k = -T : T
                        if k ~= i   % Asymmetric bin
                            if done(i+T+1,j+T+1,k+T+1) == 0
                                As(m) = A(i+T+1,j+T+1,k+T+1) + A(k+T+1,j+T+1,i+T+1);   % Two mirror-bins are merged
                                done(i+T+1,j+T+1,k+T+1) = 1;
                                done(k+T+1,j+T+1,i+T+1) = 1;
                                m = m + 1;
                            end
                        else        % Symmetric bin is just copied
                            As(m) = A(i+T+1,j+T+1,k+T+1);
                            done(i+T+1,j+T+1,k+T+1) = 1;
                            m = m + 1;
                        end
                    end
                end
            end
        case 4
            for i = -T : T
                for j = -T : T
                    for k = -T : T
                        for n = -T : T
                            if (i ~= n) || (j ~= k)   % Asymmetric bin
                                if done(i+T+1,j+T+1,k+T+1,n+T+1) == 0
                                    As(m) = A(i+T+1,j+T+1,k+T+1,n+T+1) + A(n+T+1,k+T+1,j+T+1,i+T+1);  % Two mirror-bins are merged
                                    done(i+T+1,j+T+1,k+T+1,n+T+1) = 1;
                                    done(n+T+1,k+T+1,j+T+1,i+T+1) = 1;
                                    m = m + 1;
                                end
                            else                      % Symmetric bin is just copied
                                As(m) = A(i+T+1,j+T+1,k+T+1,n+T+1);
                                done(i+T+1,j+T+1,k+T+1,n+T+1) = 1;
                                m = m + 1;
                            end
                        end
                    end
                end
            end
         case 5
            for i = -T : T
                for j = -T : T
                    for k = -T : T
                        for l = -T : T
                            for n = -T : T
                                if (i ~= n) || (j ~= l)   % Asymmetric bin
                                    if done(i+T+1,j+T+1,k+T+1,l+T+1,n+T+1) == 0
                                        As(m) = A(i+T+1,j+T+1,k+T+1,l+T+1,n+T+1) + A(n+T+1,l+T+1,k+T+1,j+T+1,i+T+1);  % Two mirror-bins are merged
                                        done(i+T+1,j+T+1,k+T+1,l+T+1,n+T+1) = 1;
                                        done(n+T+1,l+T+1,k+T+1,j+T+1,i+T+1) = 1;
                                        m = m + 1;
                                    end
                                else                      % Symmetric bin is just copied
                                    As(m) = A(i+T+1,j+T+1,k+T+1,l+T+1,n+T+1);
                                    done(i+T+1,j+T+1,k+T+1,l+T+1,n+T+1) = 1;
                                    m = m + 1;
                                end
                            end
                        end
                    end
                end
            end
        otherwise
            fprintf('*** ERROR: Order not equal to 3 or 4 or 5! ***\n')
    end
end
