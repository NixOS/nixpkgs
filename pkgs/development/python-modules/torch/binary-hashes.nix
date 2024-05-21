# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.3.0" = {
    x86_64-linux-38 = {
      name = "torch-2.3.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.3.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-lZi5WfVk7j6+NgOwugHSQXTKgBb+ypgQTwMB8UkGF8o=";
    };
    x86_64-linux-39 = {
      name = "torch-2.3.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.3.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-PMFeTCaCqFUYEhogUNa+eXbZj8SEO7wTtvW+4nWhtu4=";
    };
    x86_64-linux-310 = {
      name = "torch-2.3.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.3.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-ChKqmqa8RC3/iCOsi0jZkf0HcVYuqjhZP5yBltZfcAc=";
    };
    x86_64-linux-311 = {
      name = "torch-2.3.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.3.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-XffjyzlhAYqJHk7e8eC8HzMEqNlD+BskqMa/aHykmmc=";
    };
    x86_64-linux-312 = {
      name = "torch-2.3.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.3.0%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-8VtvVJ7rxuayKyZ1Tk8dfkRpvNLUuh6qtXJorYC8ypY=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.3.0-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.0-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-aun2SwlRa6pO+JCvBnLcmBwgsfDYKc4RXUQgokfoj7o=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.3.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-dg+L7f9QbOnm4QNJj5senhWAngCDaFlMOma/dKilE4A=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.3.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-dY75ON6HomU7unS5H3A0WMFVafFWK/S2xjxi2cWgwfU=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.3.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-0k4ygibY4q98+A/LHS8dEI4N4yd3+rSqorN7l2XYvnM=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.3.0-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.0-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-3KmGIUJns0Blp5AAzuVCMuYrQd/x7Cyrmrw/yLPe4K0=";
    };
    aarch64-linux-38 = {
      name = "torch-2.3.0-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.0-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-RunxqfQgKcBuY/v5yXE0PYsqCIZyO8T/McZ6m3pHNXM=";
    };
    aarch64-linux-39 = {
      name = "torch-2.3.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.0-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-N7zdkm811ccvGm0oIpczJEuyZTqPp3nEwQ3ZfjMNa6I=";
    };
    aarch64-linux-310 = {
      name = "torch-2.3.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.0-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-fiTBOMO6zIxRHGuCEfCcO/VH08vjdWMhrOwb3OQP7Gs=";
    };
    aarch64-linux-311 = {
      name = "torch-2.3.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-FHmS068B4/KncqaId+iTeYnlfEIluCpJidPNlYLIvNE=";
    };
    aarch64-linux-312 = {
      name = "torch-2.3.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.0-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-bhOCYa8GzZAqgmUmCCreU0tmCTudj2/y1AHOQ5qiNQw=";
    };
  };
}
