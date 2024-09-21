# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.19.0" = {
    x86_64-linux-38 = {
      name = "torchvision-0.19.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.19.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-5GynSUL5Of12jXr29wqhfAciLKj6abBXtAi05u29bys=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.19.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.19.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-R2KGR72zWQyauWXvtwhTMA1eHGh1lRHumUpvH5fywSM=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.19.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.19.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-XuEDx+tH+LCIN+DkixePfsyR12nSthJAuQy1qi0Gznc=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.19.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.19.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-NpTVJ7SPribGrEpDWWC4tXk9YcXxQgtr77lLM8mm/Ng=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.19.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.19.0%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-9M7FuSc1N6VG5V6eCI++01kM+2kn+IFX1K/s7iPBJek=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.19.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-hU6WehapQJ6UG1u+WqNXsj9xWLzLneNa4g/UlF8F7NE=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.19.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-3RJ5Vx1LaNWlPZt6Na7fkcTLHgsICZ9qHv+nsluMlec=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.19.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-7IdO+F3LJMaeYA9uJ2r4ksgM3j/9rrcnXv2kYyQrwqg=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.19.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-2/OqcaOJkkT8iEMD7TxGBKFggk/vrHfoIxelRj78HZs=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.19.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-wJ747RhPqHf2JRtiAibnT2grjx1rNBRWQo1JVbjZxnA=";
    };
    aarch64-linux-38 = {
      name = "torchvision-0.19.0-cp38-cp38-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.0-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-B5ppbgsstS5L4wr6jps9fSgPAqK1/+3X6CH6Hv0aWo0=";
    };
    aarch64-linux-39 = {
      name = "torchvision-0.19.0-cp39-cp39-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.0-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-X5pZjc+CvfyORDbOdHY7OHfavsOzP5RhO5Tt4T4+Te4=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.19.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.0-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-1GfUNABf0Foieiunr0xZG7Z+bUqXu9Bu2o2oP0Pp/Qc=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.19.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.0-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-Tmqk+j8Lw1mfoHHBSeZRo+a91nyRYXlEePn5FHHEBqI=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.19.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.0-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-vg8noouOnyrpijGvNKS90qW/FU2SvXOleXyNIVb7OrY=";
    };
  };
}
