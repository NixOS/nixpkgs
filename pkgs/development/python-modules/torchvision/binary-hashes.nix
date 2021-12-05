# Warning: use the same CUDA version as pytorch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.11.1" = {
    x86_64-linux-37 = {
      name = "torchvision-0.11.1-cp37-cp37m-linux_x86_64.whl";
      url =
        "https://download.pytorch.org/whl/cu113/torchvision-0.11.1%2Bcu113-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-2xKWqWNKqmOMyVJnPfbtF+B9PQ7z4S66J1T3P8EvM0I=";
    };
    x86_64-linux-38 = {
      name = "torchvision-0.11.1-cp38-cp38-linux_x86_64.whl";
      url =
        "https://download.pytorch.org/whl/cu113/torchvision-0.11.1%2Bcu113-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-bFxvJaNEomytXXANHng+oU8YSLGkuO/TSzkoDskkaIE=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.11.1-cp39-cp39-linux_x86_64.whl";
      url =
        "https://download.pytorch.org/whl/cu113/torchvision-0.11.1%2Bcu113-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-ysN3LmSKR+FVKYGnCGQJqa8lVApVT5rPMO+NHmmazAc=";
    };
  };
}
