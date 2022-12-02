# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.12.1" = {
    x86_64-linux-37 = {
      name = "torchaudio-0.12.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchaudio-0.12.1%2Bcu116-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-8Z72lazhnV2ZBtnvpdm5ZHhiyE/wHwEpQ9UzZoi//mw=";
    };
    x86_64-linux-38 = {
      name = "torchaudio-0.12.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchaudio-0.12.1%2Bcu116-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-CCtZ6eUhs/6kaoU0HwDDaK4JTSFKkVJF+OMAu368Zno=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-0.12.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchaudio-0.12.1%2Bcu116-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-pNa5fV9vC1cXeDLhHTCscO7RO2lst2Vmm0K7NzINqgw=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-0.12.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchaudio-0.12.1%2Bcu116-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-KdeBVGBQ1lQxXxCQGwX17E1iptMis0Rfex++o4JmVog=";
    };
    x86_64-darwin-37 = {
      name = "torchaudio-0.12.1-cp37-cp37m-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.12.1-cp37-cp37m-macosx_10_9_x86_64.whl";
      hash = "sha256-I9vPN68vQdSRwDN8qUUB7H71iK2xdm4esoAz+sVJu9k=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-0.12.1-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.12.1-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-pMjBWx6BCpO7d7J/pJFZvqIlO1k++UA5lG7Emu9Rdk8=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-0.12.1-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.12.1-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-CPkrxTaC07rYYG3ttwpJ5aD3z5MGyRc/B027qXeFRC4=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-0.12.1-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.12.1-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-3BOL7gayMFRC/BMhcfKgHV9CUJ6qIb34fD0mpvSgn90=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-0.12.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-0.12.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-g8CLcabcjiPB17AHgKu55MKVKOR6bmRP497nrCJjgh4=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-0.12.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-0.12.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-L8WivI6KrUdbxRnzyCuWSeFLXGV0h/+nEs98UUFD6dc=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-0.12.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-0.12.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-HYH3GDfV1b5lHoXKn6k3fstFE7ASnd+wJVQOHCQG0+Y=";
    };
  };
}
