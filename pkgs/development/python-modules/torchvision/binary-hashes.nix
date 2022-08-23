# Warning: use the same CUDA version as pytorch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.12.0" = {
    x86_64-linux-37 = {
      name = "torchvision-0.12.0-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchvision-0.12.0%2Bcu113-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-i/qktZT+5HQYQjtTHtxOV751DcsP9AHMsSV9/svsGzA=";
    };
    x86_64-linux-38 = {
      name = "torchvision-0.12.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchvision-0.12.0%2Bcu113-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-NxM+jFsOwvAZmeWRFvbQ422a+xx/j1i9DD3ImW+DVBk=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.12.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchvision-0.12.0%2Bcu113-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-bGO5q+KEnv7SexmbbUWaIbsBcIxyDbL8pevZQbLwDbg=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.12.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchvision-0.12.0%2Bcu113-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-ocsGOHa967HcZGV+1omD/xMHufmoi166Yg2Hr+SEhfE=";
    };
    x86_64-darwin-37 = {
      name = "torchvision-0.12.0-cp37-cp37m-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.12.0-cp37-cp37m-macosx_10_9_x86_64.whl";
      hash = "sha256-GJM7xZf0VjmTJJcZqWqV28fTN0yQ+7MNPafVGPOv60I=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.12.0-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.12.0-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-DWAuCb1Fc2/y55aOjduw7s6Vb/ltcVSLGxtIeP33S9g=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.12.0-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.12.0-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-RMye+ZLS4qtjsIg/fezrwiRNupO3JUe6EfV6yEUvbq0=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.12.0-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.12.0-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-aTZW5nkLarIeSm6H6BwpgrrZ5FW16yThS7ZyOC7GEw8=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.12.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.12.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-n0JCD38LKc09YXdt8xV4JyV6DPFrLAJ3bcFslquxJW0=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.12.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.12.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-adgvR7Z7rW3cu4eDO6WVCmwnG6l7quTAlVYQBxvwNPU=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.12.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.12.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-oL5FAcoLobGVZEySQ/SaHEmiblKn83kkxCOdC/XsvY0=";
    };
  };
}
