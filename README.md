# 大二上 数字图像处理 大作业

## 🗹 项目概述

本项目的目标是对全色遥感影像（高空间分辨率）和多光谱遥感影像（低空间分辨率）进行融合，得到高空间分辨率的多光谱遥感影像。遥感影像的融合技术可以提高影像的空间分辨率，从而更好地用于土地利用、环境监测、农业监控等领域。

在该任务中，我们使用了多种图像处理方法和技术，包括传统的图像变换技术和深度学习方法，以实现更好的融合效果。

## 🟩 使用的方法

### 1. HIS变换

HIS（色调、饱和度、亮度）变换是一种经典的遥感影像融合方法，通过将影像从RGB颜色空间转换到HIS颜色空间，然后在HIS空间中分别处理高空间分辨率的全色影像和低空间分辨率的多光谱影像。

#### 参考资料：
- [HIS变换、小波变换、Brovery](https://blog.csdn.net/qq_46877697/article/details/115220321)

### 2. 小波变换

小波变换是一种多分辨率分析方法，它能够将图像在不同的尺度上进行分解，从而提取出图像的高频信息。该方法在遥感影像的融合中，能够有效地提高图像的细节保留和分辨率。

#### 参考资料：
- [HIS变换、小波变换、Brovery](https://blog.csdn.net/qq_46877697/article/details/115220321)

### 3. Brovery方法

Brovery方法是一种基于全色图像和多光谱图像的融合方法，通过图像分解技术增强图像的空间和光谱特性，取得了较好的效果。

#### 参考资料：
- [HIS变换、小波变换、Brovery](https://blog.csdn.net/qq_46877697/article/details/115220321)

### 4. SIRF 图像配准及融合框架

SIRF（Synthetic Image Registration and Fusion）是一个集成图像配准与融合的框架，适用于多种遥感影像融合任务。它通过图像配准将影像进行精确对齐，然后使用不同的融合技术提升影像质量。

#### 参考资料：
- [SIRF 图像配准及融合一体化框架](https://cchen156.github.io/SIRF.html)

### 5. PCA（主成分分析）

PCA是一种常用的数据降维方法，适用于多光谱影像的融合中，通过提取主要成分来提高影像的空间分辨率。该方法通过计算影像的主成分来实现影像信息的融合。

#### 参考资料：
- [PCA](https://blog.csdn.net/gsgs1234/article/details/123427714)

### 6. GHIS（改进的HIS方法）

GHIS是HIS方法的改进版，它结合了PCA的降维特性，在HIS空间中对影像进行高效的融合，尤其适用于具有较大光谱差异的遥感数据。

#### 参考资料：
- [GHIS](https://zhuanlan.zhihu.com/p/591118219)

### 7. 深度学习方法：SDPNet

SDPNet是一种基于深度学习的图像融合方法，通过训练神经网络模型来实现图像的高效融合，能够自适应地处理影像中的复杂细节信息。该方法可以显著提升图像的质量，特别是在较高精度需求的任务中表现优异。

#### 参考资料：
- [SDPNet 基于深度学习的融合方法](https://github.com/hanna-xu/SDPNet)



