# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.29.2" = {
    x86_64-linux = {
      name = "torchvision-0.29.2-py3-none-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu132/torchvision-0.29.2%2Bcu132-py3-none-manylinux_2_28_x86_64.whl";
      hash = "sha256-n9cGyGAleZ59/sUDUTzZLxAIHzuZ8d1pmU4iAUBrghE=";
    };
    aarch64-darwin = {
      name = "torchvision-0.29.2-py3-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.2-py3-none-macosx_14_0_arm64.whl";
      hash = "sha256-1BJJT/AR8kyISjz/0z66HLRaApnU4mweF1ET+dOz68c=";
    };
    aarch64-linux = {
      name = "torchvision-0.29.2-py3-none-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.2%2Bcpu-py3-none-manylinux_2_28_aarch64.whl";
      hash = "sha256-C+L4WTMBLLSH+ETHSDZlGRZT7oaE2onW0ONP1jw6Cog=";
    };
  };
}
