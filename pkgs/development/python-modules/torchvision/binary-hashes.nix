# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.17.2" = {
    x86_64-linux-38 = {
      name = "torchvision-0.17.2-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.2%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-3450y7tN4KYPEc18KNggEWAnzTlJiT+XxVtvEjJr168=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.17.2-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.2%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-839ZLjEovz2ZloraWhKPEY+a7R2rYJ4nKscjEUb8aEM=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.17.2-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.2%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-wPMlY1+INPpV5pq2EHX7K7y7RTlamFu6HbN4sVYnEEs=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.17.2-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.17.2%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-BZ+GocjSsnayZshKj1qSzIQm1DwqLCSNxzwUCrOoIvM=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.17.2-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.2-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-uDqsjXj0iYEUbVghaNdbbJR8+wp2k/duIZ8ZJvbllaM=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.17.2-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.2-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-SGi7+lV1jIEH5poOfdXne4kFYDXNOLdnrVuYzbccDw0=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.17.2-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.2-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-HykQ/jwhrWh1snINRvrYNbLkszbpVT0xyjZNJMkLHU8=";
    };
    x86_64-darwin-311 = {
      name = "torchvision-0.17.2-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.2-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-m4PlXufQoXBPUrnArIc4jnptHZimveews1+atU172lQ=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.17.2-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.2-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-Hs5AVX4SLXmXWGCgBap+Kp4ubDUKA+eKAOwUUAgzEv0=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.17.2-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.2-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-79bQ3QZo4V0Bos/63HQGhDOzLLz1aS4MSqFfxcslDOc=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.17.2-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.2-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-7MHFA/qKVPurd34Gp8IoAyuKt47+vzWyi8jyL1RPUfE=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.17.2-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.17.2-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-4DEAShvEMsmAp71kL2wYmj78MW5CP8MLVWmDcWak4o0=";
    };
  };
}
