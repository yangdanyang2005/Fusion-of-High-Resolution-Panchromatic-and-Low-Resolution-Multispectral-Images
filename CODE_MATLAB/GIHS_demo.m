% https://zhuanlan.zhihu.com/p/591118219

%% 清理环境
clc; % 清空命令行窗口
clear; % 清空工作空间的所有变量
close all; % 关闭所有图形窗口
addpath(genpath('.')); % 添加当前目录及其子目录到路径，以便调用相关的函数

%% 输入文件路径
inputDir = './homework_ori/'; % 输入图像所在文件夹
outputDir = './res/demo/GIHS/'; % 输出图像文件夹

%% 输入数据
load Sichuan;

% 归一化处理
ImageMS = double(ImageMS) / 255; % 确保在[0, 1]范围内
ImageP = double(ImageP) / 255;

% 获取全色图像和多光谱图像的尺寸
[rowsMS, colsMS, bands] = size(ImageMS);
[rowsP, colsP] = size(ImageP);

%% 图像重采样
if rowsMS ~= rowsP || colsMS ~= colsP
    ImageMS = imresize(ImageMS, [rowsP, colsP]); % 将多光谱图像重采样到全色图像的尺寸
end

%% 提取亮度分量和色调分量
% 计算多光谱图像的亮度（选择前三个波段进行加权平均）
if bands >= 3
    % 使用简单的加权平均来计算亮度
    LuminanceMS = 0.2989 * ImageMS(:,:,1) + 0.5870 * ImageMS(:,:,2) + 0.1140 * ImageMS(:,:,3);
else
    % 如果波段数少于3，可以用简单的平均来计算亮度
    LuminanceMS = mean(ImageMS, 3); 
end

% 使用全色图像的亮度代替多光谱图像的亮度
LuminanceP = ImageP;  % 全色图像本身就是亮度信息

% 计算多光谱图像的色调
ChromaticMS = ImageMS ./ (LuminanceMS + eps); % 避免除零，用全色图像的亮度分量做色调比值

% GIHS 变换：用全色图像的亮度替换多光谱图像的亮度，同时保持色调
FusedImage = ChromaticMS .* (LuminanceP + eps); % 色调成分和全色图像的亮度进行融合

%% 输出图像
% 检查融合后的图像维度并显示
if size(FusedImage, 3) >= 3
    % 如果 FusedImage 是一个多通道图像，选择前三个波段
    RGBImage = FusedImage(:,:,1:3);  % 选择前3个波段作为RGB图像
else
    % 如果 FusedImage 是单通道图像，显示为灰度图像
    RGBImage = mat2gray(FusedImage); % 转换为灰度图
end

% 显示融合后的图像
imshow(RGBImage);
title('GIHS融合后的影像');

% 保存融合后的图像
if ~exist(outputDir, 'dir')
    mkdir(outputDir); % 如果输出目录不存在，则创建
end

imwrite(RGBImage, fullfile(outputDir, 'fused_image_GIHS.tif'));
imwrite(RGBImage, fullfile(outputDir, 'fused_image_GIHS.tiff'));
imwrite(RGBImage, fullfile(outputDir, 'fused_image_GIHS.bmp'));
imwrite(RGBImage, fullfile(outputDir, 'fused_image_GIHS.png'));
imwrite(RGBImage, fullfile(outputDir, 'fused_image_GIHS.jpg'));