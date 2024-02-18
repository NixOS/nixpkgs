# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.17.0" = {
    x86_64-linux-38 = {
      name = "torchvision-0.17.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-3l28SA/MEAeS46rPkO3/5bzuTO06vE/B0hDSNH/DbgU=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.17.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-v1BQa1hwhI5c8KV+ZSa50Az058aZKUkbqR+5/DhKvDg=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.17.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-4Sc+mGL8gh/rxMcW8ThJsf+ofA1p9quCQ1bFUyxJDwg=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.17.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-/WbJVU/BRIYzwjLu3cvZCpvNE1rpTmgvTLchmEl0yps=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.17.0-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.0-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-hw182ldCDkTSDrB7/je/U0SgZDSnphlbTH891Vg4WH0=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.17.0-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.0-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-sc7UOLge9mKnHIyB3rrwyARVs1uBHKVaTDxZPXIbVgo=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.17.0-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.0-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-FTiCzY/449vvXFBU/dFd9k6FQgVGgFqQwLIiHy8RnEo=";
    };
    x86_64-darwin-311 = {
      name = "torchvision-0.17.0-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.0-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-ENJ2gh8RX7Np5s8fG3eyzKYM2hLLs5pBUTqdPQ8qk64=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.17.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-R39uZKnXmMD1re/DAKzCINpvF+9cHhENIBCPZlVP7k0=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.17.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-tTVpxSvUvRF2oeSdjqVYg7z1fhYUy5fi6M43J2gpm3A=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.17.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-xVwvhuPzoh3dknOalyNmJE6bF5Fug27EcWewoMCDxl8=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.17.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-o+7y2t2ttcIegC4FUN1+PuPZjEMPSu0hKuO6A1hVi+E=";
    };
  };
}
