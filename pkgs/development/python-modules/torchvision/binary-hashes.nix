# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.24.1" = {
    x86_64-linux-310 = {
      name = "torchvision-0.24.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.24.1%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-h/bjLS2Y0nefn6WKqTz2rwSeP4doE0SiCI4vx9ndPgA=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.24.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.24.1%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-G0T2fL2PNuKli/qjF201s331VgSt9ZKeiQBuUx+En6o=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.24.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.24.1%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-z4Tq4dLRKn0mGnSW7KAN2Se3F5IBGx6E1BYslQ6zIB0=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.24.1-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.24.1%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-X3xeD6CNLL7pO24Eu+3Vm14RRiz/bO/QeUkhcmXfI3A=";
    };
    x86_64-linux-314 = {
      name = "torchvision-0.24.1-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.24.1%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-O3LjI3fl6ROY3cRXnHd4SyaWUqV5X0sgpaHUyA6b090=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.24.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-62yB50mCzCWBhdmHAG7Xg1xuWJNSfuKBKUyFovP3JYo=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.24.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-c0gffA2jjsGgQCHy2WcoLIfaSKL4MyvpYAkWcs/+gGs=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.24.1-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.1-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-TwlWglurWTLdUzlN6OEQXtkYJQKzZ/8Eddvw5plVBhI=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.24.1-cp313-cp313-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.1-cp313-cp313-macosx_12_0_arm64.whl";
      hash = "sha256-yFj5RO/qIXCsvaL4AWE7FRk75J6EGcmMIE6fXoxlqVU=";
    };
    aarch64-darwin-314 = {
      name = "torchvision-0.24.1-cp314-cp314-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.1-cp314-cp314-macosx_11_0_arm64.whl";
      hash = "sha256-mDmEiv9H2Y53JKvRowdhIduWBmwy3bMZtoXf4Hc2D0A=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.24.1-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.1-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-VnnMvWaaiLq5ghwyI00kBzXTZJkpGIfyYqSS8Nlti4I=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.24.1-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.1-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-RScwj/tX9tLBfoLuCOJb+9CkHxN99tDqiAWyPvKvDms=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.24.1-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.1-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-KBV2SXWPuXSR3g20eNXW5zwjtQjlTeIK28NeazqnJEM=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.24.1-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.1-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-Wd2+V3mUOvmaiX/NWJR1eufP/rHCWlGbec2TOBiKhmQ=";
    };
    aarch64-linux-314 = {
      name = "torchvision-0.24.1-cp314-cp314-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.24.1-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-MqXOmewggf1aswTaCqlpG27AR9EqMpwNmRxp0KG+7kU=";
    };
  };
}
