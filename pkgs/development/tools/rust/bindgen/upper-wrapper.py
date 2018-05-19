#!/usr/bin/env python3
import sys
import os
import json

dummy_args = ["dummy_input_file.c", "-c", "-o", "dummy_output_file.o"]
argv = sys.argv[1:]
if "--" not in argv:
    argv.append("--")
argv += dummy_args
split = argv.index("--")
bindgen_args = argv[:split]
os.environ["BINDGEN_ARGS"] = json.dumps(bindgen_args)
clang_args = argv[split+1:]

os.execv("@clang@", ["clang"] + clang_args)
