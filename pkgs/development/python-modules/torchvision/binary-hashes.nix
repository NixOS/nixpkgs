# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.22.0" = {
    x86_64-linux-39 = {
      name = "torchvision-0.22.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.22.0%2Bcu128-cp39-cp39-manylinux_2_28_x86_64.whl";
      hash = "sha256-ySo1P/gtszEmRLWybUELWGtylptTWUjVhMJHVp91YFw=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.22.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.22.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-Wd9aVQETqAzlIwRwZuqu2xaMaUgtqIw6skZxarRboJI=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.22.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.22.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-86xSfVi0wgQ+uNnin8Vs0XUfNvKqptx1407FTJUby5w=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.22.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.22.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-BsEB9A4f+UhpvhRIfJH9U1LjdvIC/er7j1PFjO4vvrU=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.22.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.22.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-7k+m1AUtmuJcEjMomUf7+kuI0jcQJUqxdysQjB/F+00=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.22.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-LvOKOX8bnPYoRvsgZZy5kQH502HejEXXkoTuRcb0DVA=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.22.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-ciVvHX/1ELFsn7TdSIWE0Gk/QMeS8oapYgZ0Q4qBzMo=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.22.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-GR6igyH8Ji2Koaf+ecQf8oSIZL84L59upFxB3egxN5I=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.22.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-McMWVBj+IcPYH+NFnlEHfC+UiAG4kz7RgWn1RlJ5ag8=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.22.0-cp313-cp313-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.0-cp313-cp313-macosx_11_0_arm64.whl";
      hash = "sha256-7OF5lYV90yhIXJwCfAsg/8UtsjLjDIT/bJWrdyAREsU=";
    };
    aarch64-linux-39 = {
      name = "torchvision-0.22.0-cp39-cp39-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.0-cp39-cp39-manylinux_2_28_aarch64.whl";
      hash = "sha256-QJX6wrLkmpww9wHgnsG989EbHkiwBqdqkBWi7Ys5VW4=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.22.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-gQ6krzvGPPOeg0+R9CGP9ZmSccqv/iRWJH35BQAr1sA=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.22.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-bFYg4Q/+OI629HRJYhBu188VCNJub9+gwQUi0ySa6iQ=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.22.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-jxFryC4MB25wund25hHtOSuWZqpENmLmh4CLCJk9Jq8=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.22.0-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-Rxxt11u5hMbr5PYDIolKKQvz1LGV52nYB1TzaJzX8jg=";
    };
  };
}
