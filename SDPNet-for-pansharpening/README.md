# SDPNet：基于深度学习的融合方法
## A Deep Network for Pan-sharpening with Enhanced Information Representation (TGRS 2020)    
- 📌 本项目是由 **杨丹阳** 在 2020 年 IEEE TGRS 上的论文《SDPNet: A Deep Network for Pan-Sharpening With Enhanced Information Representation》的开源代码的基础上进行修改和完善的，原项目中部分代码经过了 **杨丹阳** 的重新开发。    
- 👨‍💻 原项目的开源代码： https://github.com/hanna-xu/SDPNet    
原项目的论文： https://ieeexplore.ieee.org/document/9164849    
- ✉ **杨丹阳** 的联系方式： yangdanyang@whu.edu.cn
<br><br>

## 原项目的效果图：
<div align=center><img src="https://github.com/hanna-xu/SDPNet/blob/master/ex.png" width="980" height="250"/></div><br>

## 本项目的效果图：
<div align=center>
    <h3>低空间分辨率的多光谱遥感影像</h3>
    <img src="https://github.com/yangdanyang2005/Fusion-of-High-Resolution-Panchromatic-and-Low-Resolution-Multispectral-Images/blob/main/SDPNet-for-pansharpening/show_imgs/ms/homework.png" width="150" height="135"/>
   </div> <br>
<div align=center>
    <h3>高空间分辨率的全色遥感影像</h3>
    <img src="https://github.com/yangdanyang2005/Fusion-of-High-Resolution-Panchromatic-and-Low-Resolution-Multispectral-Images/blob/main/SDPNet-for-pansharpening/show_imgs/pan/homework.png" width="600" height="540"/>
    </div><br>
    
<div align=center>
    <h3>融合后的高空间分辨率多光谱遥感影像</h3>
    <img src="https://github.com/yangdanyang2005/Fusion-of-High-Resolution-Panchromatic-and-Low-Resolution-Multispectral-Images/blob/main/SDPNet-for-pansharpening/results/homework/output_homework.png" width="600" height="540"/>
</div><br><br>

# 一、本项目的使用说明

## 1. 项目的文件结构
```
SDPNet
├── data
│   ├── DIV2K
│   ├── Flickr2K
│   ├── LIVE
│   ├── REDS
│   ├── SOTS
│   ├── Vid4
│   └── Vimeo90K
├── models
│   ├── P2MS
│   ├── MS2P
│   ├── spec_encoder
│   ├── spec_decoder
│   ├── spat_encoder
│   ├── spat_decoder
│   ├── spec_diff
│   ├── spat_diff
│   └── weights
├── test.py
├── P2MS_main.py
├── MS2P_main.py
├── spec_main.py
├── spat_main.py
├── spec_diff.py
├── spat_diff.py
├── main.py
├── install.bat
├── install.sh
├── README.md
└── requirements.txt
```

请将您的低空间分辨率的多光谱遥感影像放在 `test_imgs/ms` 目录下，并将您的高空间分辨率的全色遥感影像放在 `test_imgs/pan` 目录下，并确保同一块区域的低空间分辨率的多光谱遥感影像与高空间分辨率的全色遥感影像**可以**是不同的尺寸大小（此功能由 **杨丹阳** 在 `test.py` 脚本中编写的代码实现），但是请确保它们的**文件名一致**。

## 2. 环境配置
请确保您已经安装了[`Anaconda`](https://www.anaconda.com/distribution/)，并按照以下步骤进行环境配置：    
Windows系统：请运行由 **杨丹阳** 编写的[环境配置脚本`install.bat`](https://github.com/yangdanyang2005/Fusion-of-High-Resolution-Panchromatic-and-Low-Resolution-Multispectral-Images/SDPNet-for-pansharpening/install.bat)。  
Linux系统：请运行由 **杨丹阳** 编写的[环境配置脚本`install.sh`](https://github.com/yangdanyang2005/Fusion-of-High-Resolution-Panchromatic-and-Low-Resolution-Multispectral-Images/SDPNet-for-pansharpening/install.sh)。  

## 3. 使用预训练模型进行测试
请运行 `test.py`。    
运行产生的结果（'.mat'格式的图像数据、多种格式的高空间分辨率多光谱遥感影像）将保存在  `results` 目录下的单独的文件夹下，这些单独的文件夹的文件名是“ `output_imgName.png` ”，其中 `imgName` 是您开始时输入到`test_imgs`文件夹中的图像的名称，`save_formats` 包括 `.tiff` 、`.tif` 、`.png` 、`.jpg` 、`.bmp` 文件格式（此功能由 **杨丹阳** 编写的 `show.py` 脚本实现，在 `test.py` 中调用）。

## 4. 训练您自己的模型
* 步骤1: 下载 [`h5 文件`](https://github.com/hanna-xu/SDPNet-for-pansharpening/blob/master) 或者根据 [<u>此链接中的说明</u>](https://github.com/hanna-xu/utils) 创建您自己的 `h5 文件`；
* 步骤2: 运行 `P2MS_main.py` 和 `MS2P_main.py` 用于 P2MS 和 MS2P 模型；
* 步骤3: 运行 `spec_main.py` 和 `spat_main.py` 用于空间和光谱编码器与解码器；
* 步骤4: 运行 `spec_diff.py` 和 `spat_diff.py` 用于特殊的通道；
* 步骤5: 运行 `main.py` 来训练 (需要 2 个 GPU)。
<br><br>

# 二、来自原项目的说明

If this work is helpful, please cite it as:
```
@article{xu2020sdpnet,
  title={SDPNet: A Deep Network for Pan-Sharpening With Enhanced Information Representation},
  author={Xu, Han and Ma, Jiayi and Shao, Zhenfeng and Zhang, Hao and Jiang, Junjun and Guo, Xiaojie},
  journal={IEEE Transactions on Geoscience and Remote Sensing},
  year={2020},
  publisher={IEEE}
}
```

在此作为本项目对原项目的引用，并对原项目的作者表示感谢！

# 三、引用本项目

如果您在您的研究或项目中使用了本项目，请按照以下方式进行引用：
```
@misc{yangdanyang2024sdpnet, 
    title = {SDPNet: 基于深度学习的融合方法}, 
    author = {杨丹阳}, 
    year = {2024}, 
    url = {https://github.com/yangdanyang2005/Fusion-of-High-Resolution-Panchromatic-and-Low-Resolution-Multispectral-Images}, 
    note = {GitHub repository}, 
}
```
感谢您对本项目的支持与关注，引用本项目有助于推动遥感影像融合领域的进一步发展。如有任何问题或建议，欢迎通过 **yangdanyang@whu.edu.cn** 联系我！😀
