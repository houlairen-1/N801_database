function f = Cooc(D,order,type,T)
% Co-occurrence operator to be appied to a 2D array of residuals D \in [-T,T]
% T     ... threshold
% order ... cooc order \in {1,2,3,4,5}
% type  ... cooc type \in {hor,ver,diag,mdiag,square,square-ori,hvdm}
% f     ... an array of size (2T+1)^order

    B = 2*T+1;
    if max(abs(D(:))) > T, fprintf('*** ERROR in Cooc.m: Residual out of range ***\n'), end

    switch order
        case 1
            f = hist(D(:),-T:T);
        case 2
            f = zeros(B,B);
            if strcmp(type,'hor'),   L = D(:,1:end-1); R = D(:,2:end);end
            if strcmp(type,'ver'),   L = D(1:end-1,:); R = D(2:end,:);end
            if strcmp(type,'diag'),  L = D(1:end-1,1:end-1); R = D(2:end,2:end);end
            if strcmp(type,'mdiag'), L = D(1:end-1,2:end); R = D(2:end,1:end-1);end
            for i = -T : T
                R2 = R(L(:)==i);
                for j = -T : T
                    f(i+T+1,j+T+1) = sum(R2(:)==j);
                end
            end
        case 3
            f = zeros(B,B,B);
            if strcmp(type,'hor'),   L = D(:,1:end-2); C = D(:,2:end-1); R = D(:,3:end);end
            if strcmp(type,'ver'),   L = D(1:end-2,:); C = D(2:end-1,:); R = D(3:end,:);end
            if strcmp(type,'diag'),  L = D(1:end-2,1:end-2); C = D(2:end-1,2:end-1); R = D(3:end,3:end);end
            if strcmp(type,'mdiag'), L = D(1:end-2,3:end); C = D(2:end-1,2:end-1); R = D(3:end,1:end-2);end
            for i = -T : T
                C2 = C(L(:)==i);
                R2 = R(L(:)==i);
                for j = -T : T
                    R3 = R2(C2(:)==j);
                    for k = -T : T
                        f(i+T+1,j+T+1,k+T+1) = sum(R3(:)==k);
                    end
                end
            end
        case 4
            f = zeros(B,B,B,B);
            if strcmp(type,'hor'),    L = D(:,1:end-3); C = D(:,2:end-2); E = D(:,3:end-1); R = D(:,4:end);end
            if strcmp(type,'ver'),    L = D(1:end-3,:); C = D(2:end-2,:); E = D(3:end-1,:); R = D(4:end,:);end
            if strcmp(type,'diag'),   L = D(1:end-3,1:end-3); C = D(2:end-2,2:end-2); E = D(3:end-1,3:end-1); R = D(4:end,4:end);end
            if strcmp(type,'mdiag'),  L = D(4:end,1:end-3); C = D(3:end-1,2:end-2); E = D(2:end-2,3:end-1); R = D(1:end-3,4:end);end
            if strcmp(type,'square'), L = D(2:end,1:end-1); C = D(2:end,2:end); E = D(1:end-1,2:end); R = D(1:end-1,1:end-1);end
            if strcmp(type,'square-ori'), [M, N] = size(D); Dh = D(:,1:M); Dv = D(:,M+1:2*M);
                                      L = Dh(2:end,1:end-1); C = Dv(2:end,2:end); E = Dh(1:end-1,2:end); R = Dv(1:end-1,1:end-1);end
            if strcmp(type,'hvdm'),   [M, N] = size(D); L = D(:,1:M); C = D(:,M+1:2*M); E = D(:,2*M+1:3*M); R = D(:,3*M+1:4*M);end
            if strcmp(type,'s-in'),   [M, N] = size(D); Dh = D(:,1:M); Dv = D(:,M+1:2*M); Dh1 = D(:,2*M+1:3*M); Dv1 = D(:,3*M+1:4*M);
                                      L = Dh(2:end,1:end-1); C = Dh1(2:end,2:end); E = Dh1(1:end-1,2:end); R = Dh(1:end-1,1:end-1);end
            if strcmp(type,'s-out'),  [M, N] = size(D); Dh = D(:,1:M); Dv = D(:,M+1:2*M); Dh1 = D(:,2*M+1:3*M); Dv1 = D(:,3*M+1:4*M);
                                      L = Dh1(2:end,1:end-1); C = Dh(2:end,2:end); E = Dh(1:end-1,2:end); R = Dh1(1:end-1,1:end-1);end
            if strcmp(type,'ori-in'), [M, N] = size(D); Dh = D(:,1:M); Dv = D(:,M+1:2*M); Dh1 = D(:,2*M+1:3*M); Dv1 = D(:,3*M+1:4*M);
                                      L = Dh(2:end,1:end-1); C = Dv1(2:end,2:end); E = Dh1(1:end-1,2:end); R = Dv(1:end-1,1:end-1);end
            if strcmp(type,'ori-out'),[M, N] = size(D); Dh = D(:,1:M); Dv = D(:,M+1:2*M); Dh1 = D(:,2*M+1:3*M); Dv1 = D(:,3*M+1:4*M);
                                      L = Dh1(2:end,1:end-1); C = Dv(2:end,2:end); E = Dh(1:end-1,2:end); R = Dv1(1:end-1,1:end-1);end
            for i = -T : T
                ind = (L(:)==i); C2 = C(ind); E2 = E(ind); R2 = R(ind);
                for j = -T : T
                    ind = (C2(:)==j); E3 = E2(ind); R3 = R2(ind);
                    for k = -T : T
                        R4 = R3(E3(:)==k);
                        for l = -T : T
                            f(i+T+1,j+T+1,k+T+1,l+T+1) = sum(R4(:)==l);
                        end
                    end
                end
            end
        case 5
            f = zeros(B,B,B,B,B);
            if strcmp(type,'hor'),L = D(:,1:end-4); C = D(:,2:end-3); E = D(:,3:end-2); F = D(:,4:end-1); R = D(:,5:end);end
            if strcmp(type,'ver'),L = D(1:end-4,:); C = D(2:end-3,:); E = D(3:end-2,:); F = D(4:end-1,:); R = D(5:end,:);end

            for i = -T : T
                ind = (L(:)==i); C2 = C(ind); E2 = E(ind); F2 = F(ind); R2 = R(ind);
                for j = -T : T
                    ind = (C2(:)==j); E3 = E2(ind); F3 = F2(ind); R3 = R2(ind);
                    for k = -T : T
                        ind = (E3(:)==k); F4 = F3(ind); R4 = R3(ind);
                        for l = -T : T
                            R5 = R4(F4(:)==l);
                            for m = -T : T
                                f(i+T+1,j+T+1,k+T+1,l+T+1,m+T+1) = sum(R5(:)==m);
                            end
                        end
                    end
                end
            end
    end

    % normalization
    f = double(f);
    fsum = sum(f(:));
    if fsum>0, f = f/fsum; end
end