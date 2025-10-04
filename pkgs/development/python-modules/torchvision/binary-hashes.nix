# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.23.0" = {
    x86_64-linux-39 = {
      name = "torchvision-0.23.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.23.0%2Bcu128-cp39-cp39-manylinux_2_28_x86_64.whl";
      hash = "sha256-eE/JDLlw5aKbJLZEHkYfW/YWhGMFuXk/o4cKnyltTA4=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.23.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.23.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-RgvI1w9jvbQzpzUd7MLBrhkD9/N45KdhT8joyXpcNqo=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.23.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.23.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-k/G19WsgzWhpvKQJQ95P08qczFbhtX9HxnHeHNqznNs=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.23.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.23.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-nLPBOZevy0QFfKENlDxsTLowaK/eDzcJZavOnIn8/6k=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.23.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.23.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-xjmC8Zc7pnezfmZj3w4Hy1OBRZtvBXLCypXuvY3+t0I=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.23.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.23.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-sZDbIF+QIGwjD8L5HL39VzMzS6vA4NGb3bkKQLjPJsI=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.23.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.23.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-cmaHHaygCtRtHAc+VdlyF50SpY+lya3smj25u+1xKEo=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.23.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.23.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-Saog4h8MK9RYxx17RJd2y9XxZpPdWAcZWoIGEriiKbc=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.23.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.23.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-4OLASpFAPo3Tr5dWxqAkodnA7ZwNWSqDFN7Y9P4w1EA=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.23.0-cp313-cp313-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.23.0-cp313-cp313-macosx_11_0_arm64.whl";
      hash = "sha256-HDfjJeCaGEtzDD71FCTzg+xXRTeNwOyiRFIKyilyJgA=";
    };
    aarch64-linux-39 = {
      name = "torchvision-0.23.0-cp39-cp39-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.23.0-cp39-cp39-manylinux_2_28_aarch64.whl";
      hash = "sha256-bHTLwcvuJt1PNfmJzYDczEBBHyWN7kdrKYcd7ktIOvA=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.23.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.23.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-McWDuidCajoE7KjAVFBSQQXBVk20G+ZjL3U270BabeI=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.23.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.23.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-Adwz7iTHkUiu582880roo8naFnSlkeeBV3txbSM7H6Y=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.23.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.23.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-bdfE0ymg4DFXgDAxvIViIMYVXvCMJtT1u6yTis7PCUg=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.23.0-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.23.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-L3/WwV82l+gGJ7d5NPd3BfO8Dpgni5ibJlXeAfaQPh0=";
    };
  };
}
