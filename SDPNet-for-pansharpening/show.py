# show.py
# -----------------------------------------------------------------------------
# This script was created by Yang Danyang.
# Copyright © 2024 Yang Danyang. All rights reserved.
# -----------------------------------------------------------------------------

import scipy.io as scio
import matplotlib.pyplot as plt
import numpy as np
# import cv2  # 导入 OpenCV 用于直方图均衡化
from PIL import Image  # 导入PIL库以支持保存为JPG格式
import tkinter as tk
from tkinter import Toplevel
from PIL import ImageTk  # 导入PIL库以支持Tkinter显示

def process_and_show_image(img_file_name='1', save_formats=None):

    print('---------------------------------------------------------------------------\n"show.py"这个脚本是 杨丹阳 写的，使得可以将产生的融合后的.mat文件储存为多种格式的图像文件，并可视化显示。\n---------------------------------------------------------------------------')

    if save_formats is None:
        # save_formats = ['tiff', 'tif', 'png', 'jpg', 'bmp']  # 默认保存格式为 'tiff', 'tif', 'png', 'jpg'
        save_formats = ['bmp', 'jpg']  # 默认保存格式为 BMP 和 JPG

    # 加载 .mat 文件
    data = scio.loadmat(f'results/{img_file_name}/{img_file_name}.mat')

    # 读取图像数据，这里假设保存的键是 'i'
    output_image = data['i']

    # 可视化图像
    # plt.imshow(output_image, cmap='gray')
    # plt.colorbar()
    # plt.show()

    # 归一化到 [0, 1]
    output_image_normalized = (output_image - np.min(output_image)) / (np.max(output_image) - np.min(output_image))
    # """
    # 报错信息：
    # Clipping input data to the valid range for imshow with RGB data ([0..1] for floats or [0..255] for integers).
    # Traceback (most recent call last):
    # File "d:/杨丹阳/大学/大二上/大二上 数字图像处理/2024 李彦胜老师 数图大作业/SDPNet-for-pansharpening/show.py", line 19, in <module>
    #     plt.imsave(output_path, output_image, cmap='gray')
    # File "D:\Users\Lenovo\anaconda3\envs\sdpnet\lib\site-packages\matplotlib\pyplot.py", line 2163, in imsave
    #     return matplotlib.image.imsave(fname, arr, **kwargs)
    # File "D:\Users\Lenovo\anaconda3\envs\sdpnet\lib\site-packages\matplotlib\image.py", line 1641, in imsave
    #     rgba = sm.to_rgba(arr, bytes=True)
    # File "D:\Users\Lenovo\anaconda3\envs\sdpnet\lib\site-packages\matplotlib\cm.py", line 437, in to_rgba
    #     raise ValueError("Floating point image RGB values "
    # ValueError: Floating point image RGB values must be in the 0..1 range.

    # 解决方法：
    # 错误提示说明 output_image 数值不在 [0, 1] 范围内，因此在保存时遇到了问题。可以通过将图像数据归一化到 [0, 1] 来解决这个问题。
    # """

    # 将归一化后的图像转换为连续数组
    output_image_contiguous = np.ascontiguousarray(output_image_normalized)

    # """
    # 报错信息：
    # Clipping input data to the valid range for imshow with RGB data ([0..1] for floats or [0..255] for integers).
    # Traceback (most recent call last):
    # File "d:/.../SDPNet-for-pansharpening/show.py", line 23, in <module>
    #     plt.imsave(output_path, output_image_normalized, cmap='gray')
    # File "D:\Users\Lenovo\anaconda3\envs\sdpnet\lib\site-packages\matplotlib\pyplot.py", line 2163, in imsave
    #     return matplotlib.image.imsave(fname, arr, **kwargs)
    # File "D:\Users\Lenovo\anaconda3\envs\sdpnet\lib\site-packages\matplotlib\image.py", line 1646, in imsave
    #     "RGBA", pil_shape, rgba, "raw", "RGBA", 0, 1)
    # File "D:\Users\Lenovo\anaconda3\envs\sdpnet\lib\site-packages\PIL\Image.py", line 3020, in frombuffer
    #     im = im._new(core.map_buffer(data, size, decoder_name, 0, args))
    # ValueError: ndarray is not C-contiguous

    # 解决方法：
    # 错误提示指出 output_image_normalized 不是“C-contiguous”数组，因此 plt.imsave 无法直接处理它。可以通过调用 np.ascontiguousarray 将数组转换为连续的内存布局来解决这个问题。
    # """

    # 设置 Alpha 通道为完全不透明，不然输出的 .tiff .tif .png 图像会受到背景影响
    alpha_channel = np.ones_like(output_image_contiguous)  # 创建一个与图像大小相同的 Alpha 通道，值为 1 表示完全不透明
    rgba_image = np.dstack((output_image_contiguous, output_image_contiguous, output_image_contiguous, alpha_channel))  # 合并成 RGBA 图像

    # # 遍历需要保存的格式并保存图像
    # for fmt in save_formats:
    #     output_path = f'results/{img_file_name}/output_{img_file_name}.{fmt}'
    #     try:
    #         if fmt.lower() == 'jpg':  # 判断是否为 JPG 格式
    #             # 将图像转换为 RGB 模式，去掉 alpha 通道
    #             img_rgb = Image.fromarray((output_image_contiguous * 255).astype(np.uint8)).convert('RGB')
    #             img_rgb.save(output_path, format='JPEG')
    #             print(f"\n图像已保存为 JPG 格式，路径: {output_path}")
    #         elif fmt.lower() in ['tiff', 'tif']:  # 对于 TIFF 格式
    #             # 保存为 TIFF 格式时, 使用 RGBA 图像格式
    #             img_rgba = Image.fromarray((rgba_image * 255).astype(np.uint8))  # 转换为 8-bit per channel
    #             img_rgba.save(output_path, format='TIFF')
    #             print(f"\n图像已保存为 TIFF 格式，路径: {output_path}")
    #         else:  # 对于其他格式 (png, bmp)
    #             # 对于 PNG 和 BMP，使用 RGBA 图像
    #             img_rgba = Image.fromarray((rgba_image * 255).astype(np.uint8))  # 转换为 8-bit per channel
    #             img_rgba.save(output_path, format=fmt.upper())
    #             print(f"\n图像已保存为 {fmt.upper()} 格式，路径: {output_path}")
    #     except Exception as e:
    #         print(f"保存为 {fmt.upper()} 格式时发生错误: {e}")


    # """
    # 报错信息：
    # Clipping input data to the valid range for imshow with RGB data ([0..1] for floats or [0..255] for integers).
    # Traceback (most recent call last):
    # File "d:/杨丹阳/大学/大二上/大二上 数字图像处理/2024 李彦胜老师 数图大作业/SDPNet-for-pansharpening/show.py", line 26, in <module>
    # plt.imsave(output_path, output_image_contiguous, cmap='gray')
    #  File "D:\Users\Lenovo\anaconda3\envs\sdpnet\lib\site-packages\matplotlib\pyplot.py", line 2163, in imsave
    # return matplotlib.image.imsave(fname, arr, **kwargs)
    # File "D:\Users\Lenovo\anaconda3\envs\sdpnet\lib\site-packages\matplotlib\image.py", line 1675, in imsave
    # image.save(fname, **pil_kwargs)
    # File "D:\Users\Lenovo\anaconda3\envs\sdpnet\lib\site-packages\PIL\Image.py", line 2419, in save
    # save_handler = SAVE[format.upper()]
    # KeyError: 'TIF'

    # 解决方法：
    # PIL（Python Imaging Library）未能识别 tif 格式。tif 格式在 PIL 中通常是表示为 TIFF，因此需要在调用相关函数时指定格式为 'TIFF'。
    # """

    # 保存为 BMP 和 JPG 格式
    for fmt in save_formats:
        output_path = f'results/{img_file_name}/output_{img_file_name}.{fmt}'
        try:
            if fmt.lower() == 'jpg':  # 判断是否为 JPG 格式
                # 将图像转换为 RGB 模式，去掉 alpha 通道
                img_rgb = Image.fromarray((output_image_contiguous * 255).astype(np.uint8)).convert('RGB')
                img_rgb.save(output_path, format='JPEG')
                print(f"\n图像已保存为 JPG 格式，路径: {output_path}")
            elif fmt.lower() == 'bmp':  # 对于 BMP 格式
                img_rgb = Image.fromarray((rgba_image * 255).astype(np.uint8))  # 转换为 8-bit per channel
                img_rgb.save(output_path, format='BMP')
                print(f"\n图像已保存为 BMP 格式，路径: {output_path}")
        except Exception as e:
            print(f"保存为 {fmt.upper()} 格式时发生错误: {e}")

             # 转换 BMP 和 JPG 到 TIFF 和 TIF 格式
    for fmt in ['tiff', 'png']:
        for original_format in ['bmp', 'jpg']:
            original_path = f'results/{img_file_name}/output_{img_file_name}.{original_format}'
            converted_path = f'results/{img_file_name}/output_{img_file_name}.{fmt}'
            try:
                # 打开原始 BMP 或 JPG 文件
                img = Image.open(original_path)
                # 保存为 TIFF 或 PNG 格式
                img.save(converted_path, format=fmt.upper())
                print(f"\n图像已保存为 {fmt.upper()} 格式，路径: {converted_path}")
            except Exception as e:
                print(f"保存为 {fmt.upper()} 格式时发生错误: {e}")

            # 强制将 .tiff 文件另存为 .tif 格式，以强行解决alpha通道问题
            tiff_file_path = f'results/{img_file_name}/output_{img_file_name}.tiff'
            tif_file_path = f'results/{img_file_name}/output_{img_file_name}.tif'

            try:
                # 打开 .tiff 文件
                img_tiff = Image.open(tiff_file_path)
                # 保存为 .tif 格式，实际上这两者是一样的，只是文件扩展名不同
                img_tiff.save(tif_file_path, format='TIFF')
                print(f"\n图像已保存为 TIF 格式，路径: {tif_file_path}")
            except Exception as e:
                print(f"保存为 TIF 格式时发生错误: {e}")

                 # 使用 Tkinter 显示保存的 .tiff 图像
    display_image_in_popup(f'results/{img_file_name}/output_{img_file_name}.tiff')


def display_image_in_popup(image_path):
    """显示图像文件在弹窗中"""
    # 创建 Tkinter 窗口
    root = tk.Tk()
    root.title("融合后图像显示")  # 设置窗口标题

    # 打开图像
    img = Image.open(image_path)
    img = ImageTk.PhotoImage(img)

    # 创建标签并将图像放入标签中
    label = tk.Label(root, image=img)
    label.pack()

    # 创建一个按钮，点击时关闭窗口
    button = tk.Button(root, text="关闭", command=root.quit)
    button.pack()

    # 启动 Tkinter 主循环
    root.mainloop()

# 如果直接运行 show.py，可以测试该功能
if __name__ == '__main__':
    process_and_show_image() # 这里调用时不需要传递 save_formats 参数，因为它有默认值
