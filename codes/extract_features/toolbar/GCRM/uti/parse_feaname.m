function [T,N,Q] = parse_feaname(name)
    [T,N,Q] = deal('');
    P = strfind(name,'_'); if length(P)~=2, return; end
    T = name(1:P(1)-1);
    N = name(P(1)+1:P(2)-1);
    Q = name(P(2)+1:end);
end