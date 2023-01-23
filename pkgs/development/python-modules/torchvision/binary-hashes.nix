# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.14.1" = {
    x86_64-linux-37 = {
      name = "torchvision-0.14.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.14.1%2Bcu116-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-SYVxnGbJYS/0uy06U8P6r92TQVKyqHQU0nvceHSkNg8=";
    };
    x86_64-linux-38 = {
      name = "torchvision-0.14.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.14.1%2Bcu116-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-R1k1helxw+DJgPq/v7iF61/wVHFrqlVWYMWwMEyeo50=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.14.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.14.1%2Bcu116-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-qfw4BA4TPRd58TG0SXyu+DDp5pn6+JzTI81YeU/7MFs=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.14.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchvision-0.14.1%2Bcu116-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-/LWNQb+V3YuF04j6GWnR3K1V7sBV4xeYHWU6BcTKbYs=";
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
