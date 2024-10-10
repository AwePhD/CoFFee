#! /bin/bash
# fix problem with a version high enough https://github.com/open-mmlab/mmdetection/issues/11020
# but low enough for not having depreciation warning
pip install --no-cache-dir setuptools==67.2.0 
pip install --user -e $HOME/code/td
python -c "import nltk;nltk.download('punkt')"
python -c "import nltk;nltk.download('averaged_perceptron_tagger')"
sleep infinity
