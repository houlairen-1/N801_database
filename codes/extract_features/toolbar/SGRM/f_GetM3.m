function M = f_GetM3(L,C,R,T)
% modified by Bin Li
% 2017.7.27

    L=L(:); C = C(:);R = R(:); 
    % get cooccurences [-T...T]
    M = zeros(2*T+1,2*T+1,2*T+1);
    for w=-T:T
        for v=-T:T
            L2=L(C==v & R==w);
            for u=-T:T
                M(u+T+1,v+T+1,w+T+1) = sum(L2==u);
            end
        end
    end

    % normalization
    M = M(:)/sum(M(:));
end
