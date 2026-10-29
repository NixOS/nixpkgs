# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.14.1" = {
    x86_64-linux-310 = {
      name = "torch-2.14.1+cu130-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.14.1%2Bcu130-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-UkA5vuH9t+lvlDdoM1upZKitKn1eQVJdptxIl64n7RY=";
    };
    x86_64-linux-311 = {
      name = "torch-2.14.1+cu130-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.14.1%2Bcu130-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-kCO2pThxTjcP6eAn/CDFxgC743WbedmhpvB+c8QNuNA=";
    };
    x86_64-linux-312 = {
      name = "torch-2.14.1+cu130-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.14.1%2Bcu130-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-U1myVaxowMq7gpOVKzjgDw0aVwgVzYfxm2GvcCwHFBA=";
    };
    x86_64-linux-313 = {
      name = "torch-2.14.1+cu130-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.14.1%2Bcu130-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-OnjqCk1mBcHjUbM6uKq+RN24FSOc7ADMb4VVXSbApaU=";
    };
    x86_64-linux-314 = {
      name = "torch-2.14.1+cu130-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.14.1%2Bcu130-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-Ugb6gxY6px3AGGY3sqouw/txFIkgOf3ePJG/VwvSO6g=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.14.1-cp310-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.14.1-cp310-cp310-macosx_14_0_arm64.whl";
      hash = "sha256-46wKhi8egaI70rn/l5wYmiFU5zHAbUxTC/vyZC/wHd8=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.14.1-cp311-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.14.1-cp311-cp311-macosx_14_0_arm64.whl";
      hash = "sha256-ewZwtUXxtzKjIZlm5nBLJzmKMqdkvHzOBl5AsULc+KE=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.14.1-cp312-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.14.1-cp312-cp312-macosx_14_0_arm64.whl";
      hash = "sha256-nPMILSVWDvse75IYcVlSJ8DPMFq7d2HKRba5iO9s3UU=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.14.1-cp313-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.14.1-cp313-cp313-macosx_14_0_arm64.whl";
      hash = "sha256-gnYsdScHnx4Xp3FoQ2LtUUAOO8cpQt8wIX5A8nxoFtc=";
    };
    aarch64-darwin-314 = {
      name = "torch-2.14.1-cp314-cp314-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.14.1-cp314-cp314-macosx_14_0_arm64.whl";
      hash = "sha256-F7Mv1oq+lCnZNsZDV54kRl5xdKBsFou/zAE5WogbyK8=";
    };
    aarch64-linux-310 = {
      name = "torch-2.14.1+cpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.14.1%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-uGn+k1jJDdgtAtuJrviXKd+TqJpIt8PiGncZq/VVhrM=";
    };
    aarch64-linux-311 = {
      name = "torch-2.14.1+cpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.14.1%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-NqA6P4fsh1yjnI4p7MuvD8cEYF94o/fxefFXBIw8OV4=";
    };
    aarch64-linux-312 = {
      name = "torch-2.14.1+cpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.14.1%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-KvZJmUs23/xicXXD8wbZ5ROjCbWNRhmscQdXdhMzZFQ=";
    };
    aarch64-linux-313 = {
      name = "torch-2.14.1+cpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.14.1%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-eDo97BDScuQO0/GgXsIoQAMA0yKbj3UhqTJ2RfrohkY=";
    };
    aarch64-linux-314 = {
      name = "torch-2.14.1+cpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.14.1%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-9WzSOjvwA7++09oGRboJs8zGbAovKscmqbmPNODkkm8=";
    };
  };
}
