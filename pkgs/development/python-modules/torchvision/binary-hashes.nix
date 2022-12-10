# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.14.0" = {
    x86_64-linux-37 = {
      name = "torchvision-0.14.0-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.14.0%2Bcu116-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-IuZAWuVKUv+kIppkj4EjqaqHbPEidmpOhFzaOkQOIws=";
    };
    x86_64-linux-38 = {
      name = "torchvision-0.14.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.14.0%2Bcu116-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-DsInXsr//MOf2YwXPhVDo5ZeL86TPwzqeNpjRAPk2bk=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.14.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.14.0%2Bcu116-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-0kLPJk8atPVYMCjFqK1Q1YhIA8m4NpkspayPdT5L6Ow=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.14.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.14.0%2Bcu116-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-65W6LC8V57riwtmKi95b8L4aHBcMgZSBUepkho7Q6Yc=";
    };
    x86_64-darwin-37 = {
      name = "torchvision-0.14.0-cp37-cp37m-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.14.0-cp37-cp37m-macosx_10_9_x86_64.whl";
      hash = "sha256-9rQd9eTa9u4hthrlp3q8znv30PdZbJILpJGf57dyfyA=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.14.0-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.14.0-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-ASPQKAxUeql2aVSSixq5ryElqIYfU68jwH5Wru8PJSA=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.14.0-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.14.0-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-amqnKATP+VUMu4kPmMfp/yas38SAZNESn68bv+r2Cgo=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.14.0-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.14.0-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-e24XBnYOrOAlfrsGd0BM3WT0z4iAS8Y3n2lM8+1HBZE=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.14.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.14.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-aBEEGMgzoQFT44KwOUWY3RaauCOiFoE5x7T2LqSKREY=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.14.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.14.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-HEd9u4/20OHHhHqpS1U0cHbGZIY67Wnot5M1yxJnTBs=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.14.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.14.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-HbVwFKaUboYz4fKGOq6kfVs+dCT5QTarXVCGGm2zVpg=";
    };
  };
}
