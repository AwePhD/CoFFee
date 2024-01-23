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

RUN mkdir /home/${USERNAME}/.vscode-server && \
  chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.vscode-server

USER ${USERNAME}
ARG WORKDIR
WORKDIR ${WORKDIR}
RUN echo "export PATH='${PATH}:~/.local/bin'" >> ~/.bashrc
RUN pip install --no-cache-dir --user pyyaml

