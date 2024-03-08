#! /bin/bash
echo "export PS1=\"${CONTAINER_PS1}\"" >> ~/.bashrc

pip install --no-cache-dir --upgrade setuptools
pip install --no-cache-dir -e pstr
sleep infinity

