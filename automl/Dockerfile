# ---------------------------------------------------------------
# ------------------------ ALL NOT NASLIB -----------------------
# ---------------------------------------------------------------
ARG PYTORCH_VERSION
ARG CUDA_VERSION
ARG CUDNN_VERSION
FROM pytorch/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION}-cudnn${CUDNN_VERSION}-runtime as base

ENV DEBIAN_FRONTEND=noninteractive

# Install the required packages
RUN apt-get update \
    && apt-get install -y ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Requirements text file does not pass
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir smac
RUN pip install --no-cache-dir swig
RUN pip install --no-cache-dir autogluon
RUN pip install --no-cache-dir py-experimenter
RUN pip install --no-cache-dir hydra-core
RUN pip install --no-cache-dir git+https://github.com/lava-nc/lava
RUN pip install --no-cache-dir git+https://github.com/automl/TabPFN
RUN pip install --no-cache-dir amltk
RUN pip install --no-cache-dir amltk[notebook]
RUN pip install --no-cache-dir amltk[sklearn]
RUN pip install --no-cache-dir amltk[smac]

FROM base as dev
ARG UID
ARG GID
ARG USERNAME
RUN addgroup --quiet --gid ${GID} ${USERNAME} && \
    adduser --quiet --uid ${UID} --gid ${GID} ${USERNAME}

ENV HOME=/home/${USERNAME}
USER ${USERNAME}

ARG CONTAINER_TORCH_CACHE_PATH
ARG CONTAINER_VSCODE_PATH
ARG CONTAINER_WORKSPACE_PATH
RUN mkdir -p ${CONTAINER_TORCH_CACHE_PATH} ${CONTAINER_VSCODE_PATH} ${CONTAINER_WORKSPACE_PATH}

RUN echo "export PS1='(autoML) [\u \W]$ '" >> ~/.bashrc \
 && echo "export PATH='$PATH:${HOME}/.local/bin'" >> ~/.bashrc 

ARG CONTAINER_CODE_PATH
WORKDIR ${CONTAINER_CODE_PATH}
COPY ./dev.requirements.txt ./requirements.txt
ENV PIP_ARGS="--user --no-cache-dir"
RUN pip install ${PIP_ARGS} -r requirements.txt && rm requirements.txt

# ---------------------------------------------------------------
# ---------------------------- NASLIB ---------------------------
# ---------------------------------------------------------------
FROM pytorch/pytorch:1.12.1-cuda11.3-cudnn8-runtime as base_nas

ENV DEBIAN_FRONTEND=noninteractive

# Install the required packages
RUN apt-get update \
    && apt-get install -y ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip setuptools wheel

FROM base_nas as dev_nas
ARG UID
ARG GID
ARG USERNAME
RUN addgroup --quiet --gid ${GID} ${USERNAME} && \
    adduser --quiet --uid ${UID} --gid ${GID} ${USERNAME}

ENV HOME=/home/${USERNAME}
USER ${USERNAME}

ARG CONTAINER_TORCH_CACHE_PATH
ARG CONTAINER_VSCODE_PATH
ARG CONTAINER_WORKSPACE_PATH
RUN mkdir -p ${CONTAINER_TORCH_CACHE_PATH} ${CONTAINER_VSCODE_PATH} ${CONTAINER_WORKSPACE_PATH}

RUN echo "export PS1='(NASlib) [\u \W]$ '" >> ~/.bashrc \
 && echo "export PATH='$PATH:${HOME}/.local/bin'" >> ~/.bashrc 

ARG CONTAINER_CODE_PATH
WORKDIR ${CONTAINER_CODE_PATH}
COPY ./dev.requirements.txt ./requirements.txt
ENV PIP_ARGS="--user --no-cache-dir"
RUN pip install ${PIP_ARGS} -r requirements.txt && rm requirements.txt

RUN git clone https://github.com/automl/NASLib \
	&& cd NASLib \
	&& pip install -e .

