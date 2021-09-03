# Warning: use the same CUDA version as pytorch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

version: {
  x86_64-linux-37 = {
    name = "torchvision-${version}-cp37-cp37m-linux_x86_64.whl";
    url = "https://download.pytorch.org/whl/cu111/torchvision-${version}%2Bcu111-cp37-cp37m-linux_x86_64.whl";
    hash = "sha256-7EMVB8KZg2I3P4RqnIVk/7OOAPA1OWOipns58cSCUrw=";
  };
  x86_64-linux-38 = {
    name = "torchvision-${version}-cp38-cp38-linux_x86_64.whl";
    url = "https://download.pytorch.org/whl/cu111/torchvision-${version}%2Bcu111-cp38-cp38-linux_x86_64.whl";
    hash = "sha256-VjsCBW9Lusr4aDQLqaFh5dpV/5ZJ5PDs7nY4CbCHDTA=";
  };
  x86_64-linux-39 = {
    name = "torchvision-${version}-cp39-cp39-linux_x86_64.whl";
    url = "https://download.pytorch.org/whl/cu111/torchvision-${version}%2Bcu111-cp39-cp39-linux_x86_64.whl";
    hash = "sha256-pzR7TBE+WcAmozskoeOVBuMkGJf9tvsaXsUkTcu86N8=";
  };
}
