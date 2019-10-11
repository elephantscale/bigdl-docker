#!/bin/bash
set -e

# activate py36 environment
source activate py36
conda info -e

/usr/local/bin/start.sh  ~/run-jupyter-with-zoo.sh

# And run bash shell, so the container doesn't exit when Jupyter exits
# This way we can re-run ./run-bigdl.sh if needed to
/bin/bash
