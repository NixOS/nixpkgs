# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.20.1" = {
    x86_64-linux-39 = {
      name = "torchvision-0.20.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.20.1%2Bcu124-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-C/Tizgi8dJVzTcVAlTxlmQ5C67fJ7Sfi/3lRVLrvXMA=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.20.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.20.1%2Bcu124-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-OgVeTpBAsSmHjVfDnbVfEX+XWJn/MN1wyPJiHZEXDb4=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.20.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.20.1%2Bcu124-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-pffrXvIvNKfRj8vCe2wB993lzVMN8xHNvdMRafkcvZg=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.20.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.20.1%2Bcu124-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-0QU+xQVFSefawmE7FRv/4yPzySSTnSlt9NfTSSWq860=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.20.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-LNWEBpeLgTGIz06RNbIYd1tX4LuG1KiPAzmHS4oiSBk=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.20.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-SHj++5bvKT0GwnIQkYrcg8OZ2fqvNM2lpj4Sn3cjKPE=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.20.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-NEsznhXmu7We4HAHcmFtCv79IJkgx2KxYENo2MNFgyI=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.20.1-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.1-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-GjElb/lF1k8Aa7MGgTp8laUx/ha/slNcg33UwQRTPXo=";
    };
    aarch64-linux-39 = {
      name = "torchvision-0.20.1-cp39-cp39-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.1-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-q8uABd6Nw5Pb0TEOy2adxoq2ZLkQevbWmKY0HR0/LDw=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.20.1-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.1-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-dfik1RpZPEurbJv311vdiGkbAKU7B2VmeLxVo6dT3XM=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.20.1-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.1-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-pA12Y0WSdjnaMixpOTTl+RsboiGIRscQS4aN6iMUzo4=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.20.1-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.20.1-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-n4U7pEl6xGkYFa1BtSPuI89bpPh7HOhp1wQFLiM8qLc=";
    };
  };
}
