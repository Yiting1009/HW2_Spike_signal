% 导入数据
load('indy_20161207_02.mat');

% 线性回归方法
linear_regression_model_x = fitlm(cursor_pos, cursor_pos(:, 1));
decoded_pos_linear_x = predict(linear_regression_model_x, cursor_pos);

linear_regression_model_y = fitlm(cursor_pos, cursor_pos(:, 2));
decoded_pos_linear_y = predict(linear_regression_model_y, cursor_pos);

% 绘制解码结果
figure;
subplot(3,1,1);
plot(t, cursor_pos(:, 1), 'g', t, cursor_pos(:, 2), 'm');
title('原始运动数据');

subplot(3,1,2);
plot(t, decoded_pos_linear_x, 'r', t, decoded_pos_linear_y, 'b');
title('线性回归解码');

% LSTM方法
layers = [ ...
    sequenceInputLayer(2)
    lstmLayer(50)
    fullyConnectedLayer(2)
    regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 64, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', 0.01, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'Verbose', 1, ...
    'Plots', 'training-progress');

% 构建训练数据
X_train = reshape(cursor_pos(:, 1:2, :), [2, 111269]); % 调整维度
Y_train = reshape(cursor_pos(:, 1:2, :), [2, 111269]);

% 训练LSTM网络
net = trainNetwork(X_train, Y_train, layers, options);

% 使用训练好的LSTM网络进行解码
X_test = reshape(cursor_pos(:, 1:2, :), [2, 111269]); % 调整维度
decoded_pos_lstm = predict(net, X_test);

% 绘制LSTM解码结果
subplot(3,1,3);
plot(t, decoded_pos_lstm(1, :), 'r', t, decoded_pos_lstm(2, :), 'b');
title('LSTM解码');

% 添加图例
legend('X', 'Y');