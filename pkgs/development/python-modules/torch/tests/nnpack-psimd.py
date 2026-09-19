#!/usr/bin/env python3
"""Compile actual pinned NNPACK sources, without building Torch or NNPACK.

--source-root is Torch's third_party directory (or a copy containing
NNPACK/src, NNPACK/include and psimd/include). --cc may be repeated.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import platform
import subprocess
import time

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--source-root", required=True, type=Path)
parser.add_argument("--output", required=True, type=Path)
parser.add_argument("--cc", required=True, action="append")
parser.add_argument("--check-input-pointers", action="store_true",
                    help="also reject unused high-half pointers outside partial inputs")
parser.add_argument("--no-sanitizers", action="store_true",
                    help="run only the optimized variant")
args = parser.parse_args()
args.output.mkdir(parents=True, exist_ok=True)
harness = Path(__file__).with_suffix(".c").resolve()
guard_header = harness.with_name("nnpack-input-pointers.h")
if args.check_input_pointers:
    guard = args.output / "include/psimd/fft/real.h"
    guard.parent.mkdir(parents=True, exist_ok=True)
    guard.write_text('#include ' + json.dumps(str(guard_header)) + '\n')
sources = [args.source_root / f"NNPACK/src/psimd/2d-fourier-{n}x{n}.c" for n in (8, 16)]
files = [harness, guard_header, *sources]
files += sorted((args.source_root / "NNPACK/src/psimd").rglob("*.h"))
files += sorted((args.source_root / "NNPACK/include/nnpack").glob("*.h"))
files += sorted((args.source_root / "psimd/include").glob("*.h"))
evidence = {
    "machine": platform.machine(),
    "source_root": str(args.source_root),
    "sha256": {str(p): hashlib.sha256(p.read_bytes()).hexdigest() for p in files},
    "runs": [],
}
environment = dict(os.environ, LC_ALL="C", ASAN_OPTIONS="detect_leaks=1:halt_on_error=1",
                   UBSAN_OPTIONS="halt_on_error=1:print_stacktrace=1")
for index, cc in enumerate(args.cc):
    for variant, flags in (("optimized", ["-O3"]),
                           ("sanitized", ["-O2", "-fsanitize=address,undefined",
                                          "-fno-omit-frame-pointer"])):
        if variant == "sanitized" and args.no_sanitizers:
            continue
        stem = f"{index}-{Path(cc).name}-{variant}"
        executable = args.output / stem
        command = [cc, "-std=c11", *flags, "-Wall", "-Wextra", "-DNNP_INFERENCE_ONLY=0"]
        if args.check_input_pointers:
            command += ["-I" + str(args.output / "include"),
                        "-DNNPACK_REAL_HEADER=" + json.dumps(str(
                            (args.source_root / "NNPACK/src/psimd/fft/real.h").resolve()))]
        command += ["-I" + str(args.source_root / subdir) for subdir in
                    ("psimd/include", "NNPACK/include", "NNPACK/src")]
        command += [str(harness), *map(str, sources), "-lm", "-o", str(executable)]
        start = time.monotonic()
        compiled = subprocess.run(command, env=environment, text=True, capture_output=True)
        log = compiled.stdout + compiled.stderr
        (args.output / f"{stem}-compile.log").write_text(log)
        result = {"command": command, "compile_status": compiled.returncode,
                  "compile_seconds": time.monotonic() - start,
                  "stringop_overflow_diagnostics": log.count("[-Wstringop-overflow="),
                  "compiler": subprocess.check_output([cc, "--version"], text=True).splitlines()[0]}
        if compiled.returncode == 0:
            start = time.monotonic()
            executed = subprocess.run([str(executable)], env=environment, text=True, capture_output=True)
            (args.output / f"{stem}-run.log").write_text(executed.stdout + executed.stderr)
            result.update(run_status=executed.returncode, run_seconds=time.monotonic()-start,
                          stderr=executed.stderr)
            if executed.returncode == 0:
                result["numerics"] = json.loads(executed.stdout)
        evidence["runs"].append(result)
        (args.output / "results.json").write_text(json.dumps(evidence, indent=2) + "\n")
        print(json.dumps(result), flush=True)
        if compiled.returncode or result.get("run_status"):
            raise SystemExit(1)
