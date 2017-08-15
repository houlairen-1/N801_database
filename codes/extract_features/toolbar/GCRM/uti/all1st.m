function g = all1st(X,q)
%
% X must be a matrix of doubles or singles (the image) and q is the 
% quantization step (any positive number).
%
% Recommended values of q are c, 1.5c, 2c, where c is the central
% coefficient in the differential (at X(I,J)).
%
% This function outputs co-occurrences of ALL 1st-order residuals
% listed in Figure 1 in our journal HUGO paper (version from June 14), 
% including the naming convention.
%
% List of outputted features:
%
% 1a) spam14h
% 1b) spam14v (orthogonal-spam)
% 1c) minmax22v
% 1d) minmax24
% 1e) minmax34v
% 1f) minmax41
% 1g) minmax34
% 1h) minmax48h
% 1i) minmax54
%
% Naming convention:
%
% name = {type}{f}{sigma}{scan}
% type \in {spam, minmax}
% f \in {1,2,3,4,5} number of filters that are "minmaxed"
% sigma \in {1,2,3,4,8} symmetry index
% scan \in {h,v,\emptyset} scan of the cooc matrix (empty = sum of both 
% h and v scans).
%
% All odd residuals are implemented the same way simply by
% narrowing the range for I and J and replacing the residuals --
% -- they should "stick out" (trcet) in the same direction as 
% the 1st order ones. For example, for the 3rd order:
%
% RU = -X(I-2,J+2)+3*X(I-1,J+1)-3*X(I,J)+X(I+1,J-1); ... etc.
%
% Note1: The term X(I,J) should always have the "-" sign.
% Note2: This script does not include s, so, cout, cin versions (weak).
% This function calls Cooc.m and Quant.m

    [M N] = size(X); [I,J,T,order] = deal(2:M-1,2:N-1,1,4);% %[I,J,T,order] = deal(2:M-1,2:N-1,2,4);
    % Variable names are self-explanatory (R = right, U = up, L = left, D = down)
    [R,L,U,D]  = deal(X(I,J+1)-X(I,J),X(I,J-1)-X(I,J),X(I-1,J)-X(I,J),X(I+1,J)-X(I,J));
    [Rq,Lq,Uq,Dq] = deal(Quant(R,q,T),Quant(L,q,T),Quant(U,q,T),Quant(D,q,T));
    [RU,LU,RD,LD] = deal(X(I-1,J+1)-X(I,J),X(I-1,J-1)-X(I,J),X(I+1,J+1)-X(I,J),X(I+1,J-1)-X(I,J));
    [RUq,RDq,LUq,LDq] = deal(Quant(RU,q,T),Quant(RD,q,T),Quant(LU,q,T),Quant(LD,q,T));
    % minmax22h -- to be symmetrized as mnmx, directional, hv-nonsymmetrical.
    [RLq_min,UDq_min,RLq_max,UDq_max] = deal(min(Rq,Lq),min(Uq,Dq),max(Rq,Lq),max(Uq,Dq));
    g.min22h = reshape(Cooc(RLq_min,order,'hor',T) + Cooc(UDq_min,order,'ver',T),[],1);%--
    g.max22h = reshape(Cooc(RLq_max,order,'hor',T) + Cooc(UDq_max,order,'ver',T),[],1);%--
    % minmax34h -- to be symmetrized as mnmx, directional, hv-nonsymmetrical
    [Uq_min,Rq_min,Dq_min,Lq_min] = deal(min(min(Lq,Uq),Rq),min(min(Uq,Rq),Dq),min(min(Rq,Dq),Lq),min(min(Dq,Lq),Uq));
    [Uq_max,Rq_max,Dq_max,Lq_max] = deal(max(max(Lq,Uq),Rq),max(max(Uq,Rq),Dq),max(max(Rq,Dq),Lq),max(max(Dq,Lq),Uq));
    g.min34h = reshape(Cooc([Uq_min;Dq_min],order,'hor',T) + Cooc([Lq_min Rq_min],order,'ver',T),[],1);%--
    g.max34h = reshape(Cooc([Uq_max;Dq_max],order,'hor',T) + Cooc([Rq_max Lq_max],order,'ver',T),[],1);%--
    % spam14h/v -- to be symmetrized as spam, directional, hv-nonsymmetrical
    g.spam14h = reshape(Cooc(Rq,order,'hor',T) + Cooc(Uq,order,'ver',T),[],1);%--
    g.spam14v = reshape(Cooc(Rq,order,'ver',T) + Cooc(Uq,order,'hor',T),[],1);%--
    % minmax22v -- to be symmetrized as mnmx, directional, hv-nonsymmetrical. Good with higher-order residuals! Note: 22h is bad (too much neighborhood overlap).
    g.min22v = reshape(Cooc(RLq_min,order,'ver',T) + Cooc(UDq_min,order,'hor',T),[],1);%--
    g.max22v = reshape(Cooc(RLq_max,order,'ver',T) + Cooc(UDq_max,order,'hor',T),[],1);%--
    % minmax24 -- to be symmetrized as mnmx, directional, hv-symmetrical. Darn good, too.
    [RUq_min,RDq_min,LUq_min,LDq_min] = deal(min(Rq,Uq),min(Rq,Dq),min(Lq,Uq),min(Lq,Dq));
    [RUq_max,RDq_max,LUq_max,LDq_max] = deal(max(Rq,Uq),max(Rq,Dq),max(Lq,Uq),max(Lq,Dq));
    g.min24 = reshape(Cooc([RUq_min;RDq_min;LUq_min;LDq_min],order,'hor',T) + Cooc([RUq_min RDq_min LUq_min LDq_min],order,'ver',T),[],1);%--
    g.max24 = reshape(Cooc([RUq_max;RDq_max;LUq_max;LDq_max],order,'hor',T) + Cooc([RUq_max RDq_max LUq_max LDq_max],order,'ver',T),[],1);%--
    % minmax34v -- v works well, h does not, to be symmetrized as mnmx, directional, hv-nonsymmetrical
    g.min34v = reshape(Cooc([Uq_min Dq_min],order,'ver',T) + Cooc([Rq_min;Lq_min],order,'hor',T),[],1);%--
    g.max34v = reshape(Cooc([Uq_max Dq_max],order,'ver',T) + Cooc([Rq_max;Lq_max],order,'hor',T),[],1);%--
    % minmax41 -- to be symmetrized as mnmx, non-directional, hv-symmetrical
    [R_min,R_max] = deal(min(RLq_min,UDq_min),max(RLq_max,UDq_max));
    g.min41 = reshape(Cooc(R_min,order,'hor',T) + Cooc(R_min,order,'ver',T),[],1);%--
    g.max41 = reshape(Cooc(R_max,order,'hor',T) + Cooc(R_max,order,'ver',T),[],1);%--
    % minmax34 -- good, to be symmetrized as mnmx, directional, hv-symmetrical
    [RUq_min,RDq_min,LUq_min,LDq_min] = deal(min(RUq_min,RUq),min(RDq_min,RDq),min(LUq_min,LUq),min(LDq_min,LDq));
    [RUq_max,RDq_max,LUq_max,LDq_max] = deal(max(RUq_max,RUq),max(RDq_max,RDq),max(LUq_max,LUq),max(LDq_max,LDq));
    g.min34 = reshape(Cooc([RUq_min;RDq_min;LUq_min;LDq_min],order,'hor',T) + Cooc([RUq_min RDq_min LUq_min LDq_min],order,'ver',T),[],1);%--
    g.max34 = reshape(Cooc([RUq_max;RDq_max;LUq_max;LDq_max],order,'hor',T) + Cooc([RUq_max RDq_max LUq_max LDq_max],order,'ver',T),[],1);%--
    % minmax48h -- h better than v, to be symmetrized as mnmx, directional, hv-nonsymmetrical. 48v is almost as good as 48h; for 3rd-order but weaker for 1st-order. Here, I am outputting both but Figure 1 in our paper lists only 48h.
    [RUq_min2,RDq_min2,LDq_min2,LUq_min2] = deal(min(RUq_min,LUq),min(RDq_min,RUq),min(LDq_min,RDq),min(LUq_min,LDq));
    [RUq_min3,RDq_min3,LDq_min3,LUq_min3] = deal(min(RUq_min,RDq),min(RDq_min,LDq),min(LDq_min,LUq),min(LUq_min,RUq));
    g.min48h = reshape(Cooc([RUq_min2;LDq_min2;RDq_min3;LUq_min3],order,'hor',T) + Cooc([RDq_min2 LUq_min2 RUq_min3 LDq_min3],order,'ver',T),[],1);%--
    g.min48v = reshape(Cooc([RDq_min2;LUq_min2;RUq_min3;LDq_min3],order,'hor',T) + Cooc([RUq_min2 LDq_min2 RDq_min3 LUq_min3],order,'ver',T),[],1);%--
    [RUq_max2,RDq_max2,LDq_max2,LUq_max2] = deal(max(RUq_max,LUq),max(RDq_max,RUq),max(LDq_max,RDq),max(LUq_max,LDq));
    [RUq_max3,RDq_max3,LDq_max3,LUq_max3] = deal(max(RUq_max,RDq),max(RDq_max,LDq),max(LDq_max,LUq),max(LUq_max,RUq));
    g.max48h = reshape(Cooc([RUq_max2;LDq_max2;RDq_max3;LUq_max3],order,'hor',T) + Cooc([RDq_max2 LUq_max2 RUq_max3 LDq_max3],order,'ver',T),[],1);%--
    g.max48v = reshape(Cooc([RDq_max2;LUq_max2;RUq_max3;LDq_max3],order,'hor',T) + Cooc([RUq_max2 LDq_max2 RDq_max3 LUq_max3],order,'ver',T),[],1);%--
    % minmax54 -- to be symmetrized as mnmx, directional, hv-symmetrical
    [RUq_min4,RDq_min4,LDq_min4,LUq_min4] = deal(min(RUq_min2,RDq),min(RDq_min2,LDq),min(LDq_min2,LUq),min(LUq_min2,RUq));
    [RUq_min5,RDq_min5,LDq_min5,LUq_min5] = deal(min(RUq_min3,LUq),min(RDq_min3,RUq),min(LDq_min3,RDq),min(LUq_min3,LDq));
    g.min54 = reshape(Cooc([RUq_min4;LDq_min4;RDq_min5;LUq_min5],order,'hor',T) + Cooc([RDq_min4 LUq_min4 RUq_min5 LDq_min5],order,'ver',T),[],1);%--
    [RUq_max4,RDq_max4,LDq_max4,LUq_max4] = deal(max(RUq_max2,RDq),max(RDq_max2,LDq),max(LDq_max2,LUq),max(LUq_max2,RUq));
    [RUq_max5,RDq_max5,LDq_max5,LUq_max5] = deal(max(RUq_max3,LUq),max(RDq_max3,RUq),max(LDq_max3,RDq),max(LUq_max3,LDq));
    g.max54 = reshape(Cooc([RUq_max4;LDq_max4;RDq_max5;LUq_max5],order,'hor',T) + Cooc([RDq_max4 LUq_max4 RUq_max5 LDq_max5],order,'ver',T),[],1);%--
end
