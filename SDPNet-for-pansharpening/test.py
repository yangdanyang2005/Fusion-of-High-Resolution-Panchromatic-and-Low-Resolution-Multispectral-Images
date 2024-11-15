# 基于深度学习的融合方法
# https://github.com/hanna-xu/SDPNet

from __future__ import print_function

import time
import os
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
import scipy.ndimage
# from scipy.misc import imread, imsave
import imageio # https://blog.csdn.net/weixin_42363541/article/details/135023378
from skimage import transform, data
from glob import glob
import matplotlib.image as mpimg
import scipy.io as scio
import cv2
from pnet import PNet #_tradition
import time
import show  # 导入 show 模块，使用 show.py 中的内容

from glob import glob
from tensorflow.python import pywrap_tensorflow # https://blog.csdn.net/iamjingong/article/details/107683131
# 请注意： TensorFlow 2.x 版本与 TensorFlow 1.x 版本的架构完全不同！
from tqdm import tqdm # 如果需要处理的文件具有多种后缀，可以使用 glob 模块结合多个通配符来匹配不同的文件类型；可以通过 os.path.splitext() 检查文件的名称是否相同（不考虑后缀），确保正确匹配每对图像。

MODEL_SAVE_PATH = './models/5130.ckpt'
path1 = 'test_imgs/pan'
path2 = 'test_imgs/ms'
output_path = 'results'

def ensure_no_transparency(image): # 设置 Alpha 通道为完全不透明，不然输出的 .tiff .tif .png 图像会受到背景影响
    # 如果图片是RGBA格式，去掉Alpha通道
    if image.shape[-1] == 4:
        image = image[:, :, :3]  # 仅保留RGB通道
    # 如果图片是RGB格式但某些像素的透明度是0，可以设置为255
    if image.min() < 1:  # 如果图片有透明像素
        image[image == 0] = 255  # 设置透明像素为完全不透明
    return image

def process_image_pair(file_name1, file_name2, output_file_name):
    # 读取并预处理图像
    pan = imageio.imread(file_name1) / 255.0
    ms = imageio.imread(file_name2) / 255.0
    print('Processing:', file_name1, 'shape:', pan.shape)
    print('Processing:', file_name2, 'shape:', ms.shape)

    h1, w1 = pan.shape
    pan = pan.reshape([1, h1, w1, 1])
    
    h2, w2, c = ms.shape
    if c == 3:  # 如果是RGB图像
        ms = ms.reshape([1, h2, w2, 3])
    else:  # 如果是RGBA图像
        ms = ms.reshape([1, h2, w2, 4])

    with tf.Graph().as_default(), tf.compat.v1.Session() as sess:
        MS = tf.compat.v1.placeholder(tf.float32, shape=(1, h2, w2, c), name='MS')
        PAN = tf.compat.v1.placeholder(tf.float32, shape=(1, h1, w1, 1), name='PAN')

        # 构建和恢复模型
        Pnet = PNet('pnet')
        X = Pnet.transform(PAN=PAN, ms=MS)
        t_list = tf.compat.v1.trainable_variables()
        saver = tf.compat.v1.train.Saver(var_list=t_list)
        
        sess.run(tf.compat.v1.global_variables_initializer())
        saver.restore(sess, MODEL_SAVE_PATH)

        # 执行模型并保存输出
        output = sess.run(X, feed_dict={PAN: pan, MS: ms})
        scio.savemat(output_file_name, {'i': output[0, :, :, :]})

        
