# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.20.0" = {
    x86_64-linux-39 = {
      name = "torchvision-0.20.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.20.0%2Bcu124-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-UP9Puz3JlN21FK7WvZLJDMF1sWjGWYg4014qxTqaCos=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.20.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.20.0%2Bcu124-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-k5Ni8WH31mqPKrExODqzeZhFjjCO4sYsnRzSdR37KEI=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.20.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.20.0%2Bcu124-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-O0R4ODFuAqqSFSklZbp5wT0//rBjGgkAxby4uB7iJtc=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.20.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.20.0%2Bcu124-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-hGajClfLUfO0GtC+QKxc8/GijZMnMKHEEWyD0yHQfjw=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.20.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-anDIHqUGjdex40Dr6rtlNkV22LmBlFTP34EikM8D5Fo=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.20.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-8WTVRZZRhv/WYBTjSpZnBtEshBmDAt1GdIyuRZhGCaQ=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.20.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-oV3mJmo2vNENifbz17pOLdVnp6Ct1hbrxuZa6iB5Dl0=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.20.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-rA7bpTT7BxsrA6L9XLv5t8JZiW0XodDYMLPFt9+uB4I=";
    };
    aarch64-linux-39 = {
      name = "torchvision-0.20.0-cp39-cp39-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.0-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-jWzqirC/cuy3GwfND+g26s9aX6mPZinSJhIS6Ql3uWM=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.20.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.0-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-4IT1Dsvb56nML8UeoDZ641/eRuhKlkv0BGyxx/634+Y=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.20.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.0-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-Vdf0PvkS68TaS7pzoLvzh9OKa+nNUhZ5wPQFb5Vktpg=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.20.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.0-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-+NAhNIms+xODafJFWmiTiAwZSoGV44HBn4crJ38mVMM=";
    };
  };
}
