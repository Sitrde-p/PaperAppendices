function [updated_data2, IDX, Best_K2, nmi_3, ari_3, fmi_3] = EXPprocess(file_name, data, labels, IDX_answer)
% data: 待处理数据集
% labels: 上一步获得的聚类结果
% IDX_answer: 聚类答案

[~,n1] = size(data);
[nc,~] = size(unique(IDX_answer));

% 权重计算
updated_data = data; % 创建一个和原始数据同样大小的数组来存储更新后的数据

% 初始化数据
unique_clusters = unique(labels);
all_weights = [];
cluster_sizes = [];
processed_indices = []; % 记录已处理数据点的索引

for i = 1:length(unique_clusters)
    cluster = unique_clusters(i);
    cluster_indices = find(labels == cluster);
    cluster_data = data(cluster_indices, :);
    
    % 处理数据点数量足够的簇
    if size(cluster_data, 1) >= 15
        [K, idx, centres] = Subclusters_result(cluster_data, 0);
        weights = weight_compute(cluster_data, centres, idx, K);
        weights(isnan(weights)) = 0;
        % 保存计算得到的权重及其对应的簇大小
        all_weights = [all_weights; weights];
        cluster_sizes = [cluster_sizes, size(cluster_data, 1)];
    end
end

% 如果有计算得到的权重，则对其进行规范化和加权平均处理
if ~isempty(all_weights)
    total_PNum_cluster = sum(cluster_sizes);
    normalized_PN_cluster = cluster_sizes / total_PNum_cluster;
    weighted_matrix = bsxfun(@times, all_weights, normalized_PN_cluster');
    weight = sum(weighted_matrix, 1);
end

%计算私有权重结果
SNN_K=5:30;

%计算全局权重结果
updated_data2 = [];     % Initialize z as an empty matrix
for i = 1:n1
    temp = data(:, i) .* weight(i);
    updated_data2 = [updated_data2, temp];     % Append x to z as a new colomn
end

dist=squareform(pdist(updated_data2));
for p=1:length(SNN_K)
  %If you want to choose centers manually, set AutoPick to 0, otherwise, number of centers
  result(p)=DC(updated_data2,IDX_answer,SNN_K(p),'AutoPick',nc,'Distance',dist,'Ui',false);
end
dashboard=table([result(:).ami]',[result(:).ari]',[result(:).fmi]',SNN_K','VariableNames',{'AMI','ARI','FMI','SNN_K'});
resultBest=dashboard(dashboard.ARI==max([result(:).ari]),:);
Best_K2=resultBest(1,4);

for i=1:length(result(:))
    if isequal(result(i).K,Best_K2.Variables)
        IDX = result(i).cluster;
    end
end
nmi_3 = GetNmi(IDX, IDX_answer);
ari_3 = GetAri(IDX, IDX_answer, 'adjusted');
fmi_3 = Library.GetFmi(IDX_answer,IDX);

%ResultRecord_GroundGWInfo(file_name,nmi_3,ari_3,fmi_3,'WDSC');
data = [1];
labels = [1];
end