#! /bin/bash
echo "export PS1=\"${CONTAINER_PS1}\"" >> ~/.bashrc
pip install -e .
sleep infinity