def main():
    print('---------------------------------------------------------------------------\n"test.py"这个脚本经过了 杨丹阳 的大量修改，使得其可以正常运行，并且可以处理用户自己的数据集。')
    print('运行前，如果您使用的是 Windows 系统，请使用 杨丹阳 写的 install.bat 在 Windows 下配置conda虚拟环境，并安装所需的依赖库；')
    print('如果您使用的是 Linux 系统，请使用 杨丹阳 写的 install.sh 在 Linux 下配置conda虚拟环境，并安装所需的依赖库。\n---------------------------------------------------------------------------')

    print('\nBegin to generate pictures ...\n')
    t = []
      
    # 获取所有文件后缀的图像
    pan_files = glob(os.path.join(path1, '*'))
    ms_files = glob(os.path.join(path2, '*'))

      # 根据文件名（不含后缀）匹配每对文件
    pan_dict = {os.path.splitext(os.path.basename(f))[0]: f for f in pan_files}
    ms_dict = {os.path.splitext(os.path.basename(f))[0]: f for f in ms_files}
    common_files = set(pan_dict.keys()).intersection(ms_dict.keys())
    print("---------------------------------------------------------------------------\nPAN files:", list(pan_dict.keys()))
    print("MS files:", list(ms_dict.keys()))
    print("Common files:", list(common_files),'\n---------------------------------------------------------------------------')
  
    # 对所有匹配的图像文件对进行处理
    for i, file_key in tqdm(enumerate(common_files, 1), total=len(common_files)):
        file_name1 = pan_dict[file_key]
        file_name2 = ms_dict[file_key]
        
        # 创建一个与原始文件名相同的输出目录
        file_output_dir = os.path.join(output_path, file_key)
        if not os.path.exists(file_output_dir):
            os.makedirs(file_output_dir)
        
        # 设置输出文件路径到对应的文件夹中
        output_file_name = os.path.join(file_output_dir, f'{file_key}.mat')
        
        # 处理图像对并生成输出文件
        begin = time.time()
        process_image_pair(file_name1, file_name2, output_file_name)
        end = time.time()
        t.append(end - begin)

        # 调用 show.py 函数显示或进一步处理图像
        show.process_and_show_image(img_file_name=file_key)
    
    # for i in tqdm(range(1)):
    # 	file_name1 = path1 + str(i + 1) + '.png'
    # 	file_name2 = path2 + str(i + 1) + '.tif'

    # 	# pan = imread(file_name1) / 255.0
    # 	# ms = imread(file_name2) / 255.0
    # 	pan=imageio.imread(file_name1)/255.0
    # 	ms=imageio.imread(file_name2)/255.0

    # 	print('file1:', file_name1, 'shape:', pan.shape)
    # 	print('file2:', file_name2, 'shape:', ms.shape)

    # 	h1, w1 = pan.shape
    # 	pan = pan.reshape([1, h1, w1, 1])
    # 	h2, w2, c = ms.shape
    # 	ms = ms.reshape([1, h2, w2, 4])


    # 	with tf.Graph().as_default(), tf.Session() as sess:
    # 	# with tf.Graph().as_default(), tf.compat.v1.Session() as sess:
    # 		# https://blog.csdn.net/weixin_45504596/article/details/108269713
    # 		# 报错：AttributeError: module 'tensorflow' has no attribute 'Session'. Did you mean: 'version'?
    # 		# 安装的是tensorflow2.X版本，而tf.Session()是tensorflow1.X中的代码

    # 		MS = tf.placeholder(tf.float32, shape = (1, h2, w2, 4), name = 'MS')
    # 		PAN = tf.placeholder(tf.float32, shape = (1, h1, w1, 1), name = 'PAN')
    # 		# MS = tf.compat.v1.placeholder(tf.float32, shape = (1, h2, w2, 4), name = 'MS')
    # 		# PAN = tf.compat.v1.placeholder(tf.float32, shape = (1, h1, w1, 1), name = 'PAN')
    # 		# AttributeError: module 'tensorflow' has no attribute 'placeholder'
    # 		# https://blog.csdn.net/weixin_44870245/article/details/136161969
    # 		# 在TensorFlow 2.x版本中，placeholder已经被移除

    # 		Pnet = PNet('pnet')
    # 		X = Pnet.transform(PAN = PAN, ms = MS)


    # 		t_list = tf.trainable_variables()


    # 		saver = tf.train.Saver(var_list = t_list)
    # 		begin = time.time()
    # 		sess.run(tf.global_variables_initializer())
    # 		saver.restore(sess, MODEL_SAVE_PATH)

    # 		output = sess.run(X, feed_dict = {PAN: pan, MS: ms})

    # 		if not os.path.exists(output_path):
    # 			os.makedirs(output_path)
    # 		scio.savemat(output_path + str(i + 1) + '.mat', {'i': output[0, :, :, :]})
    # 		"""
    # 		生成的这个 .mat 文件是一个 MATLAB 文件，其中保存了 output 变量的内容，即通过 PNet 模型处理后的图像数据。
    # 		要可视化这个 .mat 文件的内容，可以用 Python 或 MATLAB 来加载和显示
    # 		"""
    # 		end=time.time()
    # 		t.append(end-begin)

    print("\n---------------------------------------------------------------------------\n所有影像处理完成。\nTime: mean: %s, std: %s\n---------------------------------------------------------------------------\n" % (np.mean(t), np.std(t)))


if __name__ == '__main__':
    if not os.path.exists(output_path):
        os.makedirs(output_path)
    main()