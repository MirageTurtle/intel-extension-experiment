#!/usr/bin/env bash

# assert conda is installed
if ! command -v conda &> /dev/null; then
	echo "conda could not be found"
	exit 1
fi

workdir=/mnt/workspace

# Check if the conda environment itrex already exists
if ! conda env list | grep -q 'itrex'; then
    echo "[*] Creating the conda environment itrex"
    # Create the conda environment itrex
    mkdir -p /opt/conda/envs/itrex
    # Check if the itrex.tar.gz file already exists and is not empty
    if [ ! -f "$workdir/itrex.tar.gz" ] || [ -s "$workdir/itrex.tar.gz" ]; then
        # Download the file itrex.tar.gz
        wget -q --show-progress -O $workdir/itrex.tar.gz https://idz-ai.oss-cn-hangzhou.aliyuncs.com/LLM/itrex.tar.gz
    fi
    tar -xzf $workdir/itrex.tar.gz -C /opt/conda/envs/itrex
fi
echo "[+] The conda environment itrex is ready"

# Activate the conda environment
# NOTE: can't use `conda activate` in a script
source /opt/conda/bin/activate itrex

# Check if the ipykernel is already installed
# if ! jupyter kernelspec list | grep -q 'itrex'; then
#     echo "[*] Installing the ipykernel"
#     # Install the ipykernel
#     python -m ipykernel install --name itrex
# fi
# python -m ipykernel install --name itrex
# echo "[+] The ipykernel is ready"

# Check if the chatglm3-6b and bge-base-zh-v1.5 repositories already exist

if [ ! -d "$workdir/chatglm3-6b" ]; then
    echo "[*] Cloning the git repository chatglm3-6b"
    # Clone the git repository
    git clone https://www.modelscope.cn/ZhipuAI/chatglm3-6b.git $workdir/chatglm3-6b
fi
if [ ! -d "$workdir/bge-base-zh-v1.5" ]; then
    echo "[*] Cloning the git repository bge-base-zh-v1.5"
    # Clone the git repository
    git clone https://www.modelscope.cn/AI-ModelScope/bge-base-zh-v1.5.git $workdir/bge-base-zh-v1.5
fi
echo "[+] The model-related git repositories are ready"

# Knowledge base files
# if [ ! -f $workdir/history_24.tar.gz ] || [ ! -s $workdir/history_24.tar.gz ]; then
#     # Download the file history_24.tar.gz for data file url
#     echo "[*] Downloading the knowledge base files..."
#     wget -q --show-progress -O $workdir/history_24.tar.gz https://alist.mirageturtle.top:5244/d/Share/history_24.tar.gz
# fi
if [ ! -d $workdir/history_24 ]; then
    mkdir -p $workdir/history_24
    # tar -xzf $workdir/history_24.tar.gz -C $workdir/
fi
if [ ! -f $workdir/history_24/baihuasanguozhi.txt ] || [ ! -s $workdir/history_24/baihuasanguozhi.txt ]; then
    # Download the file baihuasanguozhi.txt for data file url
    echo "[*] Downloading the knowledge base file(s)..."
    wget -q --show-progress -O $workdir/history_24/baihuasanguozhi.txt https://alist.mirageturtle.top:5244/d/Share/baihuasanguozhi.txt
fi
echo "[+] The knowledge base file(s) are ready"
