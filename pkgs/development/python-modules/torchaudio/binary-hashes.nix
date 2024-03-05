# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.2.1" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.2.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-XU/trqM3W8hQ+9kI6G1b+GAbp9eCPFId6+jY3lwiZYg=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.2.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-LQScsJsPn+EE0goKRwIW/Fzo+SW9SYVuZYDi2Vn1syg=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.2.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-I/YjZCniv2drgg6OciGh1YqvkIv/K6JmWqhS33GpeWE=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.2.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-YJACsObf9ED81qY9FcA8PTdOIU56iqYcLvSlKLpkTDk=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-2.2.1-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-ge+I12k+O5kAfR7nQv2Buakjmey/iOt+1plJRDAF/7o=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-2.2.1-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-Azn+eO2cKfcEKWdhsouwVbU1BiX/UDrXgXBDl5NOa1g=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-2.2.1-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-WA7v12SgGmTVtqomDAxHl0vmppZIktVAKac7F/RhH80=";
    };
    x86_64-darwin-311 = {
      name = "torchaudio-2.2.1-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-J0y4R0vB5Wt2jvNH0xiGYcWp1eaOLfVvwK/xHMc8kWo=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.2.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-9Ien0xd65q8BZ1CFDuk3iOiAIYoaMQvGx2kB4hL5HNM=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.2.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-aLHZ+P/psm7wToDYKuLcL3Sxoetkw+itIbUlgCs7x6w=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.2.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-itVcIGmye74Y4UeDogLj8/gIL+nlkoFDa6eX7bD8lNU=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.2.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-HmLCexdnLMK92WY2geUzAA+cCYTmoPPUVfcFG8AFuwI=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.2.1-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-pEYrPyFPYLa4944SpM8Skcm8NT3u1wmsPf3tvtUTp6M=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.2.1-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-yy2girt7aNx7AQV0ixpzbdMzKfhBN0AT7ALFTgS+3yk=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.2.1-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-uRa3dkaYupMZqjslUZE5iS3oZl2EQ4lpusXh2FeMahE=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.2.1-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.1-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-ILKWXbT4QwIWNvU9P6sQdcP4lZxFDGR2KRJNJMfmy7A=";
    };
  };
}
