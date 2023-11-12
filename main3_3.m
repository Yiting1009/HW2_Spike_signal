% 导入数据
load('indy_20161207_02.mat');

% 定义卡尔曼滤波器参数
Q = 1e-4; % 过程噪声协方差，根据实际情况调整
R = 1e-2; % 观测噪声协方差，根据实际情况调整
P = eye(6); % 初始估计协方差矩阵，根据实际情况调整

% 使用位置和速度
x_velocity = zeros(6, 1);
A_velocity = [1, 1, 0, 0, 0, 0; 
0, 1, 1, 0, 0, 0; 
0, 0, 1, 0, 0, 0;
0, 0, 0, 1, 1, 0; 
0, 0, 0, 0, 1, 1; 
0, 0, 0, 0, 0, 1];

decoded_pos_velocity = decode_motion(A_velocity, x_velocity, H, Q, R, P, t, cursor_pos);

% 绘制解码结果
figure;
subplot(3,1,2);
plot(t, decoded_pos_velocity(:, 1), 'r', t, decoded_pos_velocity(:, 2), 'b');
title('使用位置和速度');

% 使用位置、速度和加速度
x_acceleration = zeros(6, 1);
A_acceleration = [1, 1, 0.5, 0, 0, 0; 
0, 1, 1, 0, 0, 0; 
0, 0, 1, 0, 0, 0;
0, 0, 0, 1, 1, 0.5; 
0, 0, 0, 0, 1, 1; 
0, 0, 0, 0, 0, 1];

decoded_pos_acceleration = decode_motion(A_acceleration, x_acceleration, H, Q, R, P, t, cursor_pos);

% 绘制解码结果
subplot(3,1,3);
plot(t, decoded_pos_acceleration(:, 1), 'r', t, decoded_pos_acceleration(:, 2), 'b');
title('使用位置、速度和加速度');

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