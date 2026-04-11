# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.25.0" = {
    x86_64-linux-310 = {
      name = "torchvision-0.25.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.25.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-QzUMoRPp8iTe25Cw28MYU/3k8yJ5TL5KdYn8yrV2jww=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.25.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.25.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-6/K0lcdgl3lrmi6skpDvvK6W4P2eWuUsQO/xiGELtEA=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.25.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.25.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-ElWgyiv5h6z58QO5bFxM/jQV/Eoe7xf6CK9SegSk9XM=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.25.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.25.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-qcDeiT3OnCkTyceuiKkWkQ+S0CuZ2hSWeIBtGOgHnyk=";
    };
    x86_64-linux-314 = {
      name = "torchvision-0.25.0-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.25.0%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-W3rT+2zwPvKi/WF8tLTkHvqbsBQ8Z/UGwqPmdlx7Eq0=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.25.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.25.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-eBCEGRaiqHDL+1gfQIS1lHmQj7nbbt/feBOZMTkthnc=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.25.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.25.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-p2znuNT84pGiVyHuL5IceDrMbb1Pwy3HQe0qHVqN3i8=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.25.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.25.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-ck8hKlig0NdYZJziiGAQVrX0agHeVFcC9CvMxbJcsMw=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.25.0-cp313-cp313-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.25.0-cp313-cp313-macosx_12_0_arm64.whl";
      hash = "sha256-bERBGcavj6SLecWfFSn8FaRaK7+CPPhfhR5yA9hPcn8=";
    };
    aarch64-darwin-314 = {
      name = "torchvision-0.25.0-cp314-cp314-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.25.0-cp314-cp314-macosx_11_0_arm64.whl";
      hash = "sha256-pkrlQ/4KBXqTlUr5TCOWKXI9sZbtZQkOZ3XxNnJrIvg=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.25.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.25.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-c84E3qZJFP8REACDESBMNmEH1lHTsE+qDb7nfvtxM7c=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.25.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.25.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-Wb6Z0cRw70cLE0Roqmr6b5aAgaUDrLTuiD1wMy+CLjU=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.25.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.25.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-cnM06achz8GsKWzgv55p2UhoIb+lsedaj+tveAQdtIE=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.25.0-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.25.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-/lTL1ZQs0LJqkPF0jw1EIcr2e+NcKBxsO4VzczoD1jA=";
    };
    aarch64-linux-314 = {
      name = "torchvision-0.25.0-cp314-cp314-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.25.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-DC0NqbwBGg/eHRJa85ao++lNmb7PnTE3ZPJMp2V6NEg=";
    };
  };
}
