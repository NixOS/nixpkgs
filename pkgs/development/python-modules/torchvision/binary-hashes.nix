# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.17.1" = {
    x86_64-linux-38 = {
      name = "torchvision-0.17.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-oCRjQQZPPBdtqKpuMvATD2ACOAyQruqOMccY3ixUZOE=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.17.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-WsK2vDCcNDud6KklczHPcVtm+qm1kiep8HDZ4BJS5go=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.17.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-J69HkV9udiwdROWOgIjSKsl0RWaPn3k1JAMrK69PNL0=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.17.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-bYKfOZSQQCWyiXHMxhvWbt2VKATyEipuEENQuOkXL08=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.17.1-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.1-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-JiEJcGX6HIJ4heK1IQLoOaNUG5M7epDg+jxCw94bw88=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.17.1-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.1-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-WCmacks3uJPHzk0LMuoUgMMORnzBFBZ5ZLRfYBP2wtM=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.17.1-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.1-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-BkGIgCErZuRehV3Tn1Nuf9SLTmsDShHdn+niOEr7Uew=";
    };
    x86_64-darwin-311 = {
      name = "torchvision-0.17.1-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.1-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-6izNv1l04L8n/WZEozsZywcAKXzzl7sEaediwRxsQQU=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.17.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-XOdkZq8rWjBXOTnK4ebmLikxbOs+50gJEALzEqsJEvY=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.17.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-ihsX+xWLK4gfLIeW/hg5piTknV/QeqYfba5gukgZQho=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.17.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-M9ZdDH/cs/e8HdjtMOo81+BYe0rRsQS1Z3yBkai62fE=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.17.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-kQbjLJ8ecK+oFyzxsGTPnCmY2N/wdp7GnVN7ICCe5D0=";
    };
  };
}
