# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.12.1" = {
    x86_64-linux-310 = {
      name = "torch-2.12.1+cu130-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.12.1%2Bcu130-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-9/WsBh92dJF8rLqUIfChXo3zUQV/kBMs1GzMup36dyE=";
    };
    x86_64-linux-311 = {
      name = "torch-2.12.1+cu130-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.12.1%2Bcu130-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-YjXzogtglMfoiCxlqGp/PG6MOsjb7AtX5XWTfQFm7Q8=";
    };
    x86_64-linux-312 = {
      name = "torch-2.12.1+cu130-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.12.1%2Bcu130-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-S6/DVvu2IuJ1YXlAaCXDpWwXtAEZZDWhSHxbQMZXcGw=";
    };
    x86_64-linux-313 = {
      name = "torch-2.12.1+cu130-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.12.1%2Bcu130-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-1eGEBELSGClXs9L3eMwyXJD6XLQqqLGslJ8CnpvdfwY=";
    };
    x86_64-linux-314 = {
      name = "torch-2.12.1+cu130-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.12.1%2Bcu130-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-yExZiLPkFmae03kNdyR5r1k00XiBGSiNi93ZxMsgcoU=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.12.1-cp310-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.12.1-cp310-cp310-macosx_14_0_arm64.whl";
      hash = "sha256-7FboK+aosMA2dxp399Mq08KZdwVxr5gVs9r+YUNDidU=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.12.1-cp311-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.12.1-cp311-cp311-macosx_14_0_arm64.whl";
      hash = "sha256-74H1A5Eu/+os49mxKi46btSIlD6RJxyQx6gp9guvaqI=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.12.1-cp312-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.12.1-cp312-cp312-macosx_14_0_arm64.whl";
      hash = "sha256-0t0PLF98y92vNMreDer0doCDaPkCuc2382oqtCMBvA4=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.12.1-cp313-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.12.1-cp313-cp313-macosx_14_0_arm64.whl";
      hash = "sha256-x16TFzxwC8zWv8xKnRnOJCq22s0fF4FIMCehYjm55lA=";
    };
    aarch64-darwin-314 = {
      name = "torch-2.12.1-cp314-cp314-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.12.1-cp314-cp314-macosx_14_0_arm64.whl";
      hash = "sha256-6bb30t1m6oejrmIAadMTNdWUwG7/saODvdIc/mHkTs4=";
    };
    aarch64-linux-310 = {
      name = "torch-2.12.1+cpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.12.1%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-k7jOs2ieNKkkZdTKx9COZd/PSdENbUfRXbXzkXuqEVI=";
    };
    aarch64-linux-311 = {
      name = "torch-2.12.1+cpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.12.1%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-bRth5TosAA4eXMSfyIrrxmW98CxjkQwkMRbTldfLwWQ=";
    };
    aarch64-linux-312 = {
      name = "torch-2.12.1+cpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.12.1%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-0WILx7z4CH8+SIIbXbmUoD4y3bCD1YwAC44DL4puLRU=";
    };
    aarch64-linux-313 = {
      name = "torch-2.12.1+cpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.12.1%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-jUfgz8WWedTjZ2RsPfTPQzx9FZWzEwfg57I5HFjKIWA=";
    };
    aarch64-linux-314 = {
      name = "torch-2.12.1+cpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.12.1%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-G5rXDQowDWvYg//8FTpsD5vGS/QZBRmu7tA3OAe/+8w=";
    };
  };
}
