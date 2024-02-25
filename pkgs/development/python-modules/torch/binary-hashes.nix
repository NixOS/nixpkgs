# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.2.1" = {
    x86_64-linux-38 = {
      name = "torch-2.2.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-OIDrgRsT+PGl/DKC5FVnS5qfpnOrJW8GOOK09JUlFsM=";
    };
    x86_64-linux-39 = {
      name = "torch-2.2.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-HLN5h0E455jAK0GWLdnU7AsGOoykWlEJfzJmFUd8m9A=";
    };
    x86_64-linux-310 = {
      name = "torch-2.2.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-Gt9DDwH/ZJyEisAheF4YAHsHFP3eaOTmW9DGQL8/uOE=";
    };
    x86_64-linux-311 = {
      name = "torch-2.2.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.2.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-I7souoAPJanTPVF2i/X976AiDLxc2aF/ItKkJig1lGg=";
    };
    x86_64-darwin-38 = {
      name = "torch-2.2.1-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-YXaFhegqmdxcQZM759ucoGf6451F/r1RA8yKBNUkSRg=";
    };
    x86_64-darwin-39 = {
      name = "torch-2.2.1-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-o6OqT5rSqLjnLBqElA2MWd1O7SkbyytgOta1hJgwYvU=";
    };
    x86_64-darwin-310 = {
      name = "torch-2.2.1-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-531ee2Cn4cI0XGSC/4dvNqDwQ+a+Mu9Y2sQWxKoOOyg=";
    };
    x86_64-darwin-311 = {
      name = "torch-2.2.1-cp311-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp311-none-macosx_10_9_x86_64.whl";
      hash = "sha256-lkeM9Oc3ADBZee0cp2tTVTbUYvMDAqNe3Rzu4MPYB9M=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.2.1-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-fX1aq00JspIgKXkbacgDq6HAWcYP9lYj8ddFgMFHvUw=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.2.1-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-uQZpsWKYTjAvvQXJwnDveW5GeQOUTs76dFe6vpYRYH4=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.2.1-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-Ur3sHiLQg4L9mNttK/F6KU0P1TJgz9ZPuHRDSSy6xrQ=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.2.1-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-zNmEmw3TcKmBPd3kenf0OciqzOAi5LoL+TZRc9WAgJY=";
    };
    aarch64-linux-38 = {
      name = "torch-2.2.1-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-y4ThL9QAXHh/zkDto96sBCmPWQY0iRBixM2yzywUIiE=";
    };
    aarch64-linux-39 = {
      name = "torch-2.2.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-7g90adoiGNyHlIV1DaF6JF3DaRbi+cX8CDbkz1cq0H0=";
    };
    aarch64-linux-310 = {
      name = "torch-2.2.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-8BgwAuGJeNWYw+6JGcLmSCAsf+u5CIFRVshmxSTEo1k=";
    };
    aarch64-linux-311 = {
      name = "torch-2.2.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.2.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-fyaXQWtneZbuHzCyZ2qKlN3b44ijXDYdyG6RW9pHt9o=";
    };
  };
}
