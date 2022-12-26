# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "1.13.1" = {
    x86_64-linux-37 = {
      name = "torch-1.13.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torch-1.13.1%2Bcu116-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-INfG4AgEtr6m9pt3JAxPzfJEzOL2sf9zvv98DfZVPZ0=";
    };
    x86_64-linux-38 = {
      name = "torch-1.13.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torch-1.13.1%2Bcu116-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-kzj6oKWg62JeF+OXKfBvsKV0CY16uI2Fa72ky3agtmU=";
    };
    x86_64-linux-39 = {
      name = "torch-1.13.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torch-1.13.1%2Bcu116-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-20V6gi1zYBO2/+UJBTABvJGL3Xj+aJZ7YF9TmEqa+sU=";
    };
    x86_64-linux-310 = {
      name = "torch-1.13.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torch-1.13.1%2Bcu116-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-UdWHDN8FtiCLHHOf4LpRG5d+yjf5UHgpZ1WWrMEbbKQ=";
    };
    x86_64-darwin-37 = {
      name = "torch-1.13.1-cp37-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.1-cp37-none-macosx_10_9_x86_64.whl";
      hash = "sha256-DZuAYQSM+3jmdbnS6oUDv+MNtD1YNZmuhiaxJjoME4A=";
    };
    x86_64-darwin-38 = {
      name = "torch-1.13.1-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.1-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-M+Z+6lJuC7uRUSY+ZUF6nvLY+lPL5ijocxAGDJ3PoxI=";
    };
    x86_64-darwin-39 = {
      name = "torch-1.13.1-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.1-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-aTB5HvqHV8tpdK9z1Jlra1DFkogqMkuPsFicapui3a8=";
    };
    x86_64-darwin-310 = {
      name = "torch-1.13.1-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.1-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-OTpic8gy4EdYEGP7dDNf9QtMVmIXAZzGrOMYzXnrBWY=";
    };
    aarch64-darwin-38 = {
      name = "torch-1.13.1-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.1-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-7usgTTD9QK9qLYCHm0an77489Dzb64g43U89EmzJCys=";
    };
    aarch64-darwin-39 = {
      name = "torch-1.13.1-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.1-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-4N+QKnx91seVaYUy7llwzomGcmJWNdiF6t6ZduWgSUk=";
    };
    aarch64-darwin-310 = {
      name = "torch-1.13.1-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.13.1-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-ASKAaxEblJ0h+hpfl2TR/S/MSkfLf4/5FCBP1Px1LtU=";
    };

  };
}
