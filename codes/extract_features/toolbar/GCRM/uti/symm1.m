function fsym = symm1(f,T,order)
% Marginalization by sign and directional symmetry for a feature vector
% stored as a (2T+1)^order-dimensional array. The input feature f is 
% assumed to be a dim x database_size matrix of features stored as columns.

    [dim,N] = size(f);
    B = 2*T+1;
    c = B^order;
    ERR = 1;

    if dim == c
        ERR = 0;
        switch order    % Reduced dimensionality for a c-dimensional feature vector
            case 1, red = T + 1;
            case 2, red = (T + 1)^2;
            case 3, red = 1 + 3*T + 4*T^2 + 2*T^3;
            case 4, red = B^2 + 4*T^2*(T + 1)^2;
            case 5, red = 1/4*(B^2 + 1)*(B^3 + 1);
        end
        fsym = zeros(red,N);

        for i = 1 : N
            switch order
                case 1, cube = f(:,i);
                case 2, cube = reshape(f(:,i),[B B]);
                case 3, cube = reshape(f(:,i),[B B B]);
                case 4, cube = reshape(f(:,i),[B B B B]);
                case 5, cube = reshape(f(:,i),[B B B B B]);
            end
            % [size(symm_dir(cube,T,order)) red]
            fsym(:,i) = symm(cube,T,order);
        end
    end

    if ERR == 1, fprintf('*** ERROR in symm1: Feature dimension and T, order incompatible. ***\n'), end
end