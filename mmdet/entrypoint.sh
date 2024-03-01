#! /bin/bash
pip install --no-cache-dir --upgrade setuptools
pip install --no-cache-dir -e mmdet
pip install --no-cache-dir -r HolisticTraceAnalysis/requirements-dev.txt
pip install --no-cache-dir -e HolisticTraceAnalysis
sleep infinity
