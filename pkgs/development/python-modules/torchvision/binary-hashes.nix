# Warning: use the same CUDA version as pytorch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.9.1" = {
    x86_64-linux-37 = {
      name = "torchvision-0.9.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torchvision-0.9.1%2Bcu111-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-7EMVB8KZg2I3P4RqnIVk/7OOAPA1OWOipns58cSCUrw=";
    };
    x86_64-linux-38 = {
      name = "torchvision-0.9.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torchvision-0.9.1%2Bcu111-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-VjsCBW9Lusr4aDQLqaFh5dpV/5ZJ5PDs7nY4CbCHDTA=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.9.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torchvision-0.9.1%2Bcu111-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-pzR7TBE+WcAmozskoeOVBuMkGJf9tvsaXsUkTcu86N8=";
    };
  };
  "0.10.0" = {
    x86_64-linux-37 = {
      name = "torchvision-0.10.0-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torchvision-0.10.0%2Bcu111-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-yMgRhp06/rYIIiDNehNrZYIrvIbPvusCxGJL0mL+Bs4=";
    };
    x86_64-linux-38 = {
      name = "torchvision-0.10.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torchvision-0.10.0%2Bcu111-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-p1bw+4KsdTuXle+AwXYQVL8elPMroAHV9lkXJGWbtPc=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.10.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu111/torchvision-0.10.0%2Bcu111-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-AOfhnHThVdJx5qxj2LTj+T9dPMFxQoxP3duxIm1y7KE=";
    };
  };
}
