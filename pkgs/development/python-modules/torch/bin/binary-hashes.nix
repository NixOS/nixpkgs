# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.10.0" = {
    x86_64-linux-310 = {
      name = "torch-2.10.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.10.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-NjaFB7VuqlGsvTyWrIiTu5qGmR/80Gmf6joadKK4vcs=";
    };
    x86_64-linux-311 = {
      name = "torch-2.10.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.10.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-HQH/rr9kcVwPUHo5RjFJyxnllv9wK9S8+GJgHyiB2rw=";
    };
    x86_64-linux-312 = {
      name = "torch-2.10.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.10.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-Yo6JvVEQztfevuKlfGmVlyW3+8ZOq4GjndcORsfii6U=";
    };
    x86_64-linux-313 = {
      name = "torch-2.10.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.10.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-e0vSPtY96XRW/MgcJv6p8C7gLOERIRHE2sDYz+V0sj4=";
    };
    x86_64-linux-314 = {
      name = "torch-2.10.0-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.10.0%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-N9cf7qBod2hVaGoVEgWN8/GfbwQKFR8FWqdGYBZ4dE8=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.10.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.10.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-LRar/ObJJYTO6wDDsmZdV5hCTdntI16mm3LgRc1Trpc=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.10.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.10.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-RYSrFnmVwEefaCHj3OrxmcgWbIEdOtu6XY7tu/pnZP0=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.10.0-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.10.0-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-RaHFBXYpRErrHEUsGCmPp/MPL3rq3U3EH500CYApRAc=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.10.0-cp313-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.10.0-cp313-none-macosx_11_0_arm64.whl";
      hash = "sha256-hANR2lnO23vLxRmBiABQgTwZ72uJin/s9zo6/HGv8/4=";
    };
    aarch64-darwin-314 = {
      name = "torch-2.10.0-cp314-cp314-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.10.0-cp314-cp314-macosx_14_0_arm64.whl";
      hash = "sha256-yIsRKf1OFPD4gpY8ZygxXKrjXS9HN00X7e7R7cdpdJc=";
    };
    aarch64-linux-310 = {
      name = "torch-2.10.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.10.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-1j7mqAmC/XP+RLtw2X0pduAQMS/224HXv7kWewbdRbk=";
    };
    aarch64-linux-311 = {
      name = "torch-2.10.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.10.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-HPy5sVWMblLf/Q1O/86DsTxa5dlzOBZMNyBIwh+c/Ms=";
    };
    aarch64-linux-312 = {
      name = "torch-2.10.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.10.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-F5RRcWSH+MsJtWRZZn+h9cTAlGwedfvq53z8QKV2jYc=";
    };
    aarch64-linux-313 = {
      name = "torch-2.10.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.10.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-5RmUSSzbdu3OKdqI3jZyowIvnvD/2QNFQ2lI1Jkr4sc=";
    };
    aarch64-linux-314 = {
      name = "torch-2.10.0-cp314-cp314-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.10.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-oo/bz6L7rP/sgTAPJN0b7SsMz9vtEHqCPP8SvB2wcPY=";
    };
  };
}
