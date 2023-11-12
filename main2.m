% 导入数据
load('indy_20161207_02.mat');

% 提取相关数据
inputs = cursor_pos'; % 使用光标位置作为输入
targets_y = finger_pos(:, 2)'; % 使用指尖位置的y坐标作为目标
targets_x = finger_pos(:, 1)'; % 使用指尖位置的x坐标作为目标

% 创建并训练神经网络 (Y坐标)
hiddenLayerSize_y = 10; % 可调整隐藏层大小
net_y = fitnet(hiddenLayerSize_y);
net_y = train(net_y, inputs, targets_y);

% 创建并训练神经网络 (X坐标)
hiddenLayerSize_x = 10; % 可调整隐藏层大小
net_x = fitnet(hiddenLayerSize_x);
net_x = train(net_x, inputs, targets_x);

% 使用训练好的网络进行预测
outputs_y = net_y(inputs);
outputs_x = net_x(inputs);

% 评估拟合程度
mse_y = immse(targets_y, outputs_y); 
mse_x = immse(targets_x, outputs_x); 

figure;
plot(targets_y , 'b');
hold on;
plot(outputs_y, 'r');
legend('实际Y', '预测Y');
title('Y坐标拟合');


% 绘制拟合结果
figure;
plot(targets_x , 'b');
hold on;
plot(outputs_x, 'r');
legend('实际X', '预测X');
title('X坐标拟合');


% 显示均方误差
fprintf('y均方误差: %.4f\n',mse_y);
fprintf('x均方误差: %.4f\n',mse_x);