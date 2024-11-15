% https://blog.csdn.net/qq_46877697/article/details/115220321

%% 清理环境
clc; % 清空命令行窗口
clear; % 清空工作空间的所有变量
close all; % 关闭所有图形窗口
addpath(genpath('.')); % 添加当前目录及其子目录到路径，以便调用相关的函数

%% 加载图片
load Sichuan;

%% 将图片转换为三波段的光谱低分辨率和全色高分辨率
ImageMS = 255*ImageMS/max(max(max(ImageMS)));
ImageP = 255*ImageP/max(max(max(ImageP)));
tp = ImageMS(:,:,3);
ImageMS(:,:,3) = ImageMS(:,:,1);
ImageMS(:,:,1) = tp;
%全色高分辨率
High=ImageP(:,:);
%三波段的多光谱低分辨率
Multy=ImageMS(:,:,1:3);

%多光谱影像从RGB转到IHS
IHS=rgb2hsv(Multy/255);
%得到IHS矩阵的第三页，因为第三页才是I亮度
I=IHS(:,:,3);

%% 下面进行灰度直方图的规定化，把I作为标准，对高分辨率影像进行处理
%读入标准图像，得到I的大小和维度
[m_mul,n_mul,d_mul]=size(I);
%计算规定直方图各个像素的概率
Multy_hist=(imhist(I)/(m_mul*n_mul));

%读入要被规定化的图像
[q,p]=imhist(High/255);
%得到高分辨率影像的大小及其维度
[m_h,n_h,d_h]=size(High);
%计算原始直方图各个像素的概率
High_hist=(imhist((High/255))/(m_h*n_h));

Mul_V=[];
High_V=[];

%计算规定累计直方图和原始累计直方图概率
for i=1:256
    Mul_V=[ Mul_V sum(Multy_hist(1:i))];
    High_V=[High_V sum(High_hist(1:i))];
end

%开始对像素进行SML映射
for i=1:256
    %把多光谱的累计概率与高分辨率的累计概率的每一个概率做差
    value{i}=Mul_V-High_V(i);
    %取绝对值（因为接近无论 正负）
    value{i}=abs(value{i});
    %找到最接近的，即为映射的灰度级（index）【即原始图像第i级对应第index(i)级】
    %temp是最小值
    [temp index(i)]=min(value{i});
end

High=uint8(High);
%设新图像的大小与高分辨率图像等大
newimg=zeros(m_h,n_h);
%对新I像素进行赋值
for i=1:m_h
    for j=1:n_h
        %把规定化后的灰度级赋值给newimg
        newimg(i,j)=index((High(i,j)+1))-1;
    end
end

subplot(3,6,[13 14]);
imhist(uint8(High)); title('变换前的高分辨率图像直方图'); 
subplot(3,6,[15 16]);
imhist(uint8(Multy));title('多光谱影像直方图');
subplot(3,6,[17 18]);
imhist(newimg/255);title('规定化变换后的高分辨率直方图');

%把IHS的H与S变成与高分辨率图像等大，同时把IHS的原I用新的I替换
newIHS(:,:,1)=imresize(IHS(:,:,1),[540,600]);
newIHS(:,:,2)=imresize(IHS(:,:,2),[540,600]);
newIHS(:,:,3)=newimg;

%% 把替换完成的图像从IHS转为RGB，并输出图像
newRGB=hsv2rgb(newIHS);
subplot(3,6,[1 8]);
imshow(uint8(High));
title('全色高分辨率图像');
subplot(3,6,[3 10]);
imshow(uint8(Multy));
title('融合前的多光谱影像');
subplot(3,6,[5 12]);
imshow(uint8(newRGB));
title('融合的高分辨率RGB图像');

%% 保存生成的图片
% 检查目标目录是否存在，如果不存在则创建
outputDir = './res/demo/HIS';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% 生成输出图像的文件路径
outputImageBase = fullfile(outputDir, 'fused_high_res_image');

% 将融合后的RGB图像保存为不同格式

% 保存为 PNG 格式
outputImagePathPNG = [outputImageBase, '.png'];
imwrite(uint8(newRGB), outputImagePathPNG);
disp(['PNG格式的融合图像已保存至: ', outputImagePathPNG]);

% 保存为 JPG 格式
outputImagePathBMP = [outputImageBase, '.jpg'];
imwrite(uint8(newRGB), outputImagePathBMP);
disp(['JPG格式的融合图像已保存至: ', outputImagePathBMP]);

% 保存为 TIFF 格式
outputImagePathTIFF = [outputImageBase, '.tiff'];
imwrite(uint8(newRGB), outputImagePathTIFF);
disp(['TIFF格式的融合图像已保存至: ', outputImagePathTIFF]);

% 保存为 TIF 格式
outputImagePathTIF = [outputImageBase, '.tif'];
imwrite(uint8(newRGB), outputImagePathTIF);
disp(['TIF格式的融合图像已保存至: ', outputImagePathTIF]);

% 保存为 BMP 格式
outputImagePathBMP = [outputImageBase, '.bmp'];
imwrite(uint8(newRGB), outputImagePathBMP);
disp(['BMP格式的融合图像已保存至: ', outputImagePathBMP]);
