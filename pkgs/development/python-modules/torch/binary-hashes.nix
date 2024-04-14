# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.2.2" = {
    x86_64-linux-38 = {
      name = "torch-2.2.2-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.2%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-wXi+srsB93NgF3e8SBx2Ub5bHxic8YDwwKzqwHiaqaU=";
    };
    x86_64-linux-39 = {
      name = "torch-2.2.2-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.2%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-EU6TlYZ+6GAWZWLYzB8oCSJfnil4PdXnIXXZqaeoUFw=";
    };
    x86_64-linux-310 = {
      name = "torch-2.2.2-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.2%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-yt5P1sjOfYJtvPq9ZfHVOw7goFjbjBgJ1lv9YFG1VTA=";
    };
    x86_64-linux-311 = {
      name = "torch-2.2.2-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.2%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-TJTk0aItcKu9/3Ft7Jm6Xv+UtDQP+nO0+2KflA27inU=";
    };
    x86_64-darwin-38 = {
      name = "torch-2.2.2-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-gVF29iyPN8z7shCBwHaaiLG6pptxaRGapCtl7l8QTi0=";
    };
    x86_64-darwin-39 = {
      name = "torch-2.2.2-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-8TdigY3CgP7KfjD2CZWhe6jR0asz/vttB/0sj/FXHqo=";
    };
    x86_64-darwin-310 = {
      name = "torch-2.2.2-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-5nfE102wz8KxCSPeG95XXZgculRQXdwIKwUI2WQRmFA=";
    };
    x86_64-darwin-311 = {
      name = "torch-2.2.2-cp311-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp311-none-macosx_10_9_x86_64.whl";
      hash = "sha256-QwDLu00EKMUbXBlBkBaQGNW4GP2fb6/Ci76P2E3tF0A=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.2.2-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-7RTSpDZEIEkDg9JveQCj99XFDDLlzf3d3/+Dd22eD9Q=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.2.2-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-/q2//ddjTP40Xqh9fuQDGzAPnHZFIFkOA0idZYtpMds=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.2.2-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-tSDRTS8oEK1dp1i+oQyveXjvNkNWW8APkN6JLgDXeSU=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.2.2-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-gipYlnXLqKzwRX1qTltspEGtO0w6RKHLyPizGueWRF4=";
    };
    aarch64-linux-38 = {
      name = "torch-2.2.2-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-mJTc3W71tbYDzYzqPjcR+eJ3CC/3sPFLFSb90ay4JSE=";
    };
    aarch64-linux-39 = {
      name = "torch-2.2.2-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-1dhev9E/fNA+UGMlP4R57RpXBSZBZtXdH8abS5YjGyA=";
    };
    aarch64-linux-310 = {
      name = "torch-2.2.2-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-OiwHUhgIHvnHv4xVxwbyNtrrt1PaQd5JispxYyVzgL0=";
    };
    aarch64-linux-311 = {
      name = "torch-2.2.2-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.2-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-WUgt9dxA2uEF5z9I3Sk/TMxndkCCLCzjQnOjh1SZA64=";
    };
  };
}
