FROM cuhk_sysu_pedes_codebase-dev:latest

# Import variables from .env file
ARG UID
ARG GID
ARG USERNAME

# Add host user to the container
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
ENV PATH="${PATH}:~/.local/bin"

RUN pip install --no-cache-dir --user pyyaml

