# ---------------------------------------------------------------
# ---------------------- BUILD MMDET/MMCV ----------------------
# ---------------------------------------------------------------
# Based on mmdet official Dockerfile
ARG PYTORCH_VERSION
ARG CUDA_VERSION
ARG CUDNN_VERSION
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel AS builder
ARG MMENGINE_VERSION 
ARG MMCV_VERSION 
ARG MIM_VERSION 

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    FORCE_CUDA="1" \
		DEBIAN_FRONTEND=noninteractive

# Avoid Public GPG key error
# https://github.com/NVIDIA/nvidia-docker/issues/163
# || true is added in case there is no cuda.list, depends of the version of the base image1
RUN <<EOT
  rm /etc/apt/sources.list.d/cuda.list || true
  apt-key del 7fa2af80
  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
EOT

# Install the required packages
RUN <<EOT
	apt-get update
  apt-get install -y ffmpeg git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6
  apt-get clean
  rm -rf /var/lib/apt/lists/*
EOT

# Install MMEngine and MMCV
RUN <<EOT
	pip install --no-cache-dir openmim==${MIM_VERSION}
  mim install --no-cache-dir "mmengine==${MMENGINE_VERSION}" "mmcv==${MMCV_VERSION}"
EOT

# ------------------- (END) BUILD MMDET/MMCV --------------------

# ---------------------------------------------------------------
# --------------------- BUILD ENVIRONNEMENT --------------------- 
# ---------------------------------------------------------------
FROM builder AS base_devel

RUN <<EOT
	apt-get update && apt-get install -y vim
 apt-get clean
 rm -rf /var/lib/apt/lists/* 
EOT
RUN pip install --no-cache-dir --upgrade pip mmpretrain

# ------------------ (END) BUILD ENVIRONNEMENT ------------------

# Use of more lightweight image for development as CUDA compilation should not be necessary
ARG PYTORCH_VERSION
ARG CUDA_VERSION
ARG CUDNN_VERSION
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-runtime AS base_runtime
ARG MMENGINE_VERSION 
ARG MMCV_VERSION
ARG MIM_VERSION

ENV SITE_PACKAGES="/opt/conda/lib/python3.11/site-packages"
COPY --from=builder ${SITE_PACKAGES}/mmcv ${SITE_PACKAGES}/mmcv
COPY --from=builder ${SITE_PACKAGES}/mim ${SITE_PACKAGES}/mim
COPY --from=builder ${SITE_PACKAGES}/mmengine ${SITE_PACKAGES}/mmengine
COPY --from=builder  \ 
	${SITE_PACKAGES}/mmcv-${MMCV_VERSION}.dist-info ${SITE_PACKAGES}/mmcv-${MMCV_VERSION}.dist-info
COPY --from=builder \ 
	${SITE_PACKAGES}/mmengine-${MMENGINE_VERSION}.dist-info ${SITE_PACKAGES}/mmengine-${MMENGINE_VERSION}.dist-info 
COPY --from=builder \
	${SITE_PACKAGES}/openmim-${MIM_VERSION}.dist-info ${SITE_PACKAGES}/openmim-${MIM_VERSION}.dist-info 

ENV DEBIAN_FRONTEND=noninteractive
RUN <<EOT
	apt-get update 
	apt-get install -y vim ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0
  apt-get clean
  rm -rf /var/lib/apt/lists/* 
EOT

RUN pip install --no-cache-dir --upgrade pip

COPY base.requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt
# RUN pip install --no-cache-dir --upgrade --upgrade-strategy only-if-needed mmcv mmengine openmim
# ------------------ (END) BUILD ENVIRONNEMENT ------------------

# ---------------------------------------------------------------
# ---------------------- DEV ENVIRONNEMENT ----------------------
# ---------------------------------------------------------------
FROM base_runtime AS dev
ARG USERNAME
ARG UID
ARG GID
ARG CONTAINER_TORCH_CACHE_PATH
ARG CONTAINER_VSCODE_PATH
ARG CONTAINER_CODE_PATH
ARG CONTAINER_HOME_PATH

RUN <<EOT
	addgroup --quiet --gid ${GID} ${USERNAME}
  adduser --quiet --uid ${UID} --gid ${GID} ${USERNAME}
EOT

RUN su - ${USERNAME} -c '/opt/conda/bin/conda init bash'

ENV HOME=/home/${USERNAME}
USER ${USERNAME}

RUN mkdir -p ${CONTAINER_TORCH_CACHE_PATH} ${CONTAINER_VSCODE_PATH}

WORKDIR ${CONTAINER_CODE_PATH}
ENV PIP_ARGS="--user --no-cache-dir"
RUN pip install --upgrade pip
RUN pip install ${PIP_ARGS} --upgrade typing_extensions

COPY ./dev.requirements.txt ./requirements.txt
RUN pip install ${PIP_ARGS} -r requirements.txt && rm requirements.txt

WORKDIR ${CONTAINER_HOME_PATH}
COPY ./.bashrc ./.bashrc_addition
RUN <<EOT
	cat .bashrc_addition >> .bashrc
	rm ./.bashrc_addition 
EOT
COPY ./.inputrc .

WORKDIR ${CONTAINER_CODE_PATH}
# ------------------- (END) DEV ENVIRONNEMENT --------------------

