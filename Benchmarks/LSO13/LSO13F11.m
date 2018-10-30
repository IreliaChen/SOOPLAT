classdef LSO13F11 < LSO13
    properties
        p
        s
        R25
        R50
        R100
        w
    end
    methods
        function obj = LSO13F11(dimension)
            obj.name = 'LSO13F11';
            load('Benchmarks/LSO13/LSO13F11.mat');
            obj.idealsolution = xopt';
            if dimension ~= 1000
                warning('LSO13F11 supports only D = 1000, automatically corrected');
                dimension = 1000;
            end
            obj.p = p;
            obj.s = s;
            obj.R25 = R25;
            obj.R50 = R50;
            obj.R100 = R100;
            obj.w = w;
            obj.dimension = dimension;
            obj.lowerbound = -100 * ones(1, dimension);
            obj.upperbound = 100 * ones(1, dimension);
            obj.functionhandle = @(x)obj.f11(obj.shift(x)');
            obj.idealgroups = {};
            ldim = 1;
            for i = 1: length(obj.s)
                if obj.s(i) == 25
                    obj.idealgroups{i} = obj.p(ldim: ldim + obj.s(i) - 1);
                    ldim = ldim + obj.s(i);
                elseif obj.s(i) == 50
                    obj.idealgroups{i} = obj.p(ldim: ldim + obj.s(i) - 1);
                    ldim = ldim + obj.s(i);
                elseif obj.s(i) == 100
                    obj.idealgroups{i} = obj.p(ldim: ldim + obj.s(i) - 1);
                    ldim = ldim + obj.s(i);
                end
            end
        end
        function fit = f11(obj, x)
            fit = 0;
            ldim = 1;
            for i = 1: length(obj.s)
                if obj.s(i) == 25
                    f = obj.schwefel(obj.R25 * x(obj.p(ldim: ldim + obj.s(i) - 1), :));
                    ldim = ldim + obj.s(i);
                elseif obj.s(i) == 50
                    f = obj.schwefel(obj.R50 * x(obj.p(ldim: ldim + obj.s(i) - 1), :));
                    ldim = ldim + obj.s(i);
                elseif obj.s(i) == 100
                    f = obj.schwefel(obj.R100 * x(obj.p(ldim: ldim + obj.s(i) - 1), :));
                    ldim = ldim + obj.s(i);
                end
                fit = fit + obj.w(i) * f;
            end
        end
    end
end