%% 清理环境
clc; % 清空命令行窗口
clear; % 清空工作空间的所有变量
close all; % 关闭所有图形窗口
addpath(genpath('.')); % 添加当前目录及其子目录到路径，以便调用相关的函数

% 读取全色影像和多光谱影像
pan = im2double(imread('homework_ori/P.tiff')); % 全色影像（高分辨率）
ms = im2double(imread('homework_ori/MS.tiff')); % 多光谱影像（低分辨率）

% 检查影像维度
size_pan = size(pan); % 全色影像维度
size_ms = size(ms);   % 多光谱影像维度

% 将多光谱影像插值到全色影像的空间分辨率
ms_resized = imresize(ms, [size_pan(1), size_pan(2)]); % 确保与全色影像匹配

% 对全色影像进行低通滤波
h = fspecial('average', [5, 5]); % 使用 5x5 平均滤波器
lowpass_pan = imfilter(pan, h, 'replicate');

% 计算增强因子
enhancement_factor = pan ./ (lowpass_pan + eps); % 避免除以零

% 对每个波段进行融合
fused_image = zeros(size(ms_resized)); % 初始化融合影像
for i = 1:size(ms_resized, 3)
    fused_image(:, :, i) = ms_resized(:, :, i) .* enhancement_factor;
end

% 伪彩色显示多光谱影像
if size(ms, 3) >= 3
    ms_rgb = cat(3, ms(:, :, 1), ms(:, :, 2), ms(:, :, 3)); % 取前 3 波段
else
    ms_rgb = repmat(ms(:, :, 1), [1, 1, 3]); % 单波段扩展为伪彩色
end

% 伪彩色显示融合影像
if size(fused_image, 3) >= 3
    fused_rgb = cat(3, fused_image(:, :, 1), fused_image(:, :, 2), fused_image(:, :, 3));
else
    fused_rgb = repmat(fused_image(:, :, 1), [1, 1, 3]);
end

% 显示结果
figure;
subplot(1, 3, 1); imshow(pan, []); title('全色影像'); % 灰度显示
subplot(1, 3, 2); imshow(ms_rgb); title('多光谱影像'); % 伪彩色显示
subplot(1, 3, 3); imshow(fused_rgb); title('融合影像'); % 伪彩色显示

% 创建输出目录
output_dir = './res/homework/SFIM/';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% 保存影像
imwrite(im2uint8(pan), fullfile(output_dir, 'pan.tiff')); % 全色影像
imwrite(im2uint8(ms_rgb), fullfile(output_dir, 'ms_rgb.png')); % 多光谱影像（伪彩色）
imwrite(im2uint8(ms_rgb), fullfile(output_dir, 'ms_rgb.bmp')); % BMP 格式
imwrite(im2uint8(ms_rgb), fullfile(output_dir, 'ms_rgb.jpg')); % JPEG 格式
imwrite(im2uint8(fused_rgb), fullfile(output_dir, 'fused_rgb.tiff')); % 融合影像（TIFF）
imwrite(im2uint8(fused_rgb), fullfile(output_dir, 'fused_rgb.png')); % PNG 格式
imwrite(im2uint8(fused_rgb), fullfile(output_dir, 'fused_rgb.bmp')); % BMP 格式
imwrite(im2uint8(fused_rgb), fullfile(output_dir, 'fused_rgb.jpg')); % JPEG 格式

disp('影像保存完成！');
