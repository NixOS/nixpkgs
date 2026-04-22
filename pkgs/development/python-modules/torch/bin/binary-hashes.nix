# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.11.0" = {
    x86_64-linux-310 = {
      name = "torch-2.11.0+cu128-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.11.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-ctU/MXamnMIHEMTsuV99xMa6EMTk7aRbg5buee5A91o=";
    };
    x86_64-linux-311 = {
      name = "torch-2.11.0+cu128-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.11.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-yafKTHT64QpY5hdbSyzqlT+TIrtlYrvzOa1qBfUhkK0=";
    };
    x86_64-linux-312 = {
      name = "torch-2.11.0+cu128-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.11.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-0lLPl1+xjJSoUzYyOtQl9HPfVtqzWkSwA5m9cMejuZc=";
    };
    x86_64-linux-313 = {
      name = "torch-2.11.0+cu128-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.11.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-25ZLM8VQNacqs+IWIoevjxzCdgOcZdAVdAzIjCbc7fc=";
    };
    x86_64-linux-314 = {
      name = "torch-2.11.0+cu128-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.11.0%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-04moUGd/DSTa+uFXNkQDRCjY07nIC1HVW6Yv7X5sh3c=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.11.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.11.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-kSCcfYokYLduj/Wyi3Yj2kqx0nR0t54d6D6VSHGYWv4=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.11.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.11.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-116tzZf+DcfNDu3E1yFSSEwZyyz+Rs5VdmyOEpEWQl8=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.11.0-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.11.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-Q7NRFoAshfuI2Z9KOWuL1Ecr/KHdguaUmeWk+bi04lI=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.11.0-cp313-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.11.0-cp313-cp313-macosx_11_0_arm64.whl";
      hash = "sha256-RC7J3HhZJWT9rWnPC+qp2i+Cq4EMy08TkDhpqQvz8V0=";
    };
    aarch64-darwin-314 = {
      name = "torch-2.11.0-cp314-cp314-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.11.0-cp314-cp314-macosx_11_0_arm64.whl";
      hash = "sha256-ByoNbkhl6LDcDb/m6+1o+uI1EkIig17wPlgU1BTYwBI=";
    };
    aarch64-linux-310 = {
      name = "torch-2.11.0+cpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.11.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-x9uuOlzQpKPqt2B0K5vjvXkoIllIjPgxdhl87zHOFhA=";
    };
    aarch64-linux-311 = {
      name = "torch-2.11.0+cpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.11.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-RvuwqiV7t4Hvv61kj1sEXA4jJXO2YfFGFZPbYTQukJY=";
    };
    aarch64-linux-312 = {
      name = "torch-2.11.0+cpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.11.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-cOyyZZr2Nzt8UzbmkuZlYFsCAeoh/1Gq6kfh116mtao=";
    };
    aarch64-linux-313 = {
      name = "torch-2.11.0+cpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.11.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-SLPiGjEURazdCyfxODDiHZOt73DUch4FHp8Fm665uPk=";
    };
    aarch64-linux-314 = {
      name = "torch-2.11.0+cpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.11.0%2Bcpu-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-cWdvapqEu9OF4BAZi1H6HCMk+488USoy0sga9l9o9Mk=";
    };
  };
}
