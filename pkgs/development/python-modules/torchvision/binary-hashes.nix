# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.26.0" = {
    x86_64-linux-310 = {
      name = "torchvision-0.26.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.26.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-9Ev8Ybm+gLz1KnYtNNo2POoxJdEMAfN+JxWDgDx7uXs=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.26.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.26.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-jyYp0FZXDJKbCh1Uc9nLAyC5C9oXZL2jU1U6csxrIGk=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.26.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.26.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-zPJrS2Wc/ObyIIy4MmBx1RxwIZo0hW399GjR4Zr1LA0=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.26.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.26.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-yx9hhKe6MPukBYDhoBpmBKhsVeef3aGH9AEW7mgEQew=";
    };
    x86_64-linux-314 = {
      name = "torchvision-0.26.0-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.26.0%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-qsZHyRMPHyX1yPW8o9lc/Za9+sk6tUUpaQsIjmTk+mQ=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.26.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.26.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-oG1HcqjhPncpBu1zbMU+xmOeXmBVT45fpsoWWqvrxGQ=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.26.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.26.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-Vb1q1K53vgG6Z6QQsFtR9TsNDuRfFG62oN+5AH5wqzw=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.26.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.26.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-xAnhw/3r7Ho4NEZQhtvai/doDv95q/f9LxDGtZUgp6Q=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.26.0-cp313-cp313-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.26.0-cp313-cp313-macosx_12_0_arm64.whl";
      hash = "sha256-XWPdQxYmkSWLGzUpuQQbrH1UyqN+rgkl+ZcQgmjL98Q=";
    };
    aarch64-darwin-314 = {
      name = "torchvision-0.26.0-cp314-cp314-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.26.0-cp314-cp314-macosx_12_0_arm64.whl";
      hash = "sha256-62GATrnb6IxaKmxNqN7B2A0tCm8YyZnFJOMiZssevNM=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.26.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.26.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-l9+ahZXc4lbS5t0Wu80caN0A7scS431LbseYVFPdwqo=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.26.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.26.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-wR5VBB9rhKbE+yiYG5AUdaqBw4aVzOxt38xUw/qfrE8=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.26.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.26.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-F/C1QjMfyUIwtCFMbRI/A4r3Mw/YEBlgjA0kAvO8MHk=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.26.0-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.26.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-LpMq8SOjkTeBXf0VLGTMaD+ny9MnyWXoB8lyjHqklxo=";
    };
    aarch64-linux-314 = {
      name = "torchvision-0.26.0-cp314-cp314-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.26.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-eFdsjVqGZd5sqqbnw6P7fKpdwRIDK6YOEpqeeKRGoDs=";
    };
  };
}
