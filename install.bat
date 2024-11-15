@echo off
REM -----------------------------------------------------------------------------
REM This script was created by Yang Danyang.
REM Copyright © 2024 Yang Danyang. All rights reserved.
REM -----------------------------------------------------------------------------

REM Create a new Conda environment named 'sdpnet' with Python 3.7
conda create -n sdpnet python=3.7 -y

REM Activate the new environment
call conda activate sdpnet

REM Install the required packages using pip
pip install tensorflow-gpu==1.15 matplotlib imageio scikit-image scipy opencv-python protobuf==3.20.0 tqdm

REM Print completion message
echo "Done!"

REM Pause to allow the user to see the completion message before closing
pause