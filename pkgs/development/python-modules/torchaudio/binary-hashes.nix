# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.11.0" = {
    x86_64-linux-37 = {
      name = "torchaudio-0.11.0-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchaudio-0.11.0%2Bcu113-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-AdqgntXh2rTD7rBePshFAQ2tVl7b+734wG4r471/Y2U=";
    };
    x86_64-linux-38 = {
      name = "torchaudio-0.11.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchaudio-0.11.0%2Bcu113-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-zuCHDpz3bkOUjYWprqX9VXoUbXfR8Vhdf1VFfOUg8z4=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-0.11.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchaudio-0.11.0%2Bcu113-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-btI9TpsOjeLnIz6J56avNv4poJTpXjjhDbMy6+ZFQvI=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-0.11.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchaudio-0.11.0%2Bcu113-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-Zk+AWytEXfJ+HM69BAPhVsvN6pgQwC6uaW7Xux2row4=";
    };
    x86_64-darwin-37 = {
      name = "torchaudio-0.11.0-cp37-cp37m-macosx_10_15_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.11.0-cp37-cp37m-macosx_10_15_x86_64.whl";
      hash = "sha256-uaTT4athEWHAZe0hBoBIM/9LhfZNhAIexZBGg2MWn50=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-0.11.0-cp38-cp38-macosx_10_15_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.11.0-cp38-cp38-macosx_10_15_x86_64.whl";
      hash = "sha256-9OndqejTzgu9XnkZJiGfUFS4uFNlx5vi7pAzOs+a2/w=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-0.11.0-cp39-cp39-macosx_10_15_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.11.0-cp39-cp39-macosx_10_15_x86_64.whl";
      hash = "sha256-cNi8B/J3YI0jqaoI2z+68DVmAlS8EtmzYWQMRVZ3dVk=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-0.11.0-cp310-cp310-macosx_10_15_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.11.0-cp310-cp310-macosx_10_15_x86_64.whl";
      hash = "sha256-g2Pj2wqK9YIP19O/g5agryPcgiHJqdS2Di44mAVJKUQ=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-0.11.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.11.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-MX/Y7Dn92zrx2tkGWTuezcPt9o5/V4DEL43pVlha5IA=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-0.11.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.11.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-5eVRP83VeHAGGWW++/B2V4eyX0mcPgC1j02ETkQYMXc=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-0.11.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.11.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-06OyzOuV8E7ZNtozvFO9Zm2rBxWnnbM65HGYUiQdwtI=";
    };
  };
}
