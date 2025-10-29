# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.24.0" = {
    x86_64-linux-310 = {
      name = "torchvision-0.24.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.24.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-DZ17Fyc69ZN0A/pTqlmIbNHa9b1q6kLkw8u6RU+i6+0=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.24.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.24.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-ivmUrFaGj5OfsTFOuZ9SgpUcmhKq40ud3gCnjkLlnSE=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.24.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.24.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-5QW9g+4Q7blFI9C4BaCPULiGK1jSzG8C0UzU5++TArw=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.24.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.24.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-1ZT2EmnKsFJKHm9fnn5csm5OC+2LoFn2T9Ss33zXbVM=";
    };
    x86_64-linux-314 = {
      name = "torchvision-0.24.0-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.24.0%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-DkhdmHoWBslCo+SoZ83T93mR3bW1Ybrgj3AxS3CTozE=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.24.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-Xo1eZn3v+HvWbSbfbSJfRiJLsHgtTz+PXS8waLX9RJI=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.24.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-93HPkYNRrVCaKEiL5HXz6cxxp1DWsUZ4Qr+2SGOl6YY=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.24.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-xh1AvNLiRR6TKQKnAq1JW6HsbyeekLHhXO8rtV3JEeI=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.24.0-cp313-cp313-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.0-cp313-cp313-macosx_12_0_arm64.whl";
      hash = "sha256-hNec/GRXMQEHzk1xLeej04iyRIS8mu3tSnbY+OOigT0=";
    };
    aarch64-darwin-314 = {
      name = "torchvision-0.24.0-cp314-cp314-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.0-cp314-cp314-macosx_11_0_arm64.whl";
      hash = "sha256-S9/IWl7XBkIVVfMs3F49221Av2XvA6J0zjwXY5PikEs=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.24.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-oRClHHXomAeoOCsNgDT14YD7kxlXC+M4n/09SsT9V6k=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.24.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-u9Y79Ov/hMSMUBI+upBSbMn3lP5FvJ9d0HzsGejGK84=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.24.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-sFMdFIP8Mi19oNg75S8N+GCnURSrh9vuud52X+rtqEM=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.24.0-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-/sEqJpz4D2sLcUccjUmM073Z2OiSxCW/Of7LYEhSw7A=";
    };
    aarch64-linux-314 = {
      name = "torchvision-0.24.0-cp314-cp314-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.0-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-c1dqnEpZMiP7roWmTou9dwSavREBiT7PPF6YEoT9WLQ=";
    };
  };
}
