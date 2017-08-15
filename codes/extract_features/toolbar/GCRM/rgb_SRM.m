function f_ret = rgb_SRM(X,q)
% -------------------------------------------------------------------------
% X: the cosine or sine of the rotation angles
% q: values of quantization
% Modified by Shijun Zhou
% 2017.07.29
% -------------------------------------------------------------------------
    f = post_processing(all1st(X,1),'f1',q);
    Ss = fieldnames(f);
    f_ret = [];
    f_s = struct2cell(f);
    for Sid = 1:length(Ss)
        f_ret = [f_ret f_s{Sid}];
    end
end