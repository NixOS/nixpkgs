# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.7.1" = {
    x86_64-linux-39 = {
      name = "torch-2.7.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.7.1%2Bcu128-cp39-cp39-manylinux_2_28_x86_64.whl";
      hash = "sha256-c4rJs6155iohJW49JQzuhY3pVfk/ifqxFNqNGRk0fQY=";
    };
    x86_64-linux-310 = {
      name = "torch-2.7.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.7.1%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-1sPLoZjck/k0IqhUX0imaXiQNm5LlwH1Q1H8J+IwS9M=";
    };
    x86_64-linux-311 = {
      name = "torch-2.7.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.7.1%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-wwHcKARYr9lUUK95SSTJj+B1It0Uj/OEc5uBDj4xefI=";
    };
    x86_64-linux-312 = {
      name = "torch-2.7.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.7.1%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-C2T30KbypzntBSupWfe2fGdwKMlWbOUZl/n5D+Vz3ao=";
    };
    x86_64-linux-313 = {
      name = "torch-2.7.1-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.7.1%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-lWBCX56hrxeRUH6Mpw1bns9i/tfKImqV/NWNDrLMp48=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.7.1-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.1-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-NRvpBdG6aT8xe+YDRB5O2VgO2ajX7hez2uYPov9Jv/c=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.7.1-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.1-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-+MO+4mGwyOCQ9jR0kNxu4q6/1mHrDz9q6uBtmS2O1W8=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.7.1-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.1-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-aKNSx/Q1q7XLR+LAMtzRASdyriustvyLg7DBsRh0qzo=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.7.1-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.1-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-e0+LK4O9CPfTmQJamnsyO9u1PSBWbx4NWEaJu5LYL5o=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.7.1-cp313-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.1-cp313-none-macosx_11_0_arm64.whl";
      hash = "sha256-fs2GighkaOG890uR20JcHClRqc/NBZLExzN3t+Qkha4=";
    };
    aarch64-linux-39 = {
      name = "torch-2.7.1-cp39-cp39-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.1%2Bcpu-cp39-cp39-manylinux_2_28_aarch64.whl";
      hash = "sha256-pFUcuXuD31+T/A11ODMlNYKFgeHbLxea/ChwJ6+91ug=";
    };
    aarch64-linux-310 = {
      name = "torch-2.7.1-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.1%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-wN8Xzul2U9CaToRIijPSEhf5skIIWDxVzyjwBFqrB2Y=";
    };
    aarch64-linux-311 = {
      name = "torch-2.7.1-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.1%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-X+YEW49Ca/LQQm5P4AnxZnqVTsKuuC8b0L9gxteoVEU=";
    };
    aarch64-linux-312 = {
      name = "torch-2.7.1-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.1%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-O/LbWt93tDOETwgIh63gScRwXd+f4aMgI/+E/3Napa0=";
    };
    aarch64-linux-313 = {
      name = "torch-2.7.1-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.7.1%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-6xdkZ5KsQ3T/yH5CNp9F0h7/F8eQholjuQSD7wtttO8=";
    };
  };
}
