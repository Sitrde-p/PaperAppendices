function weight = weight_compute(X, centres, idx, K)
    % 根据聚类结果计算权重的函数。
    % 输入:
    % X: 数据集，大小为 (m, n) 的矩阵
    % centres: 对应于最佳k值的centres，矩阵
    % idx: 数据点对应的聚类索引，向量
    % K: 最佳的k值，即聚类的数量
    % 返回:
    % weight: 特征的权重，大小为 (1, n) 的向量

    belta = 2;
    [m, n] = size(X);
    D = zeros(1, n);
    weight = zeros(1, n);

    for i = 1:K
        index = find(idx == i);
        temp = X(index, :);
        square = (temp - repmat(centres(i, :), length(index), 1)) .^ 2;
        D = D + sum(square, 1);
    end

    e = 1 / (belta - 1);
    for j = 1:n
        temp = D(j) ./ D;
        temp(isinf(temp)) = 0;
        weight(j) = 1 / sum(temp .^ e);
    end

end
