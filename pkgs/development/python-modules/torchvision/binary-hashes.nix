# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.27.1" = {
    x86_64-linux-310 = {
      name = "torchvision-0.27.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.27.1%2Bcu130-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-RtNxOnPEU70t8DM0DAWkz0Rh1v25IUMm6GAJGDT9oMo=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.27.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.27.1%2Bcu130-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-VRS3+oog7QcwEHsQi/Lpb8iIEOsIMJRua7U9aF4SnU4=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.27.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.27.1%2Bcu130-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-q7/HJFl8FtoXcAKhaXmqjETEiYyXvLcxtkfMV1B/V3I=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.27.1-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.27.1%2Bcu130-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-+fAI1LGy8BPq977Bqf8iEmNYHXdmjU4eDpw+01HVZGU=";
    };
    x86_64-linux-314 = {
      name = "torchvision-0.27.1-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.27.1%2Bcu130-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-xS179F2vZqghkWYOf4VSB0bCca097xQXzngnlnT+Q6A=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.27.1-cp310-cp310-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.1-cp310-cp310-macosx_14_0_arm64.whl";
      hash = "sha256-aLpjtIr5LwbbmVrbI9hBGZPbod7nBaTpJBG4OgCTC38=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.27.1-cp311-cp311-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.1-cp311-cp311-macosx_14_0_arm64.whl";
      hash = "sha256-rYdDqcEsjBJK0KFJHlTDygx0npHjdOPZITYGCyLJ4PQ=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.27.1-cp312-cp312-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.1-cp312-cp312-macosx_14_0_arm64.whl";
      hash = "sha256-RIq/w7q6mE2kV39zcgnkRdpr6T47X0eZ2QFiv2Hj9IU=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.27.1-cp313-cp313-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.1-cp313-cp313-macosx_14_0_arm64.whl";
      hash = "sha256-1gMRptCN+QX5ZWo6MS8Kj1Xw1GMhvHN7rTCo3slkQwk=";
    };
    aarch64-darwin-314 = {
      name = "torchvision-0.27.1-cp314-cp314-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.1-cp314-cp314-macosx_14_0_arm64.whl";
      hash = "sha256-n171mtYOaVeW7Ka2TpfLmyG51UY8rFrA74bPtytuXbk=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.27.1-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.1%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-MyPtuQDKRtKduiZ+6AnlX+X+Cc09n1QSSnxe0zpqLb4=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.27.1-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.1%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-P6NBdGcak08Wb5UnrLd4ctjKFs1ewh76o4VkYDPgUG4=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.27.1-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.1%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-Y3g4M4sGCC8h/T9A1Lxw+H+MtcQXUwx06J2COVKAS8c=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.27.1-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.1%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-fV0JoOmEQREdAm6pJMIC43UtYkJbhLB2jZjAuwdHR/8=";
    };
    aarch64-linux-314 = {
      name = "torchvision-0.27.1-cp314-cp314-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.27.1%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-KQ67FCiA38qh/uw7RI3NPHBMLwORIyoe7Z7/XqXGWzU=";
    };
  };
}
