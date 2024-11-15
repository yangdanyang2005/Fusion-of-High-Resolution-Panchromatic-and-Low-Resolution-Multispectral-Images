% https://blog.csdn.net/qq_46877697/article/details/115220321

%% 清理环境
clc; % 清空命令行窗口
clear; % 清空工作空间的所有变量
close all; % 关闭所有图形窗口
addpath(genpath('.')); % 添加当前目录及其子目录到路径，以便调用相关的函数

%% 加载图片
ImageMS = imread('homework_ori/MS.tiff');  % 读取多光谱低分辨率图像
ImageP = imread('homework_ori/P.tiff');    % 读取全色高分辨率图像

%% 将图片转换为三波段的光谱低分辨率和全色高分辨率
tp = ImageMS(:,:,3);
ImageMS(:,:,3) = ImageMS(:,:,1);
ImageMS(:,:,1) = tp;
% 全色高分辨率
High = ImageP(:,:);
% 三波段的多光谱低分辨率
Multy = ImageMS(:,:,1:3);

% 多光谱影像从RGB转到IHS
IHS = rgb2hsv(Multy); % 不再进行归一化
% 得到IHS矩阵的第三页，因为第三页才是I亮度
I = IHS(:,:,3);

%% 进行灰度直方图的规定化
[m_mul, n_mul, d_mul] = size(I); % 获取多光谱图像尺寸
% 计算多光谱图像的灰度直方图
Multy_hist = imhist(I) / (m_mul * n_mul);

% 读入要规定化的高分辨率图像
[q, p] = imhist(High);
[m_h, n_h, d_h] = size(High); % 获取高分辨率图像尺寸
% 计算高分辨率图像的灰度直方图
High_hist = imhist(High) / (m_h * n_h);

Mul_V = [];
High_V = [];

% 计算规定累计直方图和原始累计直方图概率
for i = 1:256
    Mul_V = [Mul_V, sum(Multy_hist(1:i))];
    High_V = [High_V, sum(High_hist(1:i))];
end

% 对像素进行SML映射
index = zeros(1, 256); % 初始化索引数组
for i = 1:256
    value{i} = Mul_V - High_V(i);
    value{i} = abs(value{i}); % 取绝对值
    [~, index(i)] = min(value{i}); % 找到最接近的灰度值
end

% 将高分辨率图像转换为 uint8 类型
High = uint8(High);

% 创建新图像矩阵
newimg = zeros(m_h, n_h);
for i = 1:m_h
    for j = 1:n_h
        % 进行灰度级映射
        newimg(i,j) = index(High(i,j) + 1) - 1;
    end
end

% 显示并保存直方图
subplot(3,6,[13 14]);
imhist(uint8(High)); title('变换前的高分辨率图像直方图'); 
subplot(3,6,[15 16]);
imhist(uint8(Multy)); title('多光谱影像直方图');
subplot(3,6,[17 18]);
imhist(newimg/255); title('规定化变换后的高分辨率直方图');

% 重新调整 IHS 的 H 和 S 通道大小，与高分辨率图像相同
newIHS(:,:,1) = imresize(IHS(:,:,1), [540, 600]);
newIHS(:,:,2) = imresize(IHS(:,:,2), [540, 600]);
newIHS(:,:,3) = newimg;

%% 转换回 RGB 并输出图像
newRGB = hsv2rgb(newIHS); % 从 IHS 转换为 RGB
subplot(3,6,[1 8]);
imshow(uint8(High)); title('全色高分辨率图像');
subplot(3,6,[3 10]);
imshow(uint8(Multy)); title('融合前的多光谱影像');
subplot(3,6,[5 12]);
imshow(uint8(newRGB)); title('融合的高分辨率RGB图像');

%% 保存生成的图片
% 检查目标目录是否存在，如果不存在则创建
outputDir = './res/homework/HIS';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% 生成输出图像的文件路径
outputImageBase = fullfile(outputDir, 'fused_high_res_image');

% 保存为不同格式
imwrite(uint8(newRGB), [outputImageBase, '.png']);
disp(['PNG格式的融合图像已保存至: ', outputImageBase, '.png']);
imwrite(uint8(newRGB), [outputImageBase, '.jpg']);
disp(['JPG格式的融合图像已保存至: ', outputImageBase, '.jpg']);
imwrite(uint8(newRGB), [outputImageBase, '.tiff']);
disp(['TIFF格式的融合图像已保存至: ', outputImageBase, '.tiff']);
imwrite(uint8(newRGB), [outputImageBase, '.tif']);
disp(['TIF格式的融合图像已保存至: ', outputImageBase, '.tif']);
imwrite(uint8(newRGB), [outputImageBase, '.bmp']);
disp(['BMP格式的融合图像已保存至: ', outputImageBase, '.bmp']);
