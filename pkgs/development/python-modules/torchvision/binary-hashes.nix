# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.16.2" = {
    x86_64-linux-38 = {
      name = "torchvision-0.16.2-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.2%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-AmZyfQifUSqpAK6tKQhTD1TZB3eEveHnykb2a49Wfpg=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.16.2-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.2%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-qhMlpuBBYD3uzvxWnmS4x1psmhuHbimi3vKYuoRWR00=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.16.2-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.2%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-uqeXDGtUNzEuXdC9DyVxogt4bD4oW6/W7T5PYqXDx24=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.16.2-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.2%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-CS1ZEQqf7PfDtE0YsbWqELqJjiVB4HtnT+WSaFIeuMs=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.16.2-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.2-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-uCcy3Ph2o3yFJ3I0KqbuNIDAO7PiqAKuEJ/F9+KNJuk=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.16.2-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.2-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-VhFSaLN/C3U2TjZU5HrZq8Zqw0wfnl49+omiLWpAAXo=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.16.2-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.2-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-vIbygAyywMGgnFgUCc3Wv/ZuYvED3IP8Y/czRiZMN1Y=";
    };
    x86_64-darwin-311 = {
      name = "torchvision-0.16.2-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.2-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-Z7Gq+LjLAs513URfKRonyANqUC+MCqduKMN6D6rC4VM=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.16.2-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.2-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-SwZRQ9GnIP6KkHf9S+NdSR+YgZ7ICz27w+xk0LcHqQY=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.16.2-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.2-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-goBfhEWwlPnR53A5DubMhoVeiZVeCM40ry4idPwOXEU=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.16.2-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.2-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-sCS9QS3206AH3OvzEaiU6zxcIeGvgNEr44K7ywl6fDo=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.16.2-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.2-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-vvMNA+HRxil2H03KUdO32KDcCszm9AaKsqFjTo57ZOA=";
    };
  };
}
