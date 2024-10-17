# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.5.0" = {
    x86_64-linux-39 = {
      name = "torch-2.5.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.5.0%2Bcu124-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-Z3RdahkVnJ436sN6HAicTZ9ZTNcsIV2mFN9A/OEw3Sc=";
    };
    x86_64-linux-310 = {
      name = "torch-2.5.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.5.0%2Bcu124-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-uLcj9Hqgb9/rGnqsXf+PpZlL+qT9PK0GAbvw1bHBUEk=";
    };
    x86_64-linux-311 = {
      name = "torch-2.5.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.5.0%2Bcu124-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-Xj9Ke6gSUXwsFlmFe1GV8oeiiPvQUKWr+TEeA9vhoos=";
    };
    x86_64-linux-312 = {
      name = "torch-2.5.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.5.0%2Bcu124-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-EcKB2WiMNu3tBq6PYNa5fgEIMe+upKSyJErUNn4jLtc=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.5.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-7YScLRFY+FkflMFEeO4cPeq8H0OKAD1VwFdGJMAWJ/E=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.5.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-uK9pC351HUG9Je8uqkauNUqngTgOHk006wMb+oP0tRI=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.5.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-2nchfs0y5UxiSXmVR+7aEF67qow8dFtZGlMg4rwkNYU=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.5.0-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.0-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-w6vjoAPA1XgGUi9z1euXdmg2onTYCcnKPrPnXSSIvz4=";
    };
    aarch64-linux-39 = {
      name = "torch-2.5.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-5CMassS3SgvmnicQ4/kRAs55yuCeb7saYe9yRsUHA+Q=";
    };
    aarch64-linux-310 = {
      name = "torch-2.5.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-UPz/n1ucUQL5+PXLPRK9TZ8SZmUOS4wU9QpexYnh7qU=";
    };
    aarch64-linux-311 = {
      name = "torch-2.5.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-IFoOy/hfTHhXz99Paw4HMWvZKe2SSCVp6PRSRABVmIQ=";
    };
    aarch64-linux-312 = {
      name = "torch-2.5.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-V+B/GKTe9Sz+UETKqGG8PeRJcXn67iNvO5V7Qn/80OQ=";
    };
  };
}
