# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.10.0" = {
    x86_64-linux-310 = {
      name = "torchaudio-2.10.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.10.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-cGW9EKtplNMGZ1aOjGSYeUZ4zh7iPS8HVvsozm1iNII=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.10.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.10.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-xQ7R9L9nQ6gvjmIe7REI/9ZsWBLQCp9pXHSfnOX+zeQ=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.10.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.10.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-0muRoXPO5tuav/aLSNZCNpUP/FYo0GRI7N16xWhB4Qo=";
    };
    x86_64-linux-313 = {
      name = "torchaudio-2.10.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.10.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-18a6jlE7lM2dX0Pu1HgHN+8bUJQd8RKt+19AHBsha3o=";
    };
    x86_64-linux-314 = {
      name = "torchaudio-2.10.0-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.10.0%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-kIUsvrHzUZuLXZHO15RYJ+kq1TBIaHOEp6PEAa61zO0=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.10.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.10.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-pbp+nADlp4aZSkaEU9ooWJkz6O+JyzMN15n+Y6hckrk=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.10.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.10.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-KIE2ZMTIZVeSHwrg7w9iTgZRMrAsUlv/WZ52VuGe9yc=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.10.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.10.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-CF8bcjOeQyEAW5qs19BrHGTl86Lj/5/GrVmL+2/ezsQ=";
    };
    aarch64-darwin-313 = {
      name = "torchaudio-2.10.0-cp313-cp313-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.10.0-cp313-cp313-macosx_12_0_arm64.whl";
      hash = "sha256-vSp2B4YHmOWEdH1zVrPxG0OtppWyZCFc5ae29o/g81U=";
    };
    aarch64-darwin-314 = {
      name = "torchaudio-2.10.0-cp314-cp314-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.10.0-cp314-cp314-macosx_11_0_arm64.whl";
      hash = "sha256-6o8HhIRjaezV2yZs9+sUhLXstzSG0puROt3SZ9e/Vks=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.10.0-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.10.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-8YL6GRdwG7wk+z4q63gBwVls9C0CPX1+NBBdLyfXKZg=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.10.0-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.10.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-01kA9GicsBZBlbMSY6dpmHyJU0Ehl6a0t1ghjS4tvIY=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.10.0-cp312-cp312-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.10.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-SlEfXVXuA0gFJnDlg0gAd05CbOFoXYe0gqyeIyQHS7c=";
    };
    aarch64-linux-313 = {
      name = "torchaudio-2.10.0-cp313-cp313-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.10.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-3Y7Rtym0aU8Bd2rpXn20MrGoCNtDd/mVlv50wkzLor4=";
    };
    aarch64-linux-314 = {
      name = "torchaudio-2.10.0-cp314-cp314-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.10.0-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-DxEeF2oX3R9uygFmLbr8G/o2ZBTd64bxCmUzD8rP8L8=";
    };
  };
}
