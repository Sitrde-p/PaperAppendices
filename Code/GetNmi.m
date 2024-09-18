function nmi = GetNmi(x, y)
% Compute normalized mutual information I(x,y)/sqrt(H(x)*H(y)) of two discrete variables x and y.
% Input:
%   x, y: two integer vector of the same length 
% Ouput:
%   z: normalized mutual information z=I(x,y)/sqrt(H(x)*H(y))
% Written by Mo Chen (sth4nth@gmail.com).

% x 为聚类结果标签，y 为真实类别标签
assert(numel(x) == numel(y)); % 确保 x 和 y 长度相等
n = numel(x); % 样本数
x = reshape(x, 1, n); % 将 x 和 y 转换为行向量
y = reshape(y, 1, n);

% 将标签从 1 开始编号
l = min(min(x), min(y));
x = x - l + 1;
y = y - l + 1;

k = max(max(x), max(y)); % 聚类数

idx = 1:n;
Mx = sparse(idx, x, 1, n, k, n); % 转换为稀疏矩阵
My = sparse(idx, y, 1, n, k, n);

% 计算 P(x, y) 和 H(x, y)
Pxy = nonzeros(Mx' * My / n); % 两个向量的点积
Hxy = -dot(Pxy, log2(Pxy)); % 两个向量的熵

% 解决 log(0) 的问题
Px = nonzeros(mean(Mx, 1));
Py = nonzeros(mean(My, 1));

% 计算 H(x) 和 H(y)
Hx = -dot(Px, log2(Px));
Hy = -dot(Py, log2(Py));

% 计算互信息和标准化互信息
MI = Hx + Hy - Hxy;
nmi = sqrt((MI / Hx) * (MI / Hy));
nmi = max(0, nmi); % 防止负数

% 显示 NMI 得分
% disp(['NMI socre: ', num2str(nmi)]);


% function [nmi]=NMI(label_a, label_b)
%     if(length(label_a)~=length(label_b))
%         nmi=0;
%         return;
%     end
%     com_a=unique(label_a);
%     com_b=unique(label_b);
%     
%     norm_a=0;
%     norm_b=0;
%     n=length(label_a);
%     
%     for h=1:length(com_a)
%        n_a=length(find(label_a==com_a(h)));
%        norm_a=norm_a+n_a*log(n_a/n);
%     end
%     
%     for l=1:length(com_b)
%         n_b=length(find(label_b==com_b(l)));
%         norm_b=norm_b+n_b*log(n_b/n);
%     end
%    
%     numerator=0;
%    
%     for h=1:length(com_a)
%         n_a=length(find(label_a==com_a(h)));
%         for l=1:length(com_b)
%             n_b=length(find(label_b==com_b(l)));
%             
%             n_ab=0;
%             for i=1:n
%                 if(label_a(i)==com_a(h)&&label_b(i)==com_b(l))
%                     n_ab=n_ab+1;
%                 end
%             end
%             if(n_ab~=0)
%                  numerator=numerator+n_ab*log((n*n_ab)/(n_a*n_b));
%             end
%         end
%     end
%     nmi=numerator/(sqrt(norm_a*norm_b));
% end