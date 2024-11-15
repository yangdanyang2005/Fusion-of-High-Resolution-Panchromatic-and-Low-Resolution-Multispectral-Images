% https://blog.csdn.net/qq_46877697/article/details/115220321

%% 清理环境
clc; % 清空命令行窗口
clear; % 清空工作空间的所有变量
close all; % 关闭所有图形窗口
addpath(genpath('.')); % 添加当前目录及其子目录到路径，以便调用相关的函数

%% 加载图像
load Sichuan;

%% 将图片转换为三波段的多光谱低分辨率和全色高分辨率
tp = ImageMS(:,:,3);
ImageMS(:,:,3) = ImageMS(:,:,1);
ImageMS(:,:,1) = tp;
% 确保ImageMS是三波段的RGB图像
ImageMS_rgb = uint8(ImageMS(:,:,1:3)); % 选择前三个波段并转为uint8

% 全色高分辨率
High = double(ImageP(:,:))/255;
% 三波段的多光谱低分辨率
Multy = double(ImageMS_rgb)/255;
Multy = imresize(Multy, [540 600]);
[a, b, c] = size(Multy);
x = double(Multy);
y1 = double(High);
xx = zeros(a, b, c);
p = zeros(a, b, c);
% 根据公式
% R=pan*band3/(band1+band2+ band3)
% G=pan*band2/(band1+band2+ band3)
% B=pan*band1/(band1+band2+ band3)
for f = 1:a
    for e = 1:b
        xx(f, e) = x(f, e, 1) + x(f, e, 2) + x(f, e, 3);
        p(f, e, 1) = x(f, e, 1) * y1(f, e) / xx(f, e);
        p(f, e, 2) = x(f, e, 2) * y1(f, e) / xx(f, e);
        p(f, e, 3) = x(f, e, 3) * y1(f, e) / xx(f, e);
    end
end

% 显示原始数据和融合图像
figure;
subplot(2, 3, 1); % 三个子图中的第一个
imshow(ImageMS_rgb);
title('原始低分辨率多光谱图像');

subplot(2, 3, 4); % 三个子图中的第二个
imshow(ImageP/255);
title('原始高分辨率全色图像');

subplot(2, 3, [2 6]); % 三个子图中的第三个
imshow(p * 4);
title('融合图像');

%% 保存生成的图片
% 检查目标目录是否存在，如果不存在则创建
outputDir = './res/demo/brovery/'; 
if ~exist(outputDir, 'dir')
    mkdir(outputDir); % 创建目录
end

% 文件格式列表
formats = {'tiff', 'tif', 'png', 'jpg', 'bmp'};

% 将融合后的RGB图像保存为不同的格式
for i = 1:length(formats)
    % 构造输出图像的路径
    outputImagePath = fullfile(outputDir, ['fused_high_res_image.' formats{i}]);

    % 确保保存时的图像数据是合理的
    % 使用 min 和 max 进行图像值的归一化，确保图像像素值在 0 到 255 之间
    fused_image = uint8(255 * (p - min(p(:))) / (max(p(:)) - min(p(:)))); 

    % 如果需要增强图像，可以手动调整每个通道的亮度和对比度
    for channel = 1:3
        fused_image(:,:,channel) = imadjust(fused_image(:,:,channel), stretchlim(fused_image(:,:,channel)));
    end

    % 将融合后的RGB图像保存为当前格式
    imwrite(fused_image, outputImagePath);

    % 输出保存成功的消息
    disp(['融合图像已保存至: ', outputImagePath]);
end
