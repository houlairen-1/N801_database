function fsym = symfea(f,T,order,type)
% Marginalization by sign and directional symmetry for a feature vector
% stored as one of our 2*(2T+1)^order-dimensional feature vectors. This
% routine should be used for features possiessing sign and directional
% symmetry, such as spam-like features or 3x3 features. It should NOT be
% used for features from MINMAX residuals. Use the alternative
% symfea_minmax for this purpose.
% The feature f is assumed to be a 2dim x database_size matrix of features
% stored as columns (e.g., hor+ver, diag+minor_diag), with dim =
% 2(2T+1)^order.
    fsym=[];
    
    [dim,N] = size(f);
    B = 2*T+1;
    c = B^order;
    ERR = 1;

    if strcmp(type,'spam')
        if dim == 2*c
            switch order    % Reduced dimensionality for a B^order dimensional feature vector
                case 1, red = T + 1;
                case 2, red = (T + 1)^2;
                case 3, red = 1 + 3*T + 4*T^2 + 2*T^3;
                case 4, red = B^2 + 4*T^2*(T + 1)^2;
                case 5, red = 1/4*(B^2 + 1)*(B^3 + 1);
            end
            fsym = zeros(2*red,N);

            for i = 1 : N
                switch order
                    case 1, cube = f(1:c,i);
                    case 2, cube = reshape(f(1:c,i),[B B]);
                    case 3, cube = reshape(f(1:c,i),[B B B]);
                    case 4, cube = reshape(f(1:c,i),[B B B B]);
                    case 5, cube = reshape(f(1:c,i),[B B B B B]);
                end
                % [size(symm_dir(cube,T,order)) red]
                fsym(1:red,i) = symm(cube,T,order);
                switch order
                    case 1, cube = f(c+1:2*c,i);
                    case 2, cube = reshape(f(c+1:2*c,i),[B B]);
                    case 3, cube = reshape(f(c+1:2*c,i),[B B B]);
                    case 4, cube = reshape(f(c+1:2*c,i),[B B B B]);
                    case 5, cube = reshape(f(c+1:2*c,i),[B B B B B]);
                end
                fsym(red+1:2*red,i) = symm(cube,T,order);
            end
        else
            fsym = [];
            fprintf('*** ERROR: feature dimension is not 2x(2T+1)^order. ***\n')
        end
        ERR = 0;
    end

    if strcmp(type,'mnmx')
        if dim == 2*c
            switch order
                case 3, red = B^3 - T*B^2;          % Dim of the marginalized set is (2T+1)^3-T*(2T+1)^2
                case 4, red = B^4 - 2*T*(T+1)*B^2;  % Dim of the marginalized set is (2T+1)^4-2T*(T+1)*(2T+1)^2
            end
            fsym = zeros(red, N);
            for i = 1 : N
                switch order
                    case 1, cube_min = f(1:c,i); cube_max = f(c+1:2*c,i);
                    case 2, cube_min = reshape(f(1:c,i),[B B]); cube_max = reshape(f(c+1:2*c,i),[B B]); f_signsym = cube_min + cube_max(end:-1:1,end:-1:1);
                    case 3, cube_min = reshape(f(1:c,i),[B B B]); cube_max = reshape(f(c+1:2*c,i),[B B B]);  f_signsym = cube_min + cube_max(end:-1:1,end:-1:1,end:-1:1);
                    case 4, cube_min = reshape(f(1:c,i),[B B B B]); cube_max = reshape(f(c+1:2*c,i),[B B B B]);  f_signsym = cube_min + cube_max(end:-1:1,end:-1:1,end:-1:1,end:-1:1);
                    case 5, cube_min = reshape(f(1:c,i),[B B B B B]); cube_max = reshape(f(c+1:2*c,i),[B B B B B]);  f_signsym = cube_min + cube_max(end:-1:1,end:-1:1,end:-1:1,end:-1:1,end:-1:1);
                end
                % f_signsym = cube_min + cube_max(end:-1:1,end:-1:1,end:-1:1);
                fsym(:,i) = symm_dir(f_signsym,T,order);
            end
        end
        ERR = 0;
    end

    if ERR == 1, fprintf('*** ERROR: Feature dimension and T, order incompatible. ***\n'), end
end