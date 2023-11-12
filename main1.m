% 1. 绘制神经元 raster 和 PSTH 图
figure;

% Raster图
subplot(2,1,1);
hold on;
for i = 1:length(spikes)
if ~isempty(spikes{i}) && size(spikes{i}, 1) > 0
spike_times = spikes{i}(:,1);
neuron_id = repmat(i, size(spike_times));
plot(spike_times, neuron_id, 'k.', 'MarkerSize', 5);
end
end
xlabel('Time (s)');
ylabel('Neuron ID');
title('Neuron Raster Plot');
hold off;

% PSTH图 (Peri-Stimulus Time Histogram)
subplot(2,1,2);
bin_width = 0.1; % 设置直方图的时间窗口
edges = min(t):bin_width:max(t);

% 避免空的脉冲数据导致错误
valid_spikes = cellfun(@(x) ~isempty(x) && size(x, 1) > 0, spikes);
hist_data = cellfun(@(x) histcounts(x(:,1), edges), spikes(valid_spikes), 'UniformOutput', false);
PSTH = sum(cell2mat(hist_data), 1) / bin_width / length(spikes);
bar(edges(1:end-1), PSTH, 'k');
xlabel('Time (s)');
ylabel('Firing Rate (spikes/s)');
title('Peri-Stimulus Time Histogram (PSTH)');

% 2. 绘制神经元的 tuning curve
figure;

% 假设你的运动参数为速度，位置，加速度
% 这里仅以位置为例，具体需要根据数据内容进行调整
motion_param = finger_pos(:, 1); % 假设使用光标位置

% 对每个神经元计算 tuning curve
for i = 1:length(spikes)
if ~isempty(spikes{i}) && size(spikes{i}, 1) > 0
% 获取神经元的锋电位数据和对应的运动参数
neuron_spikes = spikes{i}(:,1);
neuron_param = interp1(t, motion_param, neuron_spikes, 'linear', 'extrap');
% 计算 tuning curve
bin_edges = linspace(min(neuron_param), max(neuron_param), 20); % 调整 bin 数量
[~, ~, bin] = histcounts(neuron_param, bin_edges);
tuning_curve = accumarray(bin, 1, [length(bin_edges) 1], @mean);
% 绘制 tuning curve
subplot(2, 1, 1);
plot(bin_edges, tuning_curve, 'o-');
xlabel('Position');
ylabel('Firing Rate (spikes/s)');
title('Tuning Curve');
hold on;
end
end
hold off;