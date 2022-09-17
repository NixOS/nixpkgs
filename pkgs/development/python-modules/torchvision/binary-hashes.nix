# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.13.1" = {
    x86_64-linux-37 = {
      name = "torchvision-0.13.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.13.1%2Bcu116-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-3PMvbZmEk+duwho4u7hWt0Ailc96Z/sJzlvefn5yV1Y=";
    };
    x86_64-linux-38 = {
      name = "torchvision-0.13.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.13.1%2Bcu116-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-w86ys/RW8MmEr3HvVfhjfxeKKdw+E6ZvuwEM7q0okeE=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.13.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.13.1%2Bcu116-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-dZhqvlchOCWOuXlctM1z9Asr34N0/voa9v9rsNvJcsY=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.13.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.13.1%2Bcu116-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-DJorYFrDD89HXWD3m6N4rwBzoi3lhUU/jD3WwUUqubw=";
    };
    x86_64-darwin-37 = {
      name = "torchvision-0.13.1-cp37-cp37m-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.13.1-cp37-cp37m-macosx_10_9_x86_64.whl";
      hash = "sha256-XmMSQb7jZh3mT4NhZlYiSvLjUS6yWA2nwI4IuMllqKw=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.13.1-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.13.1-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-8jChpA7XDVHkY85D3yQ+xSCQL4cl3iUC5IXvxe6p2GQ=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.13.1-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.13.1-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-Api647Caw2GGYIhDQAjYK5nWRY/oiIyN+Qcg70s0fUQ=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.13.1-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.13.1-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-GShqczxp3L1Be4Z5PfgHvSJ9tXhu14fBcpd0GpsND8c=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.13.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.13.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-6aVjiU+fpAaS4k0apYw+8EBFABfP7TWY/5Y39ATz/js=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.13.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.13.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-xe1gnIvIjFdSJkALIjLgMJCUR3yCrziVLgNz7e8AA/0=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.13.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.13.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-CPWS6mGDbr7Otcl/TXqBO519xlG7985EAVY8z65qIfw=";
    };
  };
}
