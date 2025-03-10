# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.6.0" = {
    x86_64-linux-39 = {
      name = "torch-2.6.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.6.0%2Bcu124-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-5mEmfNAkJGKrEAvdZ/ZRmIqp9n6zFgnWkJr8rIkd9hI=";
    };
    x86_64-linux-310 = {
      name = "torch-2.6.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.6.0%2Bcu124-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-fyun98BFkyClIWlva1vMwYf1mJCyPJ37bEmwuHxr/Jc=";
    };
    x86_64-linux-311 = {
      name = "torch-2.6.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.6.0%2Bcu124-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-1MPpqNMafA/LudoXwxoZF+H6wmxWakz72MlWitfK3nk=";
    };
    x86_64-linux-312 = {
      name = "torch-2.6.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.6.0%2Bcu124-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-o5O1BoRANcDawvMOqEeMNDuOlaQp8G87PK38f1OttZc=";
    };
    x86_64-linux-313 = {
      name = "torch-2.6.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.6.0%2Bcu124-cp313-cp313-linux_x86_64.whl";
      hash = "sha256-DzvFPJiM6VaM2HaipTFnYehKhwQTXsgGj1+BtEF5ecs=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.6.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.6.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-Jl9w3l/UW4ZNkktkvheX+G52yOSKAsKjpvx+wkfSImw=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.6.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.6.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-CeBvmUnhoFGMWwn+lSlbyWYfIZ2ey2+Yk+USPhBpZig=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.6.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.6.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-lPxjs7S+3TJ69YhpZVn2jCZEQOJQPMnmlUAZRz10riE=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.6.0-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.6.0-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-mmEK/iFqhai5vJ+DZe1WFTXJPoBMKjF+9/q8xd7aCYk=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.6.0-cp313-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.6.0-cp313-none-macosx_11_0_arm64.whl";
      hash = "sha256-/5b0A4+K+ffsQjFxDtRUnaG9662VkjlTolBF3Pb9h+I=";
    };
    aarch64-linux-39 = {
      name = "torch-2.6.0-cp39-cp39-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.6.0%2Bcpu-cp39-cp39-manylinux_2_28_aarch64.whl";
      hash = "sha256-KrnGs9bupQa9qbgqAVXpdNjvjji0F1idFEVotPpZr+E=";
    };
    aarch64-linux-310 = {
      name = "torch-2.6.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.6.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-kIMvTRGMVmuGUqIZasaV/B8Uz0INsntaG0HH6q8hQek=";
    };
    aarch64-linux-311 = {
      name = "torch-2.6.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.6.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-09q5+wKU8miuwo6Kq6g06dAGuQpQ21vC/iGRqdSMYIQ=";
    };
    aarch64-linux-312 = {
      name = "torch-2.6.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.6.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-MYKQ6JJDU8YbElzch2jRUghwTieed1fBE7liB0Deypg=";
    };
    aarch64-linux-313 = {
      name = "torch-2.6.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.6.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-tefo1WGyY7WtgElzYoHNEseOUee8GpE/1AmP0OC5Y0c=";
    };
  };
}
