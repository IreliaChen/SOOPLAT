clear;
clf;
cla;
samples = 51; % 51 points for each curve
mainFolder = 'C:/OneDrive/Harry/Desktop/CCCOMP';
problem = 'LSO13F12';
algorithms = {'DECCBICCA2', 'DECCR'};
% Interface: [spercentage, sdata] = collectData(samples, fileFolder, algorithm, problem, dimension, evaluation)
gathereddata.percentage = [];
gathereddata.data = [];
gathereddata.problem = [];
gathereddata.algorithm = [];
gathereddata = repmat(gathereddata, numel(algorithms), 1);
for i = 1: numel(algorithms)
    gathereddata(i).algorithm = algorithms{i};
    gathereddata(i).problem = problem;
    if strcmp(problem, 'LSO13F13')
        dimension = 905;
    else
        dimension = 1000;
    end
    [gathereddata(i).percentage, gathereddata(i).data] = collectData(samples, mainFolder, algorithms{i}, problem, dimension, 56);
    
end
Curves = bandParser(gathereddata);
axis square;
axis([0, 1, 0, inf]);
set(gca, 'yscale', 'log');
for i = 1: numel(algorithms)
    name = replace(algorithms{i}, '_', '\_');
    % name = replace(name, 'BICCA2', 'IPAS');
    name = replace(name, 'DECCD', 'DECC-D');
    name = replace(name, 'DECCG', 'DECC-G');
    name = replace(name, 'DECCDML', 'DECC-DML');
    name = replace(name, 'DECCDG', 'DECC-DG');
    name = replace(name, 'DECCDG', 'DECC-DG2');
    name = replace(name, 'CCCMAES', 'CC-CMA-ES');
    Legends{i} = name;
end
L = legend([Curves{:}]', Legends{:});
set(L, 'FontName', 'Book Antiqua', 'FontSize', 12);





function Curves = bandParser(gathereddata)
Curves = {};
for i = 1: numel(gathereddata)
    MEAN = mean(gathereddata(i).data);
    CONFIDENCE = [NaN(size(gathereddata(i).percentage)); NaN(size(gathereddata(i).percentage))];
    for j = 1: size(gathereddata(i).data, 2)
        D = gathereddata(i).data(:, j);
        [~, ~, CONFIDENCE(:, j), ~] = ttest(D);%ztest(D, mean(D), std(D));
        if CONFIDENCE(1, j) < 0
            CONFIDENCE(1, j) = min(gathereddata(i).data(:, j));
        end
    end
    VARIANCE = [min(gathereddata(i).data, [], 1); max(gathereddata(i).data, [], 1)];
    PERCENTAGE = gathereddata(i).percentage;
    if strcmp(gathereddata(i).algorithm, 'BICCA2')
        [Curves{i}, ~, ~] = bandDrawer(PERCENTAGE, MEAN, CONFIDENCE, VARIANCE, [0, 0, 1]);
    else
        [Curves{i}, ~, ~] = bandDrawer(PERCENTAGE, MEAN, CONFIDENCE, VARIANCE);
    end
    hold on;
end
drawnow;
end
function [Curve, ConfidenceArea, VarianceArea] = bandDrawer(varargin)
set(gcf, 'Renderer', 'Painter');
if nargin == 4 % PERCENTAGE, MEAN, CONFIDENCE, VARIANCE
    PERCENTAGE = varargin{1};
    MEAN = varargin{2};
    CONFIDENCE = varargin{3};
    VARIANCE = varargin{4};
    LineWidth = 1;
    Curve = plot(PERCENTAGE, MEAN, 'LineWidth', LineWidth);
elseif nargin == 5 % PERCENTAGE, MEAN, CONFIDENCE, VARIANCE, COLOR
    PERCENTAGE = varargin{1};
    MEAN = varargin{2};
    CONFIDENCE = varargin{3};
    VARIANCE = varargin{4};
    COLOR = varargin{5};
    LineWidth = 2;
    Curve = plot(PERCENTAGE, MEAN, 'LineWidth', LineWidth, 'COLOR', COLOR);
end
COLOR = Curve.Color;
delete(Curve);
ConfidenceArea = fill([PERCENTAGE, flip(PERCENTAGE)], [CONFIDENCE(1, :), flip(CONFIDENCE(2, :))], COLOR, 'EdgeColor', 'none', 'FaceAlpha', '0.4');
hold on;
VarianceArea = fill([PERCENTAGE, flip(PERCENTAGE)], [VARIANCE(1, :), flip(VARIANCE(2, :))], COLOR, 'EdgeColor', 'none', 'FaceAlpha', '0.2');
Curve = plot(PERCENTAGE, MEAN, '-', 'LineWidth', LineWidth, 'COLOR', COLOR);
drawnow;
end