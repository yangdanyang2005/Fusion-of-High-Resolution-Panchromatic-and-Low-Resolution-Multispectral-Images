% 图像配准及融合一体化框架
% http://glcf.umd.edu/data/ikonos/

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This is the demo code for 
%%%% "SIRF: Simultaneous Image Registration and Fusion in a unified
%%%% framework", by Chen Chen, Yeqing Li, Wei Liu and Junzhou Huang

%%%% and "Image Fusion with Local Spectral Consistency and Dynamic Gradient Sparsity"
%%%% by Chen Chen, Yeqing Li, Wei Liu and Junzhou Huang, CVPR 2014.

%%%% Contact: Chen Chen (chenchen.cn87@gmail.com) and Junzhou Huang
%%%% (jzhuang@uta.edu), Department of Computer Science and Engineering,
%%%% University of Texas at Arlington 

%%%% If you used our code, please cite our papers!


%%%% The dataset is downloaded from: 
%%%% GeoEye owns all IKONOS imagery. Access is provided here for education or research purposes only.
%%%% Users must credit GeoEye when using this imagery.

% 这段代码是一个图像注册和融合的演示代码，基于两篇论文中的方法：https://cchen156.github.io/SIRF.html

% SIRF: Simultaneous Image Registration and Fusion in a Unified Framework 
% 由 Chen Chen, Yeqing Li, Wei Liu 和 Junzhou Huang 提出。

% Image Fusion with Local Spectral Consistency and Dynamic Gradient Sparsity 
% 由 Chen Chen, Yeqing Li, Wei Liu 和 Junzhou Huang 在 CVPR 2014 发表。

% 代码的主要目的是进行图像的配准（Registration）和融合（Fusion），
% 并通过 SIRF 算法来处理多光谱图像（Multispectral Image, MS）和全色图像（Pan-sharpened Image, P）。

% 这个 demo.py 脚本经过了 杨丹阳 的大量修改。

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 清理环境
clc; % 清空命令行窗口
clear; % 清空工作空间的所有变量
close all; % 关闭所有图形窗口
addpath(genpath('.')); % 添加当前目录及其子目录到路径，以便调用相关的函数

%% 加载数据
load Sichuan; %  加载名为 Sichuan 的数据集，包含了多光谱图像（ImageMS）和全色图像（ImageP）
ImageMS = 255*ImageMS/max(max(max(ImageMS)));
ImageP = 255*ImageP/max(max(max(ImageP))); % 对这两幅图像进行归一化，使其像素值在 0 到 255 之间

%% 交换多光谱图像的波段
tp = ImageMS(:,:,3);
ImageMS(:,:,3) = ImageMS(:,:,1);
ImageMS(:,:,1) = tp; % 将 ImageMS 图像的红色（第 1 波段）和蓝色（第 3 波段）进行交换，调整多光谱图像的通道顺序

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 初始化参数
T= size(ImageMS,3); % 多光谱图像的波段数（通常为 3 或 4）
[m,n] = size(ImageP); % 获取全色图像 ImageP 的尺寸
divK = 4; % 用于图像分块的参数（这里设置为 4）

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  SIRF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SIRF 配准和融合
fprintf(1,'SIRF...\n'); % SIRF 是进行图像配准和融合的核心函数
lambda = 5; % 控制融合过程的参数
[im,P]= SIRF(ImageMS,ImageP,divK,lambda, 150,3,0);
% SIRF 函数的参数包括：
% ImageMS 多光谱图像。
% ImageP 全色图像。
% divK 用于分块的参数。
% lambda 调节融合的参数。
% 150 是迭代次数。
% 3 和 1 控制其他算法细节。
% im 是融合后的图像，P 是注册后的全色图像

% use this one for showing the registration process
% [im,P]= SIRF(ImageMS,ImageP,divK,lambda, 150,3,1);

%% 裁剪图像
% crop valid pixels
vv = 9; %% 通过裁剪图像，去除边界部分（vv = 9）来避免因边缘效应造成的干扰
ImageMS = ImageMS(floor(vv/4)+1:end-floor(vv/4),floor(vv/4)+1:end-floor(vv/4),:);
ImageP = ImageP(vv:end-vv+1,vv:end-vv+1,:);
im = im(vv:end-vv+1,vv:end-vv+1,:);
P = P(vv:end-vv+1,vv:end-vv+1,:);

%% 创建输出目录
output_dir = './res/demo/SIRF/';
if ~exist(output_dir, 'dir')
    mkdir(output_dir); % 如果目录不存在，则创建目录
end

%% 显示结果
close all; % 关闭所有之前打开的图形窗口

% 使用 subplot 显示多个图像
figure; % 打开一个新的图形窗口

% 给整个窗口加标题
sgtitle('Image Registration and Fusion Results'); % 设置窗口的标题

subplot(2, 3, 1); imshow(uint8((ImageP(:,:))),[]); title('Original Pan'); % 显示原始的全色图像
imwrite(uint8((ImageP(:,:))), [output_dir, 'Original_Pan.png']); % 保存原始的全色图像

subplot(2, 3, 4); imshow(uint8((P(:,:))),[]); title('Registered Pan by SIRF');  % 显示注册后的全色图像
imwrite(uint8((P(:,:))), [output_dir, 'Registered_Pan_by_SIRF.png']); % 保存注册后的全色图像

subplot(2, 3, 2); imshow(uint8((ImageMS(:,:,1:3))),[]); title('Original RGB'); % 显示原始RGB图像
imwrite(uint8((ImageMS(:,:,1:3))), [output_dir, 'Original_RGB.png']); % 保存原始RGB图像

subplot(2, 3, 5); imshow(uint8((im(:,:,1:3))),[]); title('Fusion by SIRF (RGB)'); 
imwrite(uint8((im(:,:,1:3))), [output_dir, 'Fusion_RGB.png']); % 保存融合后的RGB图像

subplot(2, 3, 3); imshow(uint8((ImageMS(:,:,4))),[]); title('Original Nir'); % 显示原始近红外图像
imwrite(uint8((ImageMS(:,:,4))), [output_dir, 'Original_Nir.png']); % 保存原始近红外图像

subplot(2, 3, 6); imshow(uint8((im(:,:,4))),[]); title('Fusion by SIRF (Nir)'); % 显示融合后的近红外图像
imwrite(uint8((im(:,:,4))), [output_dir, 'Fusion_Nir.png']); % 保存融合后的近红外图像
