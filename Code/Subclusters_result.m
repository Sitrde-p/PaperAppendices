function [bestK, bestLabels, bestcentres] = Subclusters_result(data, showUI)
    bestScore = -1;
    bestK = 2;
    bestLabels = [];
    bestcentres = [];

    % 尝试的最大K值
    maxK = min(size(data, 1) - 1, 15); % 设定最大的K值尝试范围为数据量或15，取较小的一个。

    for k = 2:maxK
        [labels, centres] = Subcluster_clusting(data, k, 'Replicates', 10);
        uniqueLabels = unique(labels);
        if length(uniqueLabels) == 1
            score = -1;
        else
            score = silhouette(data, labels);
        end

        if score > bestScore
            bestScore = score;
            bestK = k;
            bestLabels = labels;
            bestcentres = centres;
        end
    end

    if showUI == 1
        plotClusters(data, bestcentres, bestLabels, 'Subclusters Result');
    end
end

function plotClusters(X, centres, labels, title)
    % 确定聚类的数量
    k = length(unique(labels));
    % 为每个聚类选择一个颜色
    colors = ['r', 'g', 'b', 'y', 'c', 'm', 'k'];

    figure;
    hold on;
    for i = 1:k
        % 绘制聚类中的点
        clusterPoints = X(labels == i, :);
        scatter(clusterPoints(:, 1), clusterPoints(:, 2), 50, colors(mod(i, length(colors)) + 1), 'filled');
        % 绘制medoid
        scatter(centres(i, 1), centres(i, 2), 200, colors(mod(i, length(colors)) + 1), 'X', 'LineWidth', 2);
    end
    title(title);
    xlabel('Feature 1');
    ylabel('Feature 2');
    legend('AutoUpdate', 'off');
    grid on;
    hold off;
end
