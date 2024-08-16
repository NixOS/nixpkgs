# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.18.1" = {
    x86_64-linux-38 = {
      name = "torchvision-0.18.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.18.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-ruiWHcuKQY6S0G1LPpr1KYcpOkjBQjHDxQyO6jdB5BI=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.18.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.18.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-Hr9du9869EbITkK68u2+sb1vsMydO0kBr5acg5HRSl4=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.18.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.18.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-6VulosYWk5KB4Bur8RZk1tFyXoG7pX74H4HD5X5NQVE=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.18.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.18.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-KyrsLGjguhf57tiSF5b6Lbx6ST3qejtF0lwFWtQXSGg=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.18.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.18.1%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-zo1bmSBW8GQKOe9XNDQuQ8pKgBVH3if7jbwwVdk0WUc=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.18.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-scOGT6k3jIi86K0O81mfTyU5eJfOYS4cJFx0uXCS814=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.18.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-l1uFlMD1KIh1QIrLt0lG7qeGxbAI0SnA0EXQ6tI3Qrw=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.18.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-PmlOVLBUja2ZwSr2vwyOTzNQE305Hc0ZryKhxfiTIrM=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.18.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-gLXXlN0P26eHrcIvGjZ6Xq1FIydoZHPLJg3ZQ2S8VqY=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.18.1-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.1-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-K+bwv3xFXImlGh27b2aNNsbtxHn0mskS10XRDfVxVlc=";
    };
    aarch64-linux-38 = {
      name = "torchvision-0.18.1-cp38-cp38-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.1-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-lybDFqJQHfhQPlpdxGpjGv1MUVqViXLlt/e5yH0hJcA=";
    };
    aarch64-linux-39 = {
      name = "torchvision-0.18.1-cp39-cp39-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.1-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-VL/NNSq7OW1cnCN9IAFnwXi9E2BRsTjh6O9GzjZ8J3M=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.18.1-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.1-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-Vz/1I8c5QF7bCF9ly1kvSC0oow4psL5MS6CAQLOueF8=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.18.1-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.1-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-zrmTqILxrnrjc+05wo1+PoAiBbDlmn7YTvQCjwu6jX8=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.18.1-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.1-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-E9JNkE9l5i1moeDEH67GMLwZOGe4pKARZnaeio6N+Ok=";
    };
  };
}
