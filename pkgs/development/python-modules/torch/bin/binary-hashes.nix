# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.13.0" = {
    x86_64-linux-310 = {
      name = "torch-2.13.0+cu130-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.13.0%2Bcu130-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-g3ZymBCRSPEN4SQoezkrxY10+ZOOlDDyb5/Wae+4r5w=";
    };
    x86_64-linux-311 = {
      name = "torch-2.13.0+cu130-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.13.0%2Bcu130-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-eUZkwFo0cKXnOER7VElcxrvx78pIvyeUJwqJfZ9DVsQ=";
    };
    x86_64-linux-312 = {
      name = "torch-2.13.0+cu130-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.13.0%2Bcu130-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-jbczjmiVw9S9iaAv9CCVB9Hwzy/+s7iYU4taB9HqjB4=";
    };
    x86_64-linux-313 = {
      name = "torch-2.13.0+cu130-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.13.0%2Bcu130-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-lb260vB4a9RIky5LcqZASqIikNtuyVTiTt+m0zyDPI8=";
    };
    x86_64-linux-314 = {
      name = "torch-2.13.0+cu130-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torch-2.13.0%2Bcu130-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-4jEwKkVymNAjb3veMQglaPbNBhO2a060aEnorVPC440=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.13.0-cp310-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.13.0-cp310-cp310-macosx_14_0_arm64.whl";
      hash = "sha256-lPDeEpkW93uNwseo7/ZEz+3f5Z45yfVen24XVDQQKB0=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.13.0-cp311-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.13.0-cp311-cp311-macosx_14_0_arm64.whl";
      hash = "sha256-52+bzsxSuP9xEjmi91R9U1PflYeKsjLwdzwdlZKLkvg=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.13.0-cp312-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.13.0-cp312-cp312-macosx_14_0_arm64.whl";
      hash = "sha256-L+Ioq6KQ0UufMbBJvlUNvUacP9MBPXoZcFswRU2pcCc=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.13.0-cp313-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.13.0-cp313-cp313-macosx_14_0_arm64.whl";
      hash = "sha256-M0SYmc5UlsG4S0hTF52U/RAgKK4UBzFNn7lWu3nnDQk=";
    };
    aarch64-darwin-314 = {
      name = "torch-2.13.0-cp314-cp314-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.13.0-cp314-cp314-macosx_14_0_arm64.whl";
      hash = "sha256-2EmzkOB9jTM86OyvkbJzxlbFmDeaGcms8TGKiD9rORw=";
    };
    aarch64-linux-310 = {
      name = "torch-2.13.0+cpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.13.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-8CjkKL3e6VzbhuJHAlTpXJr2KTYkiFUMIA7UeTElqBc=";
    };
    aarch64-linux-311 = {
      name = "torch-2.13.0+cpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.13.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-hEU7aVCOx5kC+JnF7ZSVrLniu+n9pfHV1vGePDhC4ac=";
    };
    aarch64-linux-312 = {
      name = "torch-2.13.0+cpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.13.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-bzB8LDLXZP/G/2iTuAH61tR1Lz5nlmy4q/GENCfAJgQ=";
    };
    aarch64-linux-313 = {
      name = "torch-2.13.0+cpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.13.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-C499BCMCeui5DHl3xifzN58yU2OggiTf+tm0staEqD0=";
    };
    aarch64-linux-314 = {
      name = "torch-2.13.0+cpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.13.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-ygIfnrL4NFyD+gPjoEWHMIr7jfcb1HJnCz7OAN9YYhw=";
    };
  };
}
