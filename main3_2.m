% 导入数据
load('indy_20161207_02.mat');

% 定义卡尔曼滤波器参数
Q = 1e-4; % 过程噪声协方差，根据实际情况调整
R = 1e-2; % 观测噪声协方差，根据实际情况调整
P = eye(6); % 初始估计协方差矩阵，根据实际情况调整

% 初始化状态向量和状态转移矩阵
x = zeros(6, 1); % [x_position, x_velocity, x_acceleration, y_position, y_velocity, y_acceleration]
A = [1, 1, 0.5, 0, 0, 0; 
0, 1, 1, 0, 0, 0; 
0, 0, 1, 0, 0, 0;
0, 0, 0, 1, 1, 0.5; 
0, 0, 0, 0, 1, 1; 
0, 0, 0, 0, 0, 1];

% 初始化测量矩阵
H = [1, 0, 0, 0, 0, 0;
0, 0, 0, 1, 0, 0];

% 存储解码结果的数组
decoded_pos = zeros(length(t), 2);

% 卡尔曼滤波主循环
for i = 2:length(t)
% 预测步骤
x_hat = A * x;
P_hat = A * P * A' + Q;

% 更新步骤
K = P_hat * H' / (H * P_hat * H' + R);
x = x_hat + K * ([cursor_pos(i, 1); cursor_pos(i, 2)] - H * x_hat);
P = (eye(6) - K * H) * P_hat;

% 存储解码结果
decoded_pos(i, :) = [x(1), x(4)];
end

% 绘制解码结果
figure;
subplot(3,1,1);
plot(t, decoded_pos(:, 1), 'r', t, decoded_pos(:, 2), 'b');
title('只使用位置');
xlabel('时间');
ylabel('位置');
legend('X 位置', 'Y 位置');

function decoded_pos = decode_motion(A, x, H, Q, R, P, t, cursor_pos)
decoded_pos = zeros(length(t), 2);

for i = 2:length(t)
% 预测步骤
x_hat = A * x;
P_hat = A * P * A' + Q;

% 更新步骤
K = P_hat * H' / (H * P_hat * H' + R);
x = x_hat + K * ([cursor_pos(i, 1); cursor_pos(i, 2)] - H * x_hat);
P = (eye(6) - K * H) * P_hat;

% 存储解码结果
decoded_pos(i, :) = [x(1), x(4)];
end
end