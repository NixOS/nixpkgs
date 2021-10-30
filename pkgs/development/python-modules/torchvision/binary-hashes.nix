# Warning: use the same CUDA version as pytorch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.10.1" = {
    x86_64-linux-37 = {
      name = "torchvision-0.10.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torchvision-0.10.1%2Bcu111-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-1MdsCrOLGkYpfbtv011/b6QG+yKaE+O0jUKeUVj2BJY=";
    };
    x86_64-linux-38 = {
      name = "torchvision-0.10.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torchvision-0.10.1%2Bcu111-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-LtmsnNSa9g3tCdjW1jhu7AZlGgfyYIVh5/2R+WwcxSo=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.10.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torchvision-0.10.1%2Bcu111-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-ZOC/angyiLeOhe+7dAs0W6XlQRKK00T/iI+aBgFNpA0=";
    };
  };
}
