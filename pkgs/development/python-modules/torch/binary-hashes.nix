# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.1.1" = {
    x86_64-linux-38 = {
      name = "torch-2.1.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-h8y2g+ZCqYuO8FRV722GRntiB1pDJfTV+aouiTL2Bzk=";
    };
    x86_64-linux-39 = {
      name = "torch-2.1.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-KCRfYtEHPCfW8N4DqBrUnVMzxGBlke2I/tHtuX8FUz0=";
    };
    x86_64-linux-310 = {
      name = "torch-2.1.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-7HbRE1DI6IejTTZgLNN/UGObyc2p+upNQ/IHDpeS5KQ=";
    };
    x86_64-linux-311 = {
      name = "torch-2.1.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-g7/hE036irhlU8Fdpd/6GQqG2CKvr+jqbeEWnBDZcao=";
    };
    x86_64-darwin-38 = {
      name = "torch-2.1.1-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-1WsDIXZFjir0cJYnu9LCD+KRfv+M0Ien/jE6zM9c4vE=";
    };
    x86_64-darwin-39 = {
      name = "torch-2.1.1-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-cVtQ2MHeXaVSSmgofrAA9z4CbnTV9rErxFDvaZX89fk=";
    };
    x86_64-darwin-310 = {
      name = "torch-2.1.1-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-Hh5frd1DqPLA4OIr6s0eI1ouRHeU2AdIPJSp4xtUp1g=";
    };
    x86_64-darwin-311 = {
      name = "torch-2.1.1-cp311-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp311-none-macosx_10_9_x86_64.whl";
      hash = "sha256-pwWTgG8dfmtTZX2WgQUY2g+I7yYIyYpAKVV2W4x51Sw=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.1.1-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-KeO5CowoH2ZggEqTnR9CGGBMgBYuUh4ebYyFVzJZAqA=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.1.1-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-22foclx29Mf08C51UbsW6BuhoZEoZ7w117uW0r6MeLQ=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.1.1-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-52vzxcNUh08dpGXIUqL7YO5svOMG6TUzeIV2DwgPm6o=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.1.1-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-4xL36C5JVl92Z7C7+VWasMWXBj2TBEdAeBwCrNWoeXg=";
    };
    aarch64-linux-38 = {
      name = "torch-2.1.1-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-nKD8vz1bpkTWqFcsg6mrvfX3/1dbw4Up72wYWjpxvek=";
    };
    aarch64-linux-39 = {
      name = "torch-2.1.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-sxIwvQWEJOVtun+JkoDbxqyLmUjkOQLgyEpEZmsewVE=";
    };
    aarch64-linux-310 = {
      name = "torch-2.1.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-hP79YzVkFsDNIFeGN8zbuCFkmTQA7Re1fJUd1jdtzug=";
    };
    aarch64-linux-311 = {
      name = "torch-2.1.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-YbUbM8YXN8KHBYsMMGHmqdPDY4Y+SglPgEvEhoiKGIo=";
    };
  };
}
