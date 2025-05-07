# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.7.0" = {
    x86_64-linux-39 = {
      name = "torch-2.7.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.7.0%2Bcu128-cp39-cp39-manylinux_2_28_x86_64.whl";
      hash = "sha256-9Eb5eyDLBwdHsQP7ZA35QbiMtoyNOwFTgofQXVan6HQ=";
    };
    x86_64-linux-310 = {
      name = "torch-2.7.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.7.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-rBhJVT7mc9+vtExhDGDLYKKJDw4Rf0NZmlJs93fri4w=";
    };
    x86_64-linux-311 = {
      name = "torch-2.7.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.7.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-xLvAtL5gMZuhzvyQvpVXsxfws8Jh7s65bKbgND7sVr8=";
    };
    x86_64-linux-312 = {
      name = "torch-2.7.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.7.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-fA8I0cRKAqutOJNz3d/OdZBLlppBC+L05RCUg909wM4=";
    };
    x86_64-linux-313 = {
      name = "torch-2.7.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.7.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-0vafkJ2l3FIRPsZqhR1iB589UsgxhM9kvuvfEsovcFw=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.7.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-zNdQkUFxOZeGG3qUfvCnFxQ81+kkCt3RaPOLqP0j/VY=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.7.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-NOAWjtbemRIWEtciJOWbKlioPa5kmZmQ6tpyYMXdWC0=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.7.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-Co1DyqNCuZhhAexf61u/HYZXC1yqAenLQmN4MRJY/d4=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.7.0-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.0-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-MLdoiocjmn3oPyaTM2Udjlgq//zm9ZH/8IwEb3eHKW4=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.7.0-cp313-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.0-cp313-none-macosx_11_0_arm64.whl";
      hash = "sha256-J/UAe99F97t69/EdGCjVwkh+AwaQr7PYmmUf1wNqOQ4=";
    };
    aarch64-linux-39 = {
      name = "torch-2.7.0-cp39-cp39-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.0%2Bcpu-cp39-cp39-manylinux_2_28_aarch64.whl";
      hash = "sha256-fQpBBrwP4zkpX1CZAM5GIo9Fua2GRmYv5Qx9nllgw8E=";
    };
    aarch64-linux-310 = {
      name = "torch-2.7.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-I4aFne5hkaJXHOFcZcPhgAjU5vF9UlbUm0Zg5UZNyug=";
    };
    aarch64-linux-311 = {
      name = "torch-2.7.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-zlEDde15Ij2z7BRP4Uy8/8ijYaxX85Z0OX/y2Ns7LCE=";
    };
    aarch64-linux-312 = {
      name = "torch-2.7.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-qEW2872jxA9zaEfe3pXYv+yB+34RRYzSWXO6E1Qs8fY=";
    };
    aarch64-linux-313 = {
      name = "torch-2.7.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-rd+RB5OVIv+ztg0pAP7oOKd9vgmOJkPgEWT0b4YS+cA=";
    };
  };
}
