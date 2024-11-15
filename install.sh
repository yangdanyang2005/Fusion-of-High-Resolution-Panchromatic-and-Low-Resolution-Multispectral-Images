#!/bin/bash

# -----------------------------------------------------------------------------
# This script was created by Yang Danyang.
# Copyright © 2024 Yang Danyang. All rights reserved.
# -----------------------------------------------------------------------------

# Create a new Conda environment named 'sdpnet' with Python 3.7
conda create -n sdpnet python=3.7 -y

# Activate the new environment
source activate sdpnet

# Install required packages
pip install tensorflow-gpu==1.15 matplotlib imageio scikit-image scipy opencv-python protobuf==3.20.0 tqdm

# Print completion message
echo "Done!"
