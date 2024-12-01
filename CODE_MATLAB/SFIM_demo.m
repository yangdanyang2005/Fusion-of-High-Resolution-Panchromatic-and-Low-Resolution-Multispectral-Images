%% 清理环境
clc; % 清空命令行窗口
clear; % 清空工作空间的所有变量
close all; % 关闭所有图形窗口
addpath(genpath('.')); % 添加当前目录及其子目录到路径，以便调用相关的函数

%% 加载图像
load Sichuan; % 加载包含 ImageP 和 ImageMS 的数据

% 将多光谱影像（低分辨率）插值到全色影像（高分辨率）的空间分辨率
size_pan = size(ImageP); % 全色影像维度
size_ms = size(ImageMS); % 多光谱影像维度

ImageMS_resized = imresize(double(ImageMS), [size_pan(1), size_pan(2)]); % 插值

% 对全色影像进行低通滤波
h = fspecial('average', [5, 5]); % 使用 5x5 平均滤波器
lowpass_pan = imfilter(double(ImageP), h, 'replicate');

% 计算增强因子
enhancement_factor = double(ImageP) ./ (lowpass_pan + eps); % 避免除以零

% 对每个波段进行融合
fused_image = zeros(size(ImageMS_resized)); % 初始化融合影像
for i = 1:size(ImageMS_resized, 3)
    fused_image(:, :, i) = ImageMS_resized(:, :, i) .* enhancement_factor;
end

% 伪彩色显示多光谱影像
if size(ImageMS, 3) >= 3
    ms_rgb = uint8(ImageMS(:, :, 1:3)); % 取前 3 波段并转为 uint8
else
    ms_rgb = uint8(repmat(ImageMS(:, :, 1), [1, 1, 3])); % 单波段扩展为伪彩色
end

% 对融合影像进行归一化处理并生成 RGB 图像
if size(fused_image, 3) >= 3
    % 归一化并选取前三个波段
    fused_rgb = uint8(255 * mat2gray(fused_image(:, :, 1:3)));
else
    % 单波段扩展为伪彩色
    single_band_normalized = mat2gray(fused_image(:, :, 1)); % 单波段归一化
    fused_rgb = uint8(255 * repmat(single_band_normalized, [1, 1, 3]));
end


% 显示结果
figure;
subplot(1, 3, 1); imshow(uint8(ImageP), []); title('全色影像'); % 灰度显示
subplot(1, 3, 2); imshow(ms_rgb); title('多光谱影像'); % 伪彩色显示
subplot(1, 3, 3); imshow(fused_rgb); title('融合影像'); % 伪彩色显示

% 创建输出目录
output_dir = './res/demo/SFIM/';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% 保存影像
imwrite(im2uint8(ImageP), fullfile(output_dir, 'pan.tiff')); % 全色影像
imwrite(ms_rgb, fullfile(output_dir, 'ms_rgb.png')); % 多光谱影像（伪彩色）
imwrite(ms_rgb, fullfile(output_dir, 'ms_rgb.bmp')); % BMP 格式
imwrite(ms_rgb, fullfile(output_dir, 'ms_rgb.jpg')); % JPEG 格式
imwrite(fused_rgb, fullfile(output_dir, 'fused_rgb.tiff')); % 融合影像（TIFF）
imwrite(fused_rgb, fullfile(output_dir, 'fused_rgb.png')); % PNG 格式
imwrite(fused_rgb, fullfile(output_dir, 'fused_rgb.bmp')); % BMP 格式
imwrite(fused_rgb, fullfile(output_dir, 'fused_rgb.jpg')); % JPEG 格式

disp('影像保存完成！');
