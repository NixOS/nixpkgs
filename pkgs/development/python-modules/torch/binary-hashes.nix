# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "1.13.0" = {
    x86_64-linux-37 = {
      name = "torch-1.13.0-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torch-1.13.0%2Bcu116-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-GRxMQkGgtodNIUUxkHpaQZoYz36ogT0zJSqJlcTwbH4=";
    };
    x86_64-linux-38 = {
      name = "torch-1.13.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torch-1.13.0%2Bcu116-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-VsudhAGP8v02zblKMPz5LvZBVX2/OHEMQRoYzvMhUF8=";
    };
    x86_64-linux-39 = {
      name = "torch-1.13.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torch-1.13.0%2Bcu116-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-Ep2VJJ/iDM2D0VYyOl4qarqD4YhBoArHJOJwrYBt1JM=";
    };
    x86_64-linux-310 = {
      name = "torch-1.13.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torch-1.13.0%2Bcu116-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-MSGHkzNHdbxjr5Xh6jsYaU6qkCrupf2bMhWrryLq+tA=";
    };
    x86_64-darwin-37 = {
      name = "torch-1.13.0-cp37-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.0-cp37-none-macosx_10_9_x86_64.whl";
      hash = "sha256-zR5n22V14bFzpiYHelTkkREzF4VXqsUGg9sDo04rY2o=";
    };
    x86_64-darwin-38 = {
      name = "torch-1.13.0-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.0-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-75NKIdpvalFtCpxxKoDQnFYSir3Gr43BUb7lGZtMO04=";
    };
    x86_64-darwin-39 = {
      name = "torch-1.13.0-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.0-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-kipJEGE7MQ++uHcH8Ay3b+wyjrYMwTSe0hc+fJtu3Ng=";
    };
    x86_64-darwin-310 = {
      name = "torch-1.13.0-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.0-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-SalJuBNrMrLsByTL9MZni1TpdLfWjxnxIx7qIc3lwjs=";
    };
    aarch64-darwin-38 = {
      name = "torch-1.13.0-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.0-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-8Bqa4NS2nS/EFF6L6rRbeHc0Ld29SDin08Ecp/ZoB0U=";
    };
    aarch64-darwin-39 = {
      name = "torch-1.13.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-R/5iKDhr/210MZov/p1O2UPm6FRz146AUCUYxgfWRNI=";
    };
    aarch64-darwin-310 = {
      name = "torch-1.13.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-D904yWIwlHse2HD+1KVgJS+NI8Oiv02rnS1CsY8uZ8g=";
    };
  };
}
