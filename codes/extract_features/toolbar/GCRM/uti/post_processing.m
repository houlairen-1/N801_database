function RESULT = post_processing(DATA,f,q,RESULT)

    Ss = fieldnames(DATA);
    for Sid = 1:length(Ss)
        VARNAME = [f '_' Ss{Sid} '_q' strrep(num2str(q),'.','')];
        eval(['RESULT.' VARNAME ' = reshape(single(DATA.' Ss{Sid} '),1,[]);' ])
    end

    % symmetrize
    L = fieldnames(RESULT);
    for i=1:length(L)
        name = L{i}; % feature name
        if name(1)=='s', continue; end
        [T,N,Q] = parse_feaname(name);
        if strcmp(T,''), continue; end
        % symmetrization
        if strcmp(N(1:3),'min') || strcmp(N(1:3),'max')
            % minmax symmetrization
            OUT = ['s' T(2:end) '_minmax' N(4:end) '_' Q];
            if isfield(RESULT,OUT), continue; end
            eval(['Fmin = RESULT.' strrep(name,'max','min') ';']);
            eval(['Fmax = RESULT.' strrep(name,'min','max') ';']);
%             F = symfea([Fmin Fmax]',2,4,'mnmx')'; %#ok<*NASGU>
            F = symfea([Fmin Fmax]',1,4,'mnmx')'; %#ok<*NASGU>
            eval(['RESULT.' OUT ' = single(F);' ]);
        elseif strcmp(N(1:4),'spam')
            % spam symmetrization
            OUT = ['s' T(2:end) '_' N '_' Q];
            if isfield(RESULT,OUT), continue; end
            eval(['Fold = RESULT.' name ';']);
%             F = symm1(Fold',2,4)';
            F = symm1(Fold',1,4)';
            eval(['RESULT.' OUT ' = single(F);' ]);
        end
    end
    % delete RESULT.f*
    L = fieldnames(RESULT);
    for i=1:length(L)
        name = L{i}; % feature name
        if name(1)=='f'
            RESULT = rmfield(RESULT,name);
        end
    end
    % merge spam features
    L = fieldnames(RESULT);
    for i=1:length(L)
        name = L{i}; % feature name
        [T,N,Q] = parse_feaname(name);
        if ~strcmp(N(1:4),'spam'), continue; end
        if strcmp(T,''), continue; end
        if strcmp(N(end),'v')||(strcmp(N,'spam11')&&strcmp(T,'s5x5'))
        elseif strcmp(N(end),'h')
            % h+v union
            OUT = [T '_' N 'v_' Q ];
            if isfield(RESULT,OUT), continue; end
            name2 = strrep(name,'h_','v_');
            eval(['Fh = RESULT.' name ';']);
            eval(['Fv = RESULT.' name2 ';']);
            eval(['RESULT.' OUT ' = [Fh Fv];']);
            RESULT = rmfield(RESULT,name);
            RESULT = rmfield(RESULT,name2);
        elseif strcmp(N,'spam11')
            % KBKV creation
            OUT = ['s35_' N '_' Q];
            if isfield(RESULT,OUT), continue; end
            name1 = strrep(name,'5x5','3x3');
            name2 = strrep(name,'3x3','5x5');
            if ~isfield(RESULT,name1), continue; end
            if ~isfield(RESULT,name2), continue; end
            eval(['F_KB = RESULT.' name1 ';']);
            eval(['F_KV = RESULT.' name2 ';']);
            eval(['RESULT.' OUT ' = [F_KB F_KV];']);
            RESULT = rmfield(RESULT,name1);
            RESULT = rmfield(RESULT,name2);
        end
    end
end