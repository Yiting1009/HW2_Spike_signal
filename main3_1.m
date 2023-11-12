% 导入数据
load('indy_20161207_02.mat');

% 定义卡尔曼滤波器参数
Q = 1e-4;  % 过程噪声协方差，根据实际情况调整
R = 1e-2;  % 观测噪声协方差，根据实际情况调整
P = eye(4);  % 初始估计协方差矩阵，根据实际情况调整

% 初始化状态向量和状态转移矩阵
x = zeros(4, 1);  % [x_position, x_velocity, y_position, y_velocity]
A = [1, 1, 0, 0; 
     0, 1, 0, 0; 
     0, 0, 1, 1; 
     0, 0, 0, 1];

% 初始化测量矩阵
H = [1, 0, 0, 0;
     0, 0, 1, 0];

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
    P = (eye(4) - K * H) * P_hat;

    % 存储解码结果
    decoded_pos(i, :) = [x(1), x(3)];
end

% 绘制原始数据和解码结果
figure;
subplot(2,1,1);
plot(t, cursor_pos(:, 1), 'r', t, cursor_pos(:, 2), 'b');
title('原始运动数据');
xlabel('时间');
ylabel('位置');
legend('X 位置', 'Y 位置');

subplot(2,1,2);
plot(t, decoded_pos(:, 1), 'r', t, decoded_pos(:, 2), 'b');
title('解码后的运动数据');
xlabel('时间');
ylabel('位置');
legend('X 位置', 'Y 位置');