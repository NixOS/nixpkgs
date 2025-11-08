# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.9.0" = {
    x86_64-linux-310 = {
      name = "torch-2.9.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.9.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-gWVAKG/OJFqK85BKGUqDr5ySkq10Uut5Fgt6Oxzvt+M=";
    };
    x86_64-linux-311 = {
      name = "torch-2.9.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.9.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-6XwmRHjJ/Ej5GDJ0nZYPHjSa6yFCJOvmX7CUNd1kxZo=";
    };
    x86_64-linux-312 = {
      name = "torch-2.9.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.9.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-h8YtO5XxoicL0Rbb1H3FFcCyA1B2+7SgO0Nl6iieicQ=";
    };
    x86_64-linux-313 = {
      name = "torch-2.9.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.9.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-l97wCH+O8XG5AC6lALr/3UQMe91VnCPDi7+HgbZ+k2Q=";
    };
    x86_64-linux-314 = {
      name = "torch-2.9.0-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.9.0%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-VaIYTtifISC8HiyIfumOUoDe5IvDMOnf4paqE1o3D30=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.9.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-WUhBk7ASmb9mlSBQWnKynVmgAorkxtlfSSk48YZZIgg=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.9.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-qkSDYCWGzJo10c8zdxqZd/BfZCuRYVGKKJ42VIoLd8I=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.9.0-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.0-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-TeDtjLxFelBtvKQDduIGop7+4QdWoA8fNAS/Z61zfQQ=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.9.0-cp313-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.0-cp313-none-macosx_11_0_arm64.whl";
      hash = "sha256-4kg22Wi1TvTfsFWUABphlYcRrJIkAmKR5OP5L4Om/X8=";
    };
    aarch64-darwin-314 = {
      name = "torch-2.9.0-cp314-cp314-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.0-cp314-cp314-macosx_11_0_arm64.whl";
      hash = "sha256-2OKrf4YBAzC9zDnIsseVWQzHXjffSCPNruLJjW4/9KM=";
    };
    aarch64-linux-310 = {
      name = "torch-2.9.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-siR5LqVntSx/HOHXiVZ/aSDgb9OzOfoeGwWUiEX3g60=";
    };
    aarch64-linux-311 = {
      name = "torch-2.9.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-2nc0HMq6MXYtkjiwlCwWXEWComgY8wRbBSs5zr3XrZ0=";
    };
    aarch64-linux-312 = {
      name = "torch-2.9.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-OmUUNK4SSLBWjBK1+eOsyJQusoN42dBKeTApOLaMbyQ=";
    };
    aarch64-linux-313 = {
      name = "torch-2.9.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-vkQ42NrX8NWl5U8P7viok0RolOyH8QK7HYLcxFGFQuQ=";
    };
    aarch64-linux-314 = {
      name = "torch-2.9.0-cp314-cp314-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.9.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-RKrbc1d01KmVJdLsKRJrIwFsRKB7As5sI336YaIj3VI=";
    };
  };
}
