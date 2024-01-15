# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.1.2" = {
    x86_64-linux-38 = {
      name = "torch-2.1.2-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.2%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-2qF5u1WPePIWXbl0pnROyN4upx62qvNiva52FgEsAwI=";
    };
    x86_64-linux-39 = {
      name = "torch-2.1.2-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.2%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-6q9pB+NyPAymqR314Bp+74yr7JMSDppQc59aXxSiqkY=";
    };
    x86_64-linux-310 = {
      name = "torch-2.1.2-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.2%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-shhLdynvO5sQBlwHSjfB5gP9mfkeODduJct+1uHVRpY=";
    };
    x86_64-linux-311 = {
      name = "torch-2.1.2-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.1.2%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-ygXK6TNFBNGQPhbFDd8EUymoWdWxon7S3B1Y7QZt9vo=";
    };
    x86_64-darwin-38 = {
      name = "torch-2.1.2-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-jiId7M0N72wrrf9r5APgxTSRgF7ZkV4sAprbzbh6trU=";
    };
    x86_64-darwin-39 = {
      name = "torch-2.1.2-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-aYTNUFfAyXezyXVyVOmJ0/EST0zp0HyqbLY3eDxx1Co=";
    };
    x86_64-darwin-310 = {
      name = "torch-2.1.2-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-2bU1ytDfPROZfb6L1orDPg465Td2OcmIGUjkB5SmFAM=";
    };
    x86_64-darwin-311 = {
      name = "torch-2.1.2-cp311-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp311-none-macosx_10_9_x86_64.whl";
      hash = "sha256-dtN5Z8McmVSK0sTT8s8ZHbSEdvLmmzWgk3E3EW2jVqE=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.1.2-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-BbGFlPYKkRoMTwI/OKi9p3Ex+6X9dBvaYm6X3PWj3Qo=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.1.2-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-vBldeSf+q8DrfBEORXyVXtKrYW88fChDndQYjPWJaZ8=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.1.2-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-+aVdVa8Cgm6/ut9Om2gvDyd2a8M9+CNrSNKNcFWHho8=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.1.2-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-4tg/B7SqyYNFPqW/j5qp2s8ieKjTEkf12QN/N778YOQ=";
    };
    aarch64-linux-38 = {
      name = "torch-2.1.2-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-4yJfR9ULtm91b+kZanaAVdHCawIVTrH3cM5HoleNOqc=";
    };
    aarch64-linux-39 = {
      name = "torch-2.1.2-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-2TunD2ewjCrlWY7nEcvFRqG8gQLO+TiQS4yFwgiaUaA=";
    };
    aarch64-linux-310 = {
      name = "torch-2.1.2-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-vvaZbCfY9ukupOE6dy2JYR2g4QO0h5DeeBMeMIz3MHY=";
    };
    aarch64-linux-311 = {
      name = "torch-2.1.2-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.1.2-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-jzLOWRYWowME83p9XqgLacqeG5S7p/MIGEv2Fv2uoVU=";
    };
  };
}
