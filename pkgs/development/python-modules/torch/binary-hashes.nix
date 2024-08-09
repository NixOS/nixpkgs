# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.4.0" = {
    x86_64-linux-38 = {
      name = "torch-2.4.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.4.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-ikebcXQK+SpOG5kEW+qDHz2nMYfIw+PSErHm/jkxWyE=";
    };
    x86_64-linux-39 = {
      name = "torch-2.4.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.4.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-iIObriuWfdOFeaqwu6lRDpKxHau8Th3V5jDF/WVfXac=";
    };
    x86_64-linux-310 = {
      name = "torch-2.4.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.4.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-KL+6CE3KUqBsRl160PPMNyw1/FA/PquIHMF6X9gpFOc=";
    };
    x86_64-linux-311 = {
      name = "torch-2.4.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.4.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-qf/zLTZeDHS2kJSAVIsuKRMUogStsptrtvLG0z+L4mw=";
    };
    x86_64-linux-312 = {
      name = "torch-2.4.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.4.0%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-SaxVpkl93W0M3VG16ifY6+IMknMHeFXpyW6w3CifB8M=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.4.0-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.0-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-OvTeKmGPsGXnhATEuieoGKe3lX6u/yjGxmzn+1BLaLg=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.4.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-iUD8i5ekxh/bXUajaPIfSjpWKheHnpMutRpexiMQyzE=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.4.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-aFQYq5NzDvvucVKIIf9UAFWWlw3Ul78DyJIE+34/cd4=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.4.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-8Wm06m3JOzozMZYR/MR9wUBuTdU5hE3L0t7EwbluFm0=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.4.0-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.0-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-karwC/4f+kTcW1KAnZqVEp/KECEuyjrCZCDrEXJ8Yog=";
    };
    aarch64-linux-38 = {
      name = "torch-2.4.0-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.0-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-nrqD+Kj5hUL5F+OQAMkD8VRlWs9jdcBzz81DBqFU64A=";
    };
    aarch64-linux-39 = {
      name = "torch-2.4.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-J4akfI2N7BdvxnnSqrmm9UnCVFJRC0llCrE0E1JmujM=";
    };
    aarch64-linux-310 = {
      name = "torch-2.4.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-fBWeidTs8IQD+dE3PVVEIiQLmxFGoKGRKQadw1enKys=";
    };
    aarch64-linux-311 = {
      name = "torch-2.4.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-OBacsPHmcnw9rI2si5pI0HKkn2Q7kIqZFV7x2Bthves=";
    };
    aarch64-linux-312 = {
      name = "torch-2.4.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-7IY1E1C716vqNDb6b0Iws7C793oibkS6RhhA4gT8zXE=";
    };
  };
}
