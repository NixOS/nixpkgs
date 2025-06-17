# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.22.1" = {
    x86_64-linux-39 = {
      name = "torchvision-0.22.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.22.1%2Bcu128-cp39-cp39-manylinux_2_28_x86_64.whl";
      hash = "sha256-UfJbwdKLA32YoUFckXRBcmJE2KAJcZB+bfsA7MwxNl8=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.22.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.22.1%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-U49NtmcobZObTu4KZtMe0htRGGZoAGsOD/4gM47MfgA=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.22.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.22.1%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-klaKxGsTqMiLYViYALG5xGKb4JHqfOCA/G/GIuEeCRU=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.22.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.22.1%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-9k75u5HXGrNdg4SRKhn3QZ41koaFvGdUTVj0UUgzQ3M=";
    };
    x86_64-linux-313 = {
      name = "torchvision-0.22.1-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchvision-0.22.1%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-vE/vGTkXtR22tAms0//eyShth3uqwK7l3Pu3JZLQC/w=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.22.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-i+lBtNNcCrqBm+cP27vtjOtgQBzmmWuM+quhMAzmImM=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.22.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-O0fYNp7laMBneVwNoLQHjzmp3+pvO8HzrIdTDf2h3VY=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.22.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-St32JuK1f8Iv1tMpzxNG1HRJdnLmr4ODt7W2NvupSlM=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.22.1-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.1-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-FT8XkOUFvW2hI+Ie7m6D4uFV3wXA/n1WNHMDBn2FQ8U=";
    };
    aarch64-darwin-313 = {
      name = "torchvision-0.22.1-cp313-cp313-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.1-cp313-cp313-macosx_11_0_arm64.whl";
      hash = "sha256-nDrjMZYkxDzIEnAg9GwUqoeEBngfCJm7YoOuR0r+r78=";
    };
    aarch64-linux-39 = {
      name = "torchvision-0.22.1-cp39-cp39-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.1-cp39-cp39-manylinux_2_28_aarch64.whl";
      hash = "sha256-FUor3DehYSLCAk8vd+ZfWYYCC0DAE1FcaUtdNX+smaE=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.22.1-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.1-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-mQ3k1lekHtcWgM2L4umOvKtVNx8wmT3JvS5nZEH3GA4=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.22.1-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.1-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-i0pTpgZ9Y626DFLyuN0ikNtknWQgIWdO5DwMki8Mamk=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.22.1-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.1-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-lkQU7vGUWdVaEOiG4vylBndVDiQ1htFnj2Xj9va6xHo=";
    };
    aarch64-linux-313 = {
      name = "torchvision-0.22.1-cp313-cp313-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.22.1-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-SmFKakCNLtdCCNDqbCii+7aCkOmn3yBsX+8/C2hl0wc=";
    };
  };
}
