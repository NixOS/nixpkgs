# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.4.1" = {
    x86_64-linux-38 = {
      name = "torch-2.4.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.4.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-y09QL5ELR+HjZsz3sjHawpZ9LvtH1LjLM/xjtLxe7tg=";
    };
    x86_64-linux-39 = {
      name = "torch-2.4.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.4.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-mYatNVXd//Vekl2CmPiytJEGp9xg+BGiB2pEX+RFjis=";
    };
    x86_64-linux-310 = {
      name = "torch-2.4.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.4.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-ml8LEDz+hAs1aEFqpQZ/bnuf7GfZxWWf1DsSB0UP6XU=";
    };
    x86_64-linux-311 = {
      name = "torch-2.4.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.4.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-kU0Sjlq8u+ecobnrUxGxhURPGy1xF99VX+QYSH7PuJQ=";
    };
    x86_64-linux-312 = {
      name = "torch-2.4.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.4.1%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-q0kWELFVUeCNp0urKdCTPmvxC6tE+31LEyjx6EXAWlM=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.4.1-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.1-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-X8HU1+0mXvhTV5yvJyaG0e2Hzr3NBPKkmPgA/8U9q3E=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.4.1-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.1-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-o43igD7mBQMJqsAyZ2U2w9O2qYBCSFN+OOCY0OFIF+w=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.4.1-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.1-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-02qO8QD1v/Ppw86pNLng1+onfLghDHFS00qabFgw6t0=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.4.1-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.1-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-3d29iwZudDk0pCALPVQmekbbAhBodtIc8x99p6lvmOo=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.4.1-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.1-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-crSE1bbOwac1vz+locSIPQF0hpjF6c/b60/6t8eYfg0=";
    };
    aarch64-linux-38 = {
      name = "torch-2.4.1-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.1-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-Vq0qdgt6eIJyWh7r9WV6u7O1FE6ya8tHtSBZNXRjxUg=";
    };
    aarch64-linux-39 = {
      name = "torch-2.4.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-FJUTLzD3Iq8aCRlQCIuuo4P+OZA9sGsg5pNv2ZQCgD4=";
    };
    aarch64-linux-310 = {
      name = "torch-2.4.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-+iewSNMhmM2m6c/wv3aOhoPZh0OQO35dKx9QmN7R00M=";
    };
    aarch64-linux-311 = {
      name = "torch-2.4.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-ML4oRNDJORYaEQc7+69kXxx8tD9i9GzG5N8cEZ+yp5g=";
    };
    aarch64-linux-312 = {
      name = "torch-2.4.1-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.4.1-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-NhCUMrEL1xY8mzDOiW88LMobhrl2X5VqFZTw/0MJHio=";
    };
  };
}
