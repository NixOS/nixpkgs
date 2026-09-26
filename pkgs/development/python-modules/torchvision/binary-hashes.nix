# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.28.0" = {
    x86_64-linux-310 = {
      name = "torchvision-0.28.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.28.0%2Bcu130-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-GcLRi7yMOxpmbw1B+R2PYk+RL6/61CE3EGHd3aUrqOo=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.28.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.28.0%2Bcu130-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-Z4k89PtKznPaYJaGN7Hra72MsyJplfEjIuwAQfuumKE=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.28.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.28.0%2Bcu130-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-igAI00zMToEGa5f/CuWjTGdr/fNGS69AwBsyDcmkXOA=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.28.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.28.0%2Bcu130-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-+jwfh/hmZ1YjgOPORn4AA3H6iK3vrsclErOdECGi9YE=";
    };
    x86_64-linux-314 = {
      name = "torchvision-0.28.0-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu130/torchvision-0.28.0%2Bcu130-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-RV66sGSBmOBryBc5VprZtOpsj6bNncVFmBUsbOYoXc0=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.28.0-cp310-cp310-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.28.0-cp310-cp310-macosx_14_0_arm64.whl";
      hash = "sha256-Kh70tvS/WCi0jPrZc3LImC25BoMIhLKGi6XD35N6fYE=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.28.0-cp311-cp311-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.28.0-cp311-cp311-macosx_14_0_arm64.whl";
      hash = "sha256-g/5sAghmqFrNfZfezMRf8R1m2vQpFtBDlqQwnGbAzLg=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.28.0-cp312-cp312-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.28.0-cp312-cp312-macosx_14_0_arm64.whl";
      hash = "sha256-6fVMMM1S4+9/0DTMabe7fglk4cj4dD4BirkulbQPnu4=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.28.0-cp313-cp313-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.28.0-cp313-cp313-macosx_14_0_arm64.whl";
      hash = "sha256-1IO0qj9SN1aQU/dJzRorW7VIykVuQEYaXdCH8hFJ0SM=";
    };
    aarch64-darwin-314 = {
      name = "torchvision-0.28.0-cp314-cp314-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.28.0-cp314-cp314-macosx_14_0_arm64.whl";
      hash = "sha256-O9nbpVIkqdtKLXf2/qpWUXcNjI6G09DdsPpr7FTIcSs=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.28.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.28.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-fYHaKATaUsl4jy1ajQqt3Oqfzm6118bhmjK0C07Qt1o=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.28.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.28.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-IpWBk9ckRO18vMZlukghox5SefnE0a0IUgkYswiWt4o=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.28.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.28.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-L3aMT21a321VNQYf1p7ESCdgi6wOluEhFJQqb9/OEQc=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.28.0-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.28.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-h5rm1OLjZRWC+3GH6v1TVgHLXQGVldR+LIdCYqAA6I4=";
    };
    aarch64-linux-314 = {
      name = "torchvision-0.28.0-cp314-cp314-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.28.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-Ohp2yN7LHXu+3TWIvMyQ+yaZRLcyGnc9sYFzW0IRVCI=";
    };
  };
}
