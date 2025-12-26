# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.9.1" = {
    x86_64-linux-310 = {
      name = "torch-2.9.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.9.1%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-yNZwqgvm++zSsOe31RShBNve/MN4bKRGzww0FQQ+pAo=";
    };
    x86_64-linux-311 = {
      name = "torch-2.9.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.9.1%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-Kh2pQPB1diHQmMl1X3UE15GnKkCSDshaT9mLICU/yk4=";
    };
    x86_64-linux-312 = {
      name = "torch-2.9.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.9.1%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-fLQBj0zmi2H9Pvh9wcTKUgcxx7WyAONgrUe2EteEQGM=";
    };
    x86_64-linux-313 = {
      name = "torch-2.9.1-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.9.1%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-YzgaEJpWmygO0zGdqJ06/lz5q1yHmTY4KiEq/7XJBVI=";
    };
    x86_64-linux-314 = {
      name = "torch-2.9.1-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.9.1%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-d4jT0D2TnPAPk6wNpatSCEb2ZBHjOc+/UZqAbo+s9Rk=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.9.1-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.1-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-vx5oz7k1riBGN0/wKnqnPdpwNRtGNChG9VcFWzpUC/A=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.9.1-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.1-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-pSlSqMkKQiwUYn6pm5gmt1VyA7RrTQdy08pcdplpJCU=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.9.1-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.1-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-KHJC3R+DCEYJi17KhH+BeqXGAV6lerTBKHgJ7+p7d+s=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.9.1-cp313-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.1-cp313-none-macosx_11_0_arm64.whl";
      hash = "sha256-vO5krnqmWHbO6ubcrr51EJSFshNSjHSTlgIgiiBwbj8=";
    };
    aarch64-darwin-314 = {
      name = "torch-2.9.1-cp314-cp314-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.1-cp314-cp314-macosx_11_0_arm64.whl";
      hash = "sha256-3vrb6wVc/PXe9Y9wk3FFrsvXpLwpUjje0dDoWuLPDh0=";
    };
    aarch64-linux-310 = {
      name = "torch-2.9.1-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.1%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-EIZsikjEqlrj9IU43IoFW5nFfZxq8r9d1xU3TZ1t3KM=";
    };
    aarch64-linux-311 = {
      name = "torch-2.9.1-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.1%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-DmEc+xZyTmIlK2fTEHO8XEkMuD6S7NwRknYlNeDkRIc=";
    };
    aarch64-linux-312 = {
      name = "torch-2.9.1-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.1%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-O/m0QqUaKUjkEhanbXqwDwaUz8qqUbb5vKtXt/iYQ+Y=";
    };
    aarch64-linux-313 = {
      name = "torch-2.9.1-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.1%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-PlMuVTs37oWSBamy0ceXf9aSL1O7sbm/3VvcANGmDtQ=";
    };
    aarch64-linux-314 = {
      name = "torch-2.9.1-cp314-cp314-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.1%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-ZQEKtKrM5smh3fyTX5hsADyoY43tBDSP0ybD50NGI3w=";
    };
  };
}
