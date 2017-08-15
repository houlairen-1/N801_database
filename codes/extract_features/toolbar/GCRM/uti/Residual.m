function D = Residual(X,order,type)
% Computes the noise residual of a given type and order from MxN image X.
% residual order \in {1,2,3,4,5,6}
% type \in {hor,ver,diag,mdiag,KB,edge-h,edge-v,edge-d,edge-m}
% The resulting residual is an (M-b)x(N-b) array of the specified order,
% where b = ceil(order/2). This cropping is little more than it needs to 
% be to make sure all the residuals are easily "synchronized".
% !!!!!!!!!!!!! Use order = 2 with KB and all edge residuals !!!!!!!!!!!!!

    [M N] = size(X);
    I = 1+ceil(order/2) : M-ceil(order/2);
    J = 1+ceil(order/2) : N-ceil(order/2);

    switch type
        case 'hor'
            switch order
                case 1, D = - X(I,J) + X(I,J+1);
                case 2, D = X(I,J-1) - 2*X(I,J) + X(I,J+1);
                case 3, D = X(I,J-1) - 3*X(I,J) + 3*X(I,J+1) - X(I,J+2);
                case 4, D = -X(I,J-2) + 4*X(I,J-1) - 6*X(I,J) + 4*X(I,J+1) - X(I,J+2);
                case 5, D = -X(I,J-2) + 5*X(I,J-1) - 10*X(I,J) + 10*X(I,J+1) - 5*X(I,J+2) + X(I,J+3);
                case 6, D = X(I,J-3) - 6*X(I,J-2) + 15*X(I,J-1) - 20*X(I,J) + 15*X(I,J+1) - 6*X(I,J+2) + X(I,J+3);
            end
        case 'ver'
            switch order
                case 1, D = - X(I,J) + X(I+1,J);
                case 2, D = X(I-1,J) - 2*X(I,J) + X(I+1,J);
                case 3, D = X(I-1,J) - 3*X(I,J) + 3*X(I+1,J) - X(I+2,J);
                case 4, D = -X(I-2,J) + 4*X(I-1,J) - 6*X(I,J) + 4*X(I+1,J) - X(I+2,J);
                case 5, D = -X(I-2,J) + 5*X(I-1,J) - 10*X(I,J) + 10*X(I+1,J) - 5*X(I+2,J) + X(I+3,J);
                case 6, D = X(I-3,J) - 6*X(I-2,J) + 15*X(I-1,J) - 20*X(I,J) + 15*X(I+1,J) - 6*X(I+2,J) + X(I+3,J);
            end
        case 'diag'
            switch order
                case 1, D = - X(I,J) + X(I+1,J+1);
                case 2, D = X(I-1,J-1) - 2*X(I,J) + X(I+1,J+1);
                case 3, D = X(I-1,J-1) - 3*X(I,J) + 3*X(I+1,J+1) - X(I+2,J+2);
                case 4, D = -X(I-2,J-2) + 4*X(I-1,J-1) - 6*X(I,J) + 4*X(I+1,J+1) - X(I+2,J+2);
                case 5, D = -X(I-2,J-2) + 5*X(I-1,J-1) - 10*X(I,J) + 10*X(I+1,J+1) - 5*X(I+2,J+2) + X(I+3,J+3);
                case 6, D = X(I-3,J-3) - 6*X(I-2,J-2) + 15*X(I-1,J-1) - 20*X(I,J) + 15*X(I+1,J+1) - 6*X(I+2,J+2) + X(I+3,J+3);
            end
        case 'mdiag'
            switch order
                case 1, D = - X(I,J) + X(I-1,J+1);
                case 2, D = X(I-1,J+1) - 2*X(I,J) + X(I+1,J-1);
                case 3, D = X(I-1,J+1) - 3*X(I,J) + 3*X(I+1,J-1) - X(I+2,J-2);
                case 4, D = -X(I-2,J+2) + 4*X(I-1,J+1) - 6*X(I,J) + 4*X(I+1,J-1) - X(I+2,J-2);
                case 5, D = -X(I-2,J+2) + 5*X(I-1,J+1) - 10*X(I,J) + 10*X(I+1,J-1) - 5*X(I+2,J-2) + X(I+3,J-3);
                case 6, D = X(I-3,J+3) - 6*X(I-2,J+2) + 15*X(I-1,J+1) - 20*X(I,J) + 15*X(I+1,J-1) - 6*X(I+2,J-2) + X(I+3,J-3);
            end
        case 'KB'
            D = -X(I-1,J-1) + 2*X(I-1,J) - X(I-1,J+1) + 2*X(I,J-1) - 4*X(I,J) + 2*X(I,J+1) - X(I+1,J-1) + 2*X(I+1,J) - X(I+1,J+1);
        case 'edge-h'
            Du = 2*X(I-1,J) + 2*X(I,J-1) + 2*X(I,J+1) - X(I-1,J-1) - X(I-1,J+1) - 4*X(I,J);   %   -1  2 -1
            Db = 2*X(I+1,J) + 2*X(I,J-1) + 2*X(I,J+1) - X(I+1,J-1) - X(I+1,J+1) - 4*X(I,J);   %    2  C  2    +  flipped vertically
            D = [Du,Db];
        case 'edge-v'
            Dl = 2*X(I,J-1) + 2*X(I-1,J) + 2*X(I+1,J) - X(I-1,J-1) - X(I+1,J-1) - 4*X(I,J);   %   -1  2
            Dr = 2*X(I,J+1) + 2*X(I-1,J) + 2*X(I+1,J) - X(I-1,J+1) - X(I+1,J+1) - 4*X(I,J);   %    2  C       +  flipped horizontally
            D = [Dl,Dr];                                                                      %   -1  2
        case 'edge-m'
            Dlu = 2*X(I,J-1) + 2*X(I-1,J) - X(I-1,J-1) - X(I+1,J-1) - X(I-1,J+1) - X(I,J); %      -1  2 -1
            Drb = 2*X(I,J+1) + 2*X(I+1,J) - X(I+1,J+1) - X(I+1,J-1) - X(I-1,J+1) - X(I,J); %       2  C       +  flipped mdiag
            D = [Dlu,Drb];                                                                 %      -1
        case 'edge-d'
            Dru = 2*X(I-1,J) + 2*X(I,J+1) - X(I-1,J+1) - X(I-1,J-1) - X(I+1,J+1) - X(I,J); %      -1  2 -1
            Dlb = 2*X(I,J-1) + 2*X(I+1,J) - X(I+1,J-1) - X(I+1,J+1) - X(I-1,J-1) - X(I,J); %          C  2    +  flipped diag
            D = [Dru,Dlb];                                                                 %            -1
        case 'KV'
            D = 8*X(I-1,J) + 8*X(I+1,J) + 8*X(I,J-1) + 8*X(I,J+1);
            D = D - 6*X(I-1,J+1) - 6*X(I-1,J-1) - 6*X(I+1,J-1) - 6*X(I+1,J+1);
            D = D - 2*X(I-2,J) - 2*X(I+2,J) - 2*X(I,J+2) - 2*X(I,J-2);
            D = D + 2*X(I-1,J-2) + 2*X(I-2,J-1) + 2*X(I-2,J+1) + 2*X(I-1,J+2) + 2*X(I+1,J+2) + 2*X(I+2,J+1) + 2*X(I+2,J-1) + 2*X(I+1,J-2);
            D = D - X(I-2,J-2) - X(I-2,J+2) - X(I+2,J-2) - X(I+2,J+2) - 12*X(I,J);
    end
end