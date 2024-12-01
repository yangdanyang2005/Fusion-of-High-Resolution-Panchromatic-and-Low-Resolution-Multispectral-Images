% https://blog.csdn.net/qq_46877697/article/details/115220321

%% 清理环境
clc; % 清空命令行窗口
clear; % 清空工作空间的所有变量
close all; % 关闭所有图形窗口
addpath(genpath('.')); % 添加当前目录及其子目录到路径，以便调用相关的函数

%% 加载图片
load Sichuan;

%% 将图片转换为三波段的多光谱低分辨率和全色高分辨率
ImageMS = 255*ImageMS/max(max(max(ImageMS)));
ImageP = 255*ImageP/max(max(max(ImageP)));
tp = ImageMS(:,:,3);
ImageMS(:,:,3) = ImageMS(:,:,1);
ImageMS(:,:,1) = tp;
%全色高分辨率
High=double(ImageP(:,:))/255;
%三波段的多光谱低分辨率
Multy=double(ImageMS(:,:,1:3))/255;
%得到RGB三元色矩阵
Multy_R=Multy(:,:,1)*1.5;
Multy_G=Multy(:,:,2)*1.5;
Multy_B=Multy(:,:,3)*1.5;

%% 将高分辨率影响进行2维小波分解
% c1是对应的整幅图数据的向量；
[c1,s1]=wavedec2(High,2,'sym4');  
sizec1=size(c1);
for I=1:sizec1(2)
    c1(I)=1.8*c1(I); %将分解后的值都扩大
end
%把RGB都变成与高分辨率影响同等大小，再进行小波分解
Multy_R=imresize(Multy_R,[540 600]);
[cr,sr]=wavedec2(Multy_R,2,'sym4');
Multy_G=imresize(Multy_G,[540 600]);
[cg,sg]=wavedec2(Multy_G,2,'sym4');
Multy_B=imresize(Multy_B,[540 600]);
[cb,sb]=wavedec2(Multy_B,2,'sym4');


%% 把RGB的分解值分别都与高分辨率进行求均值与重构
cr1=c1+cr ;     %计算小波系数平均值
cr1=0.5*cr1;
sr1=s1+sr;     %对像素进行求和后取平均
sr1=0.5*sr1;
xxr=waverec2(cr1,sr1,'sym4');  %进行重构

cg1=c1+cg ;     %计算平均值
cg1=0.5*cg1;
sg1=s1+sg;
sg1=0.5*sg1;
xxg=waverec2(cg1,sg1,'sym4');  %进行重构

cb1=c1 +cb ;     %计算平均值
cb1=0.5*cb1;
sb1=s1+sb;
sb1=0.5*sb1;
xxb=waverec2(cb1,sb1,'sym4');  %进行重构

%把重构后的矩阵合成RGB三维矩阵即可
xx=cat(3,xxr,xxg,xxb);
figure(1)
subplot(2,3,1);
imshow(High),title('高分辨率全色影像');
axis square;

subplot(2,3,4);
imshow(Multy),title('低分辨率多波段影像');
axis square;

IHS=rgb2hsv(xx);
S=IHS(:,:,2)*1.8;
IHS(:,:,2)=S;
I=IHS(:,:,3)*0.59;
IHS(:,:,3)=I;

subplot(2,3,[2 6]);
xx=hsv2rgb(IHS);
imshow(1.25*xx),title('融合后高分辨率RGB影像');
axis square;

%% 保存生成的图片
% 检查目标目录是否存在，如果不存在则创建
outputDir = './res/demo/wavedec/'; 
if ~exist(outputDir, 'dir')
    mkdir(outputDir); % 创建目录
end

% 文件格式列表
formats = {'tiff', 'tif', 'png', 'jpg', 'bmp'};

% 将融合后的RGB图像保存为不同的格式
for i = 1:length(formats)
    % 构造输出图像的路径
    outputImagePath = fullfile(outputDir, ['fused_high_res_image.' formats{i}]);

    % 将融合后的RGB图像保存为当前格式
    imwrite(uint8(1.25 * xx * 255), outputImagePath);

    % 输出保存成功的消息
    disp(['融合图像已保存至: ', outputImagePath]);
end
