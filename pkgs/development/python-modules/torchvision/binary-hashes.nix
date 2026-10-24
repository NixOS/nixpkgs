# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.29.1" = {
    x86_64-linux-310 = {
      name = "torchvision-0.29.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.29.1%2Bcu130-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-MP/hPCBfGzVU3AxSfLy9N+9uCe7kpFtboLvjM2792gE=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.29.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.29.1%2Bcu130-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-tNeSF/jqZ1ikWOPu1marryVuJ3u84d6r3Uyn5pz3SfY=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.29.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.29.1%2Bcu130-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-zmtR1f+tQesdIv9hyzBEFalcG/pDHcAKgMjs4Ggiw7c=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.29.1-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.29.1%2Bcu130-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-R/AArLJEmygdQ3B8kBFqMMf6ACx/e79pdrzCVi3VeHs=";
    };
    x86_64-linux-314 = {
      name = "torchvision-0.29.1-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.29.1%2Bcu130-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-pb2tZnAFwU5ELd95M8BI4CGDSvr0jmS5IMrra9HNfRU=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.29.1-cp310-cp310-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.1-cp310-cp310-macosx_14_0_arm64.whl";
      hash = "sha256-nvjem0pHsA2+Cmo1u6IpB/hvCRre9Xp28VgVAtv8Wfg=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.29.1-cp311-cp311-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.1-cp311-cp311-macosx_14_0_arm64.whl";
      hash = "sha256-iAwceJ/ZzcMc202+kGuMdL2Lm3BQnMn//muZatCg9lY=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.29.1-cp312-cp312-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.1-cp312-cp312-macosx_14_0_arm64.whl";
      hash = "sha256-O2650vj+m5PZ03Y3dJ3zYe/u0TPZbd1QMYShtbErsn8=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.29.1-cp313-cp313-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.1-cp313-cp313-macosx_14_0_arm64.whl";
      hash = "sha256-sLPedvLuVni3lQuplxz3LZxYh815k9theIVS83Fob+0=";
    };
    aarch64-darwin-314 = {
      name = "torchvision-0.29.1-cp314-cp314-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.1-cp314-cp314-macosx_14_0_arm64.whl";
      hash = "sha256-wzy9WWr6E8JN51Lq1DfrXaSChe/W3CoGVDlIghv95Xo=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.29.1-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.1%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-DKn8x8NcoAaC4zonj7xZYjNVLlZBfiVIhhvN0CNmC1E=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.29.1-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.1%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-4QAleqLNiEAIjTIcM48CZX+vQ9gC1HDdjct/9AA1U9I=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.29.1-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.1%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-MFj4VeZQiTMOyYe4ysHM9eeibNR1+MqyBZe1V33ch2c=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.29.1-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.1%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-8e91JBGgMddPeEiMLsk2GfDXWmx2JAm3pUGVkFRXjyw=";
    };
    aarch64-linux-314 = {
      name = "torchvision-0.29.1-cp314-cp314-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.29.1%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-GSpG0cy4EYgQzvDDhS2Q9LpRYL/LCcZ0Bi03U7m5dxk=";
    };
  };
}
