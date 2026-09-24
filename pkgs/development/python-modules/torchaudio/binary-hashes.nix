# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.11.0" = {
    x86_64-linux-310 = {
      name = "torchaudio-2.11.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.11.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-A0+64QMGG3RpTrGWOl6Rh0m8o8DpmK1b0FElvP6QMSI=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.11.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.11.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-ww4oVzu/6CsuiyFouId7+XgiWuI3iaEmMTBrrGUDPjo=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.11.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.11.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-eLhqF/Fkvaq9zuk/394lh/xDuevxXNYdz3MLT4YVF2s=";
    };
    x86_64-linux-313 = {
      name = "torchaudio-2.11.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.11.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-NDo1SLMpGt9VLNSgOp+UkNlsszZ6itktywuPAUNDLoA=";
    };
    x86_64-linux-314 = {
      name = "torchaudio-2.11.0-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.11.0%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-DTT3JLG6w4NUIOunhWpe/hJQJzW3BtuNNlXpJoCkOXM=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.11.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-brtZxpSQnsy11ht8wZnSl2kgEsQyhuNtkpg6p7rXWG0=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.11.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-SS3WRkXp0LuEPpTx2aTR4xQmJi/8WU+v7MFpffnfXrk=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.11.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-oc8azIg77py5BqkzVy/taoqTP4bvNOnqfYA/cjF+jBs=";
    };
    aarch64-darwin-313 = {
      name = "torchaudio-2.11.0-cp313-cp313-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.0-cp313-cp313-macosx_12_0_arm64.whl";
      hash = "sha256-4/lpap7x1JrMRSFZsFI3DGNkBtBy6djxCJX9qHtZHqk=";
    };
    aarch64-darwin-314 = {
      name = "torchaudio-2.11.0-cp314-cp314-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.0-cp314-cp314-macosx_12_0_arm64.whl";
      hash = "sha256-zAnNH2AVuFSef+JV+xvlNGtX5/7gZUHT89uwEtjEcV8=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.11.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-Qs45MDbKasUHImp6bPg74pyMClHD+3dUmPixVj9HY4c=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.11.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-el7N0g+ybY6x1iE13cbbD4BrF2Z8EOgt+RP9UJ0fXP4=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.11.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-ud0sasFEAB3G2sOLVkwd5zrCbvDBldUDfEqUmQsOK1o=";
    };
    aarch64-linux-313 = {
      name = "torchaudio-2.11.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-L6qNjyUdH6RIE3ZbAHkQSLYX6dwG5s2SIquoECOSkRk=";
    };
    aarch64-linux-314 = {
      name = "torchaudio-2.11.0-cp314-cp314-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-WR7YJ58BcO8okzhz9l6fX4xDkocIjvYoXNplmIsLphQ=";
    };
  };
}
