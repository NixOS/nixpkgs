# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.2.0" = {
    x86_64-linux-38 = {
      name = "torch-2.2.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-on2vBAW5JDWXlcOaWnP/MRUYgNY/ZePwBRwi+bs7Ix4=";
    };
    x86_64-linux-39 = {
      name = "torch-2.2.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-ccYx+u1TWJYdL6WCo3Dh0p+L7GT8Autv9vTrLFas/YU=";
    };
    x86_64-linux-310 = {
      name = "torch-2.2.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-xEECFnLr4uWvvbNIF6qF5tMhMPlN8tqa1Mt4qdS4E3A=";
    };
    x86_64-linux-311 = {
      name = "torch-2.2.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-C8Wa5xUo8KYBPxsBZw8DnMbQGyztenIZyhbuGUwwURY=";
    };
    x86_64-darwin-38 = {
      name = "torch-2.2.0-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-n6S6LDDsKUolu0t6FaegYSDTqub4+N50A5G9ZSOcgAY=";
    };
    x86_64-darwin-39 = {
      name = "torch-2.2.0-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-jTTFeq04rJJTWsryl8vuYDbwMZKGxgJnpKBz4fwWlxg=";
    };
    x86_64-darwin-310 = {
      name = "torch-2.2.0-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-Ux4YihpeLVzqPX+bbqviXwOT9k5mTJj26LIYdfIFT5M=";
    };
    x86_64-darwin-311 = {
      name = "torch-2.2.0-cp311-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp311-none-macosx_10_9_x86_64.whl";
      hash = "sha256-yCp8ENobrFoxlWhnHce7+PexfFUfwjPlqAgDurnvDQQ=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.2.0-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-TCrIfQcXzbYqkUJTTPCFmFHvONk6KC6dyRUYETp6gDM=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.2.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-xZuzd7T6xt4wZrqPFZuWAEWLCcwyo/Y9ADDbmVpR/qk=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.2.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-kApUIX2bUP0RIVXO11+JCB8jyFqlmLX+A8ng2gDlOSc=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.2.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-qbGvT92jsrSCTl8SMz19vSJ5EwJBWGly2WrOuYtErJs=";
    };
    aarch64-linux-38 = {
      name = "torch-2.2.0-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-pfl3K7le+v2QbeaDEEryMB7xhgjQx/Ny/xpaYb95K4g=";
    };
    aarch64-linux-39 = {
      name = "torch-2.2.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-5tJVCovq33nOSCcaoqKBF16RowZf7ThdKouYAsKnRNs=";
    };
    aarch64-linux-310 = {
      name = "torch-2.2.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-GeiXY73Z3wv145Ri6UEMYSp6Rq/3LqKFuXkprCBFEj8=";
    };
    aarch64-linux-311 = {
      name = "torch-2.2.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-TYGa0jWR4M2KPAt0DYTqrm/QmSjPLK3OveiuYFrC24s=";
    };
  };
}
