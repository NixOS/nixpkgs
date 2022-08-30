# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "1.11.0" = {
    x86_64-linux-37 = {
      name = "torch-1.11.0-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.11.0%2Bcu113-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-9WMzRw2uo8lweLN2B+ADXMz3L8XDb9hFRuGkuNmUTys=";
    };
    x86_64-linux-38 = {
      name = "torch-1.11.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.11.0%2Bcu113-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-tqeZvbbuPZFOXmK920J21KECSMGvTy0hdzjl+e4nSFs=";
    };
    x86_64-linux-39 = {
      name = "torch-1.11.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.11.0%2Bcu113-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-6RJrCl2VcEvuQKnQ7xy9gtjceGPkY4o3a+9wLf1lk3A=";
    };
    x86_64-linux-310 = {
      name = "torch-1.11.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torch-1.11.0%2Bcu113-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-powzZXpUYTHrm8ROKpjS+nBKr66GFGCwUbgoE4Usy0Q=";
    };
    x86_64-darwin-37 = {
      name = "torch-1.11.0-cp37-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.11.0-cp37-none-macosx_10_9_x86_64.whl";
      hash = "sha256-aGCx0b8LsLZ6a9R/haDkyCW1GO6hO11hAZmdu8vVvAw=";
    };
    x86_64-darwin-38 = {
      name = "torch-1.11.0-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.11.0-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-DMyFzQYiej7fgJ4seV/Vdiw9Too4tcn3RMbnz4QTYbs=";
    };
    x86_64-darwin-39 = {
      name = "torch-1.11.0-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.11.0-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-UP2b+FxXjIccKPHLCs6d/GAkQBx/OZsXT7DzcImfRFQ=";
    };
    x86_64-darwin-310 = {
      name = "torch-1.11.0-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.11.0-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-UP2b+FxXjIccKPHLCs6d/GAkQBx/OZsXT7DzcImfRFQ=";
    };
    aarch64-darwin-38 = {
      name = "torch-1.11.0-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.11.0-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-wVVOSddPGyw+cgLXcFa6LddGVDdYW6xkBitYD3FKROk=";
    };
    aarch64-darwin-39 = {
      name = "torch-1.11.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.11.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-DkivZq11Xw+cXyZkAopBT1fEnWrcN+d+Bv4ABNpO22E=";
    };
    aarch64-darwin-310 = {
      name = "torch-1.11.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-1.11.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-DkivZq11Xw+cXyZkAopBT1fEnWrcN+d+Bv4ABNpO22E=";
    };
  };
}
