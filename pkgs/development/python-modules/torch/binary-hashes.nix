# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.1.1" = {
    x86_64-linux-38 = {
      name = "torch-2.1.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.1.1%2Bcu118-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-aG6U2bHOHhh2buLsSzX705EhJM+9QgfLdXz57ts58/c=";
    };
    x86_64-linux-39 = {
      name = "torch-2.1.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.1.1%2Bcu118-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-72sDvT7GoSxbr1C2wXj5TtSMvLqv7mboJz9l9Bp3Pnw=";
    };
    x86_64-linux-310 = {
      name = "torch-2.1.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.1.1%2Bcu118-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-jikUSE50rroIVwpSyAV8xdWcGbcqYjpt7Sncm5iBUcA=";
    };
    x86_64-linux-311 = {
      name = "torch-2.1.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.1.1%2Bcu118-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-88C6ArUNACH/JvAw4i1MRZZVN8+R8yLlKmW4xYOW+Bw=";
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
      name = "torch-2.1.1-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.1.1-cp38-cp38-manylinux2014_aarch64.whl";
      hash = "";
    };
    aarch64-linux-39 = {
      name = "torch-2.1.1-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.1.1-cp39-cp39-manylinux2014_aarch64.whl";
      hash = "";
    };
    aarch64-linux-310 = {
      name = "torch-2.1.1-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.1.1-cp310-cp310-manylinux2014_aarch64.whl";
      hash = "";
    };
    aarch64-linux-311 = {
      name = "torch-2.1.1-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.1.1-cp311-cp311-manylinux2014_aarch64.whl";
      hash = "";
    };
  };
}
