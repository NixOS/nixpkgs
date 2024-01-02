# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.16.1" = {
    x86_64-linux-38 = {
      name = "torchvision-0.16.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-xPO1sRtw2yyLBlrp3kduqc6yrVc8fFgGi+CXWkABgrQ=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.16.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-1voLyIMnBZI9kBleyb819IhwW0nAFEizcCy3t9ebVPk=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.16.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-AglL7N9dxCpq/iGQ4ayz8y3ZwtOt2Cfd/pG1RMwjrfQ=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.16.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.16.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-tO7B2cBOsDa05yrqX0OuM8BkFNqdNjkb0E/9Ma2C+6k=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.16.1-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.1-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-TyytYh+5bPEOKa+T4WyYsyJr3VOucStX6HPD3q8GFhc=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.16.1-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.1-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-8U0gHDcXbcQQbux2sinWWFoVBSZrjOqZ0zZv04iXt8A=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.16.1-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.1-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-mHEyeV5cA3y3TnvjWmk5mf2y9gMVImbuFbgCBug6Www=";
    };
    x86_64-darwin-311 = {
      name = "torchvision-0.16.1-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.1-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-Supc9JHGwhscvbsb8qODilnU25OtX0kBmmVk08pxJ8c=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.16.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-HWFLPJ4t6c11zA5OGSP8+7zZ/bnwigu7v34TXkoKHPo=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.16.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-oV6IqTp1Acx1t2Gi3NB6rtqvnL+vSMiv+oyYmJ7LsZ0=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.16.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-JdpqeyLqA0j2LEXsDa8VdzEJa6vK5l0iJAQIGvluCFw=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.16.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.16.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-M5F1cWdjes4+8zpnydXvhrH4y9k+qlutRe688mbqYIk=";
    };
  };
}
