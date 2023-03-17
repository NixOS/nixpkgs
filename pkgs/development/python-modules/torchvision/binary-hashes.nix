# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.15.1" = {
    x86_64-linux-38 = {
      name = "torchvision-0.15.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchvision-0.15.1%2Bcu118-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-kQRzDWVavygsKEXUzUcrsIk288hQg6KK79dq2e6v8mE=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.15.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchvision-0.15.1%2Bcu118-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-Xs4nnI9SH49jc7+XHyrcY6lh1pTErO1TjfgSlCEO5Lo=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.15.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchvision-0.15.1%2Bcu118-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-mmefo3p0EBjIBCNGk7usPUh/s91V7nP2szZ3sXfIwHo=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.15.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchvision-0.15.1%2Bcu118-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-nO0skO54K7tBWw3mW8wQ1P6BETGGRnm3B0QsnZ6Kqv0=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.15.1-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.1-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-5YYbqu6ofRm2/X0THhGkpr0XvhQjTEkKJZuzYHdelSA=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.15.1-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.1-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-Hf3sfH35ZzMLujNBp4HgwEfU4BY+ZxZKmRhQA2K/fZE=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.15.1-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.1-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-vBDUjppg0AbQwbSN6ofx7Jtj2FZzfVkvfFxEzYfz9Lc=";
    };
    x86_64-darwin-311 = {
      name = "torchvision-0.15.1-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.1-cp311-cp311-macosx_10_9_x86_64.whl";
      hash = "sha256-l7kOs7czOjHQScTM/RBkNh6EkYdJWdOPRmr2TWdBjO8=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.15.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-5xTzYrnYIXz01oUJtnnryd3xKM/oD2wd744/ihhGbnU=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.15.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-wVNxAYbOwDONT/9BFFmlfdvIUEQ2EjynOz8L3Cb/kYw=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.15.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-NwjTQQ/cr2KA41jNqd4qSrBswLTA/ZrurFUOwlY6iH4=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.15.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-a2DhyDmuKgcb77ummxdGjWf+r99XbpD/lkW/vumY3hc=";
    };
  };
}
