% https://blog.csdn.net/gsgs1234/article/details/123427714

%% 清理环境
clc; % 清空命令行窗口
clear; % 清空工作空间的所有变量
close all; % 关闭所有图形窗口
addpath(genpath('.')); % 添加当前目录及其子目录到路径，以便调用相关的函数

%% 设置文件路径
inputDir = './homework_ori/'; % 输入图像所在文件夹
outputDir = './res/homework/PCA/'; % 输出图像文件夹

%% 读取输入图像
ImageMS = imread(fullfile(inputDir, 'MS.tiff')); % 多光谱影像
ImageP = imread(fullfile(inputDir, 'P.tiff'));  % 高分辨率影像

%% 如果多光谱图像和高分辨率图像分辨率不一致，先进行重采样
if size(ImageMS, 1) ~= size(ImageP, 1) || size(ImageMS, 2) ~= size(ImageP, 2)
    MS_resized = imresize(ImageMS, [size(ImageP, 1), size(ImageP, 2)]);  % 将多光谱图像重采样为高分辨率图像的大小
else
    MS_resized = ImageMS;  % 如果已经匹配分辨率，则无需重采样
end

%% 调用 PCA_melt 函数进行影像融合
fusedImage = PCA_melt(ImageP, MS_resized);

%% 保存显示的图像（fusedImage）
if ~exist(outputDir, 'dir')
    mkdir(outputDir); % 如果输出目录不存在，则创建
end
imwrite(fusedImage, fullfile(outputDir, 'fused_image.tiff'));
imwrite(fusedImage, fullfile(outputDir, 'fused_image.tif'));
imwrite(fusedImage, fullfile(outputDir, 'fused_image.png'));
imwrite(fusedImage, fullfile(outputDir, 'fused_image.jpg'));
imwrite(fusedImage, fullfile(outputDir, 'fused_image.bmp'));


%% PCA融合函数
function F = PCA_melt(HR, MS)
% 调用代码-------------------------------
% Image1=imread('HR.jpg'); Image2=imread('MS.jpg');
% PCA_melt(Image1, Image2);
% --------------------------------------
HR = im2double(HR);
MS = im2double(MS);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PCA变换
[row, column, bands] = size(MS);
X = reshape(MS, [row * column, bands]);     % 每一波段的数据保存在一列  
Cov = cov(X);        % 求方差协方差矩阵,第(i,j)个元素等于X的第i列向量与第j列向量的方差
[vector, value] = eig(Cov);     % a为特征向量矩阵(一列为一个特征向量)，b为特征值矩阵(排序为从小到大）
vector = fliplr(vector);        % fliplr()翻转特征值与特征向量矩阵，实现由大到小排序
value = fliplr(value); value = flipud(value); 
% Y = vector' * X',    % 3*3/3*b--3*b 每一行为一个波段
Y = X * vector;     % 每一列为一个波段

% 获取第一主成分
Major = reshape(Y(:,1), [row, column]);
[counts, X] = imhist(Major / max(max(Major)));
HR1 = histeq(HR, counts);  % 高分辨率影像进行直方图均衡化

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 高分辨率影像替代第一主分量
% 替换第一主成分
Y(:,1) = reshape(HR1, [row * column, 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PCA逆变换
Image1 = Y * inv(vector);   % pexel * 3 - 3 * 3
Image1 = reshape(Image1, [row, column, bands]); % 重构图像的尺寸

% 选择前三个波段合成RGB图像
if bands >= 3
    fusedImage = Image1(:,:,1:3);  % 选择前三个波段作为RGB通道
else
    % 如果波段数小于3, 选择灰度图像显示
    fusedImage = rgb2gray(Image1);
end

% 显示融合后的图像
imshow(fusedImage); 
title('基于PCA的影像融合');

% 返回融合后的图像
F = fusedImage;
end
