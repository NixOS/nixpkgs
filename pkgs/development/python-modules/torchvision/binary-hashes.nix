# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.14.1" = {
    x86_64-linux-37 = {
      name = "torchvision-0.14.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu117/torchvision-0.14.1%2Bcu117-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-vOOhWqGuclcvjNKOSdHsGtjwhm+7ZhxzaNnBKF9psi4=";
    };
    x86_64-linux-38 = {
      name = "torchvision-0.14.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu117/torchvision-0.14.1%2Bcu117-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-dAk4UTnOiGTOssgv/OM46+FaVRk/S4DEKm0PnP14Fik=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.14.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu117/torchvision-0.14.1%2Bcu117-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-iomg7gB9fNulO9VkJth5UGCgZLiRm2GsOeAOOZ3ta+I=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.14.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu117/torchvision-0.14.1%2Bcu117-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-g9JxpTA5KBS4x/aTgihcrHx9p5uPXcxrz1bGKFR7zlM=";
    };
    x86_64-darwin-37 = {
      name = "torchvision-0.14.1-cp37-cp37m-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.14.1-cp37-cp37m-macosx_10_9_x86_64.whl";
      hash = "sha256-+3p5P9M84avsJLQneEGaP7HjFZ19/LJ0o8qPuMvECNw=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.14.1-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.14.1-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-aO0DNZ3NPanNIbirlNohFY34pqDFutC/SkLw5EjSjLM=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.14.1-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.14.1-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-xedE9W5fW0Ut61/A8/K6TS8AYS0U2NoNvv6o8JrHaQs=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.14.1-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchvision-0.14.1-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-7rBd2d069UKP7lJUAHWdr42o5MrsRd3WkIz7NlcfZDM=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.14.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.14.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-MPzw6f5X1KxM5kJmWaV9zhmWN8y2xwvhEoZw8XdpJiQ=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.14.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.14.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-dYsg0HnoELR0C9YNHrFuSdqDDjNg+b43nrF37iIfpdQ=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.14.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.14.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-jQdm6pKv+nrySOMn3YX3yc/fUaV1MLQyEtThhYVI6dc=";
    };
  };
}
