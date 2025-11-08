# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.9.0" = {
    x86_64-linux-310 = {
      name = "torchaudio-2.9.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.9.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-LZJPa5GaJYQe7bo6eSGzjjuri4ayzyOEHjMGM9wuxN8=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.9.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.9.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-sPBN7JEXd5pjd8VQHIb8BppCevACyF8IRpQ9aEu6LyM=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.9.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.9.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-/4OLMXG+bvTkVk4oFFM4FiQqbb6khRezcieFaHFpN2s=";
    };
    x86_64-linux-313 = {
      name = "torchaudio-2.9.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.9.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-6nanCKWpSlxsu/MinlhIMCaLR2X7Aa6CMPG2dEJTog8=";
    };
    x86_64-linux-314 = {
      name = "torchaudio-2.9.0-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.9.0%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-NnfCCwl7w1/DLspPPwon5rTT7nyKYuuiaj51SaOofWw=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.9.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-IU0ui+wrIErD9VLz3OrlFVDgapHFhj1dw0HYFpHvZV4=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.9.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-Zi60mrJeGitzZ7sHKorQXIpLZQ675wkKWvGh6x1Adnw=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.9.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-q0y8zP2HOw+0H8s5yYaeWe+Eu5Wwk/b1ji0FFyp1ANI=";
    };
    aarch64-darwin-313 = {
      name = "torchaudio-2.9.0-cp313-cp313-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.0-cp313-cp313-macosx_12_0_arm64.whl";
      hash = "sha256-VUnCXbTC2jBuF56aqZmA5/WxgmqNLX3ggSXzlDpWILI=";
    };
    aarch64-darwin-314 = {
      name = "torchaudio-2.9.0-cp314-cp314-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.0-cp314-cp314-macosx_11_0_arm64.whl";
      hash = "sha256-P6QUR6IRA/zekwtK0r0mNFZaC+z/GlQlU1tPARbA1d8=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.9.0-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-HoTkX3S/WyCLXOWbNvJuweX2NZZULD6+5u3q34XnNWM=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.9.0-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-kU8UCBQr3tocqfg03QSWdiX8zHWJO9FQSgGKE6BPG2Y=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.9.0-cp312-cp312-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-f5M4i25TbBTWAVtvdSd6i0XvxTL2GzWtwe0GyYqGAD4=";
    };
    aarch64-linux-313 = {
      name = "torchaudio-2.9.0-cp313-cp313-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-HrDR2sjO+8SlSvshqscqHCWpH3Ppw72F9mhJMKShvl0=";
    };
    aarch64-linux-314 = {
      name = "torchaudio-2.9.0-cp314-cp314-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.0-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-afRvIb1n6QreM6fQ8M+YJwzWG5j1+CSdOJO+Chaz4x8=";
    };
  };
}
