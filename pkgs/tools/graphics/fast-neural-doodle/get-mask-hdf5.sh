#! @bash@/bin/bash

export PYTHONPATH="@pythonpath@"

@python@/bin/python "@out@/lib/@python_libPrefix@/fast_neural_doodle/get_mask_hdf5.py" "$@"
