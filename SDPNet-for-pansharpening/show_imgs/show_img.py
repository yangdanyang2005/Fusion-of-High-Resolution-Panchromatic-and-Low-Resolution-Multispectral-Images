import os
from PIL import Image

# 设置输入和输出文件夹路径
input_folder = 'test_imgs\\pan'
output_folder = 'show_imgs\\pan'

# 如果输出文件夹不存在，创建它
if not os.path.exists(output_folder):
    os.makedirs(output_folder)

# 遍历输入文件夹中的所有文件
for filename in os.listdir(input_folder):
    # 获取文件的完整路径
    input_path = os.path.join(input_folder, filename)
    
    # 检查文件是否是 .tiff 或 .tif 格式
    if filename.lower().endswith(('.tiff', '.tif')):
        # 打开图像文件
        with Image.open(input_path) as img:
            # 如果图像是 CMYK 模式，转换为 RGB 模式
            if img.mode == 'CMYK':
                img = img.convert('RGB')
                
            # 构造输出文件路径，替换扩展名为 .png
            output_path = os.path.join(output_folder, os.path.splitext(filename)[0] + '.png')
            
            # 将图像保存为 .png 格式
            img.save(output_path, 'PNG')

            print(f"Converted {filename} to {output_path}")
