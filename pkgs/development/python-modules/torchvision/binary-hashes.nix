# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.27.0" = {
    x86_64-linux-310 = {
      name = "torchvision-0.27.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.27.0%2Bcu130-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-Xs5N8/Jq7zmBicaHP5vpW7FUhu8GTElx0WHhpkcMVqI=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.27.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.27.0%2Bcu130-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-+QI3OY77jOcAG4DhhwySGzo3XZHIkrqLRkFfgIWjcR0=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.27.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.27.0%2Bcu130-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-Zk3/RvrJenMMkKl2o3CuLK1SeA32rkD610vnfu6LRSg=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.27.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.27.0%2Bcu130-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-r6QSjzcGa4OvnUJoQaUxR908II7+qJPJPcPrb6KvIoc=";
    };
    x86_64-linux-314 = {
      name = "torchvision-0.27.0-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.27.0%2Bcu130-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-dMLjPv/NrSV4AMF4+H8iz/MR7+cDdWiz/q57Thkc4gk=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.27.0-cp310-cp310-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.0-cp310-cp310-macosx_14_0_arm64.whl";
      hash = "sha256-CCK1jSxdMlzQxxUrdErL0V+JjAdXLiz7cLB1qGWk9vk=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.27.0-cp311-cp311-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.0-cp311-cp311-macosx_14_0_arm64.whl";
      hash = "sha256-3wwWa2vffEf4joHotDvAhUUdXFDQxdFpG8R0wSJ9b+0=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.27.0-cp312-cp312-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.0-cp312-cp312-macosx_14_0_arm64.whl";
      hash = "sha256-Gm3XQqFQZFEm354LLkSYdMHWNYl8dzsyLC4Gfpg4Lf4=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.27.0-cp313-cp313-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.0-cp313-cp313-macosx_14_0_arm64.whl";
      hash = "sha256-Qdba5z4a8J+oLe1ZeuV/KiMUKFrN5UsliQqPjlG5mdc=";
    };
    aarch64-darwin-314 = {
      name = "torchvision-0.27.0-cp314-cp314-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.0-cp314-cp314-macosx_14_0_arm64.whl";
      hash = "sha256-wfrA/Cp63ylIH8GTig54RcV7oRR6mGeEEJxNmPQ06ow=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.27.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-J5oFamQ29p92dnWx8dgrZ+ysoboYcbEc4K9HRKMkqiI=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.27.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-mdBdBx/zQwUzTuGFT17ffCdnuWuln+kudthKH6csjgY=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.27.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-Gwb0LUi2IJgRSSPYo/6fqGQYJxXbBlhKUVFV2wqo6zA=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.27.0-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-aQk7ZLJ2LEPfF74tsr4WMCmWPZC8PxgBUA/etyPlSDM=";
    };
    aarch64-linux-314 = {
      name = "torchvision-0.27.0-cp314-cp314-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-x+PFZiJ4q11k0VDMF2lAYOnOWHW4c5CU2t8HpLpFuQ4=";
    };
  };
}
