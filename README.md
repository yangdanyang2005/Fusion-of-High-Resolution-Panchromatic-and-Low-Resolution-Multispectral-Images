# 大二上 数字图像处理 大作业：高空间分辨率的全色遥感影像和低空间分辨率的多光谱遥感影像融合生成高空间分辨率的多光谱遥感影像

## 🏗 项目概述

本项目的目标是对全色遥感影像（高空间分辨率）和多光谱遥感影像（低空间分辨率）进行融合，得到高空间分辨率的多光谱遥感影像。遥感影像的融合技术可以提高影像的空间分辨率，从而更好地用于土地利用、环境监测、农业监控等领域。

在该任务中，我使用了多种图像处理方法和技术，包括传统的图像变换技术和深度学习方法，以实现更好的融合效果。

## 🖊️ 使用的方法

### 1. [HIS变换](https://blog.csdn.net/qq_46877697/article/details/115220321)

HIS（色调、饱和度、亮度）变换是一种经典的遥感影像融合方法，通过将影像从RGB颜色空间转换到HIS颜色空间，然后在HIS空间中分别处理高空间分辨率的全色影像和低空间分辨率的多光谱影像。



### 2. [小波变换](https://blog.csdn.net/qq_46877697/article/details/115220321)

小波变换是一种多分辨率分析方法，它能够将图像在不同的尺度上进行分解，从而提取出图像的高频信息。该方法在遥感影像的融合中，能够有效地提高图像的细节保留和分辨率。


### 3. [Brovery方法](https://blog.csdn.net/qq_46877697/article/details/115220321)

Brovery方法是一种基于全色图像和多光谱图像的融合方法，通过图像分解技术增强图像的空间和光谱特性，取得了较好的效果。



### 4. [SIRF 图像配准及融合一体化框架](https://cchen156.github.io/SIRF.html)

SIRF（Synthetic Image Registration and Fusion）是一个集成图像配准与融合的框架，适用于多种遥感影像融合任务。它通过图像配准将影像进行精确对齐，然后使用不同的融合技术提升影像质量。



### 5. [PCA（主成分分析）](https://blog.csdn.net/gsgs1234/article/details/123427714)

PCA是一种常用的数据降维方法，适用于多光谱影像的融合中，通过提取主要成分来提高影像的空间分辨率。该方法通过计算影像的主成分来实现影像信息的融合。

 

### 6. [GHIS（改进的HIS方法）](https://zhuanlan.zhihu.com/p/591118219)

GHIS是HIS方法的改进版，它结合了PCA的降维特性，在HIS空间中对影像进行高效的融合，尤其适用于具有较大光谱差异的遥感数据。



### 7.  [SDPNet 基于深度学习的融合方法](https://github.com/hanna-xu/SDPNet)

SDPNet是一种基于深度学习的图像融合方法，通过训练神经网络模型来实现图像的高效融合，能够自适应地处理影像中的复杂细节信息。该方法可以显著提升图像的质量，特别是在较高精度需求的任务中表现优异。

### 8.  [基于平滑滤波器的影像融合方法（SFIM）](https://blog.csdn.net/weixin_34161064/article/details/93042403)

SFIM 是一种基于平滑滤波器的影像融合方法，主要用于将低分辨率的多光谱影像与高分辨率的全色影像进行融合，以生成既具有高空间分辨率又保留多光谱信息的影像。由于其平滑特性，融合产生的影像会有一定模糊。

## 🥺 求助
我曾尝试利用[HySure](https://github.com/alfaiate/HySure)项目中的方法来完成本遥感影像融合任务，但未能成功实现。    
希望能有看到本储存库的朋友们帮忙实现一下，非常感谢你的帮助！实现后欢迎联系我哦！

## ✉️ 联系作者

如果您有任何问题或建议，欢迎通过以下方式联系作者：

邮箱：yangdanyang@whu.edu.cn

## 💐 致谢

感谢所有在遥感影像融合领域做出贡献的研究人员以及开源社区的支持，特别是SIRF框架和SDPNet深度学习模型的提供者。
