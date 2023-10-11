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
WORKDIR /workspace
SHELL ["/bin/bash", "-c"]
# Init conda env
ARG CODE_PATH
RUN echo -e \
  "set -o vi \n" \
  "export PS1='\W $ '" \
  >> ~/.bashrc \
  conda init bash

COPY ./entrypoint.sh .
ENTRYPOINT [ "./entrypoint.sh" ]
