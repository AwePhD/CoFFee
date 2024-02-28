FROM cuhk_sysu_pedes_codebase-dev:latest

RUN apt update && apt install -y vim git && apt clean && rm -rf /var/lib/apt/lists/* 

ARG UID
ARG GID
ARG USERNAME

RUN  addgroup \
  --quiet \
  --gid ${GID} \
  ${USERNAME} && \
  adduser \
  --quiet \
  --uid ${UID} \
  --gid ${GID} \
  ${USERNAME}

ARG CONTAINER_VSCODE_PATH
RUN mkdir /home/${USERNAME}/.vscode-server && \
  chown -R ${USERNAME}:${USERNAME} ${CONTAINER_VSCODE_PATH}

USER ${USERNAME}
ARG WORKDIR
WORKDIR ${WORKDIR}
ENV PATH="${PATH}:/home/${USERNAME}/.local/bin"
