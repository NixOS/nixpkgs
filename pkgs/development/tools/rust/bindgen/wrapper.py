#!/usr/bin/env python3
import sys
import os
import json

# args we added in upper-wrapper.py and which must be removed
dummy_args = {"dummy_input_file.c", "-c", "-o", "dummy_output_file.o"}
# load args for bindgen
bindgen_args = json.loads(os.environ["BINDGEN_ARGS"])
# filter clang args
clang_args = [i for i in sys.argv[1:] if i not in dummy_args]

# exec bindgen
os.execv("@bindgen@",
         ["bindgen"] + bindgen_args +
         ["--"] +
         ["-isystem", "@internal_includes@"] +
         clang_args)
