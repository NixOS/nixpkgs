# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.21.0" = {
    x86_64-linux-39 = {
      name = "torchvision-0.21.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.21.0%2Bcu124-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-avshoi9Ul+COpNvUVERyMw2CSb8J2v0jkwJVLK1pBrI=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.21.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.21.0%2Bcu124-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-PT50AY6qeDfHPjdk2tO3eSt1REAcJaQpd+l0QwNzG9M=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.21.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.21.0%2Bcu124-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-E3N2gFrKW6V70sej7LhWnflh2+grEoqsmzsKcSXvk4U=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.21.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.21.0%2Bcu124-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-77U+oK978Jt7U+Khi5vm0kX31GqQtR1c+X836bkpqZE=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.21.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchvision-0.21.0%2Bcu124-cp313-cp313-linux_x86_64.whl";
      hash = "sha256-S3Cs87S5agzrE3QRZibJvvnovgFrV7EoTkgiYMoYltY=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.21.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.21.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-XCLK6q6LPDbZNFnxpSlOb0MwbP+FbtJDGJoikzGkBLQ=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.21.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.21.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-BE6kILjGwxYqI0ytqOICW5B2+oJQR1jNEexdD4zZ+jc=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.21.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.21.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-EQ0RUzNSTWDp5HTVPH0g8Jbb2KCAIy+I3duQVm+QBkw=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.21.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.21.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-l6WBSpPHk6rwF5z8f5FgJPS2MhiSmu6Xe2RWM9B0pJ8=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.21.0-cp313-cp313-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.21.0-cp313-cp313-macosx_11_0_arm64.whl";
      hash = "sha256-ZZt2yGdXyy7kyi2yReB0DPwwgf70bw8QZNEa20qM7jE=";
    };
    aarch64-linux-39 = {
      name = "torchvision-0.21.0-cp39-cp39-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.21.0-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-a9zjiQ+pSSGd4SnoXk9tVEWYrzwHOv5cROFK7RW9y7I=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.21.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.21.0-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-VIFeClbd6VzG7JUld/Z+DcFR6t2Sjo2fan+CHWmkpzQ=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.21.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.21.0-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-VEVJI6UBBMZqmra9i3OhHC/CGMlksQBtXR/ltELD3LY=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.21.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.21.0-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-UIOlsf7CNRv16pkAp0HVQIbbdbrsSx0h45RR4Al38bE=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.21.0-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.21.0-cp313-cp313-linux_aarch64.whl";
      hash = "sha256-UEWjpfIew+6mli+l8votQoP4VMrsJa2kk/z0qrKSVGc=";
    };
  };
}
