# CoFFee - Compose Files & Fast environment Establishment

This repo is the small and simple configurations for my compose files for my development containers. They are mostly used to develop Vision and Language task in Deep Learning. There are two additional coments.

1. I do not include the .env files. There is one `.env` files at the root of the repo with the variables used in multiple environment. And each env folder has its own `.env` variable which is specific to the environment.
2. I added a `command_line.sh` script. It includes a `dc` command and a `dcb` for ease. Basically it avoids to call the long line of docker compose including the `.env` file in the root folder. `dc <env_name> <rest of the usual docker compose>` and `dcb <env_name> <service_name>` to run bash, `<env_name>` is the name of a folder. There is a completion function. 

I try to keep the configurations modular with multi-stage building on Dockerfile so it's easy to tune for similar usage. Also I try to reduce complexity with the common `.env` file, a "sort of" standardization, if you will.
