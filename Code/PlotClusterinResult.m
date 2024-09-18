
function PlotClusterinResult(X, IDX)

    k=max(IDX); % 求矩阵IDX每一列的最大元素及其对应的索引
    Colors = ['#f47a75';'#76da91';'#e30039';'#63b2ee';'#9987ce';'#fa6d1d']; % 获取颜色方案
    Legends = {};
    for i=0:k  % 循环每一个簇类
        Xi=X(IDX==i,:);   
        if i~=0
            Style = '.';  % 标记符号为x
            MarkerSize = 15;
            Color = Colors(i,:);
            %Color = ['magenta','cyan'];
            Legends{end+1} = ['Cluster ' num2str(i)];
        else
            Style = 'o';  % 标记符号为o
            MarkerSize = 6;
            Color = [0 0 0];
            if ~isempty(Xi)  
                Legends{end+1} = 'Noise'; % 如果为空，则为异常点
            end
        end
        if ~isempty(Xi)
            plot(Xi(:,1),Xi(:,2),Style,'MarkerSize',MarkerSize,'Color',Color);
        end
        hold on; 
    end
    %scatter(centers(:,1), centers(:,2), 60, 'k', 'p', 'LineWidth', 0.5);

    hold off;    % 使当前轴及图形不在具备被刷新的性质
    axis equal;  % 坐标轴的长度单位设成相等
    % axis([0.5 0.9 0.4 1.1])
    % xticks(0.5:0.2:1);
    % yticks(0.5:0.2:1);
    grid off;     % 在画图的时候添加网格线
    set(gca, 'XColor', 'none', 'YColor', 'none');
    legend(Legends);
    legend('Location', 'NorthEastOutside');

end