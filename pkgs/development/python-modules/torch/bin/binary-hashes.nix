# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.15.0" = {
    x86_64-linux-311 = {
      name = "torch-2.15.0+cu132-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu132/torch-2.15.0%2Bcu132-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-6unuzm2v5oi7x6/WiXgbd3eAOMkEO6riHAhCYavk9a0=";
    };
    x86_64-linux-312 = {
      name = "torch-2.15.0+cu132-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu132/torch-2.15.0%2Bcu132-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-hJNkhO0KLlX8ifKcflgL4u/0+0ycLEbIiEnPgGIoH5Y=";
    };
    x86_64-linux-313 = {
      name = "torch-2.15.0+cu132-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu132/torch-2.15.0%2Bcu132-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-foj2P2eyXriJ7aSP6Gw7YU9n8i/uzbWEHyF5mqYHbU4=";
    };
    x86_64-linux-314 = {
      name = "torch-2.15.0+cu132-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu132/torch-2.15.0%2Bcu132-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-WT401aVy5DprpRaehRwe7bSqq0P1M4olfwv7MCQqlfw=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.15.0-cp311-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.15.0-cp311-cp311-macosx_14_0_arm64.whl";
      hash = "sha256-6Ai2PWFqQ7Mm4aVnfUWi5bq+eoziftsD3bSOfdm21mM=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.15.0-cp312-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.15.0-cp312-cp312-macosx_14_0_arm64.whl";
      hash = "sha256-WT5f0MIEKEiQ0cPf9kO+NOVJ4dJFI+E0AlEPlg1NpDg=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.15.0-cp313-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.15.0-cp313-cp313-macosx_14_0_arm64.whl";
      hash = "sha256-++/XO1IdPHXFodfHcFayxjObgUaNFNTjPFX1JUGKWFU=";
    };
    aarch64-darwin-314 = {
      name = "torch-2.15.0-cp314-cp314-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.15.0-cp314-cp314-macosx_14_0_arm64.whl";
      hash = "sha256-DSstlnT6C5s/UOgyMaplRaCxnkN6UvCvk5oiT6qkVRU=";
    };
    aarch64-linux-311 = {
      name = "torch-2.15.0+cpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.15.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-l9xrCny60hCeYV2j6sA99ibGHoIelIZDiwJIuolheMY=";
    };
    aarch64-linux-312 = {
      name = "torch-2.15.0+cpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.15.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-dZQdQpqvRFC802Q0XXZ34tVKrUWzj7/LHAVSRQpunEA=";
    };
    aarch64-linux-313 = {
      name = "torch-2.15.0+cpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.15.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-qzWHWxWsU2pkXhZbKWMA/tcd97Ty3brkDHJasI8KXng=";
    };
    aarch64-linux-314 = {
      name = "torch-2.15.0+cpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.15.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-Ab3H0pHj9rXAPPctihcYpQEtn61fOA5ntWOwp2WSBVo=";
    };
  };
}
