#! /bin/bash
# fix problem with a version high enough https://github.com/open-mmlab/mmdetection/issues/11020
# but low enough for not having depreciation warning
pip install --no-cache-dir setuptools==67.2.0 
python -m mim install -e ${CONTAINER_CODE_PSTR}

if [ $# -gt 0 ]; then
	exec "$@"
else
	exec bash
fi
