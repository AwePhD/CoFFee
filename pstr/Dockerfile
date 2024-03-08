# ---------------------- BUILD MMDET/MMCV ----------------------
# Build the mmdet / PSTR python package with CUDA compiler
ARG PYTORCH_VERSION
ARG CUDA_VERSION
ARG CUDNN_VERSION
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel as build

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys A4B469963BF863CC
RUN apt-get update && \
    apt-get install -y gcc vim ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libxrender-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /opt/conda/bin/conda /bin/conda 

ENV FORCE_CUDA="1"
ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0+PTX"
ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"
ENV CMAKE_PREFIX_PATH="$(dirname $(which conda))/../"
RUN git clone https://github.com/JialeCao001/PSTR.git . \
	&& cd mmcv \
	&& MMCV_WITH_OPS=1 pip install -e . \
	&& cd .. \
	&& pip install -r requirements/build.txt \
	&& MMCV_WITH_OPS=1 pip install -v -e . \
	&& pip install scikit-learn

COPY ./base.requirements.txt ./requirements.txt
RUN pip install -r requirements.txt 

# ---------------------- TRAINING STAGE ----------------------
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-runtime as base

ENV SITE_PACKAGES_DIR="/opt/conda/lib/python3.8/site-packages"
COPY --from=build ${SITE_PACKAGES_DIR}/mmcv-full.egg-link ${SITE_PACKAGES_DIR}/mmcv-full.egg-link
COPY --from=build ${SITE_PACKAGES_DIR}/mmdet.egg-link ${SITE_PACKAGES_DIR}/mmdet-full.egg-link
COPY --from=build /workspace /workspace 

RUN apt-get update && \
    apt-get install -y gcc vim ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libxrender-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /opt/conda/bin/conda /bin/conda 

RUN pip install --no-cache-dir -r requirements/build.txt

COPY ./base.requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

COPY ./adamw.py /opt/conda/lib/python3.8/site-packages/torch/optim/adamw.py

# ---------------------- TRAINING STAGE ----------------------
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-runtime as train

RUN mv mmcv .mmcv && cp -r .mmcv/mmcv . && cp tools/train.py .

# ---------------------- DEVELOPMENT DEPENDENCIES ----------------------
FROM base as dev
ARG USERNAME
ARG UID
ARG GID
ARG CONTAINER_TORCH_CACHE_PATH
ARG CONTAINER_VSCODE_PATH

RUN addgroup --quiet --gid ${GID} ${USERNAME} && \
    adduser --quiet --uid ${UID} --gid ${GID} ${USERNAME}

RUN su - ${USERNAME} -c '/opt/conda/bin/conda init bash'

RUN chown -R ${USERNAME}:${USERNAME} /workspace

ENV HOME=/home/${USERNAME}
USER ${USERNAME}

RUN mkdir -p ${CONTAINER_TORCH_CACHE_PATH} ${CONTAINER_VSCODE_PATH}

RUN pip install --no-cache-dir -e mmcv
RUN pip install --no-cache-dir -e .
