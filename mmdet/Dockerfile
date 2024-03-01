# ---------------------------------------------------------------
# ---------------------- BUILD MMDET/MMCV ----------------------
# ---------------------------------------------------------------
# Based on mmdet official Dockerfile
ARG PYTORCH_VERSION
ARG CUDA_VERSION
ARG CUDNN_VERSION
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel as builder
ARG MMENGINE_VERSION_MAJOR 
ARG MMENGINE_VERSION_MINOR 
ARG MMENGINE_VERSION_PATCH 
ARG MMCV_VERSION_MAJOR 
ARG MMCV_VERSION_MINOR 
ARG MMCV_VERSION_PATCH 
ARG MIM_VERSION_MAJOR 
ARG MIM_VERSION_MINOR 
ARG MIM_VERSION_PATCH 

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    FORCE_CUDA="1" \
		DEBIAN_FRONTEND=noninteractive

# Avoid Public GPG key error
# https://github.com/NVIDIA/nvidia-docker/issues/163
# || true is added in case there is no cuda.list, depends of the version of the base image1
RUN rm /etc/apt/sources.list.d/cuda.list || true \  
    && apt-key del 7fa2af80 \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

# Install the required packages
RUN apt-get update \
    && apt-get install -y ffmpeg git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install MMEngine and MMCV
RUN pip install --no-cache-dir openmim==${MIM_VERSION_MAJOR}.${MIM_VERSION_MINOR}.${MIM_VERSION_PATCH} && \
    mim install --no-cache-dir \
		"mmengine==${MMENGINE_VERSION_MAJOR}.${MMENGINE_VERSION_MINOR}.${MMENGINE_VERSION_PATCH}" \
		"mmcv==${MMCV_VERSION_MAJOR}.${MMCV_VERSION_MINOR}.${MMCV_VERSION_PATCH}"

# ------------------- (END) BUILD MMDET/MMCV --------------------

# ---------------------------------------------------------------
# --------------------- BUILD ENVIRONNEMENT --------------------- 
# ---------------------------------------------------------------
FROM builder AS base_devel

RUN apt-get update && apt-get install -y vim \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* 
RUN pip install --no-cache-dir --upgrade pip mmpretrain

RUN git clone https://github.com/open-mmlab/mmdetection.git /mmdetection 
WORKDIR /mmdetection
# ------------------ (END) BUILD ENVIRONNEMENT ------------------

# Use of more lightweight image for development as CUDA compilation should not be necessary
ARG PYTORCH_VERSION
ARG CUDA_VERSION
ARG CUDNN_VERSION
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-runtime AS base_runtime
ARG MMENGINE_VERSION_MAJOR 
ARG MMENGINE_VERSION_MINOR 
ARG MMENGINE_VERSION_PATCH 
ARG MMCV_VERSION_MAJOR 
ARG MMCV_VERSION_MINOR 
ARG MMCV_VERSION_PATCH 
ARG MIM_VERSION_MAJOR 
ARG MIM_VERSION_MINOR 
ARG MIM_VERSION_PATCH 

ENV SITE_PACKAGES="/opt/conda/lib/python3.10/site-packages"
COPY --from=builder ${SITE_PACKAGES}/mmcv ${SITE_PACKAGES}/mmcv
COPY --from=builder ${SITE_PACKAGES}/mim ${SITE_PACKAGES}/mim
COPY --from=builder ${SITE_PACKAGES}/mmengine ${SITE_PACKAGES}/mmengine
COPY --from=builder  \ 
	${SITE_PACKAGES}/mmcv-${MMCV_VERSION_MAJOR}.${MMCV_VERSION_MINOR}.${MMCV_VERSION_PATCH}.dist-info \
	${SITE_PACKAGES}/mmcv-${MMCV_VERSION_MAJOR}.${MMCV_VERSION_MINOR}.${MMCV_VERSION_PATCH}.dist-info 
COPY --from=builder \ 
	${SITE_PACKAGES}/mmengine-${MMENGINE_VERSION_MAJOR}.${MMENGINE_VERSION_MINOR}.${MMENGINE_VERSION_PATCH}.dist-info \
	${SITE_PACKAGES}/mmengine-${MMENGINE_VERSION_MAJOR}.${MMENGINE_VERSION_MINOR}.${MMENGINE_VERSION_PATCH}.dist-info
COPY --from=builder \
	${SITE_PACKAGES}/openmim-${MIM_VERSION_MAJOR}.${MIM_VERSION_MINOR}.${MIM_VERSION_PATCH}.dist-info \
	${SITE_PACKAGES}/openmim-${MIM_VERSION_MAJOR}.${MIM_VERSION_MINOR}.${MIM_VERSION_PATCH}.dist-info

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y vim ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* 
RUN pip install --no-cache-dir --upgrade pip mmpretrain
RUN pip install --no-cache-dir --upgrade --upgrade-strategy only-if-needed mmcv mmengine openmim
# ------------------ (END) BUILD ENVIRONNEMENT ------------------

# ---------------------------------------------------------------
# ---------------------- DEV ENVIRONNEMENT ----------------------
# ---------------------------------------------------------------
FROM base_runtime as dev
ARG USERNAME
ARG UID
ARG GID
ARG CONTAINER_TORCH_CACHE_PATH
ARG CONTAINER_VSCODE_PATH
ARG CONTAINER_CODE_PATH
ARG CONTAINER_HOME_PATH

RUN addgroup --quiet --gid ${GID} ${USERNAME} && \
    adduser --quiet --uid ${UID} --gid ${GID} ${USERNAME}

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
RUN cat .bashrc_addition >> .bashrc  && \
	rm ./.bashrc_addition 
COPY ./.inputrc .

WORKDIR ${CONTAINER_CODE_PATH}
# ------------------- (END) DEV ENVIRONNEMENT --------------------

# ---------------------------------------------------------------
# --------------------- TRAIN ENVIRONNEMENT ---------------------
# ---------------------------------------------------------------
FROM base_runtime as train
ARG HOST_MMDET_REPO_PATH
COPY ${HOST_MMDET_REPO_PATH} .

RUN pip install --no-cache-dir --upgrade setuptools \
 && pip install --no-cache-dir -e .

# ------------------ (END) TRAIN ENVIRONNEMENT ------------------
