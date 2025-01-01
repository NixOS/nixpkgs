# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.5.1" = {
    x86_64-linux-39 = {
      name = "torch-2.5.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.5.1%2Bcu124-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-1oG4vj/cLNQREjENs8OQT3xqCaeuKNBCrgrzrwHI/No=";
    };
    x86_64-linux-310 = {
      name = "torch-2.5.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.5.1%2Bcu124-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-nd4w85nKIhN0Vcyk1HFA37f0F24tFqlyn8BE7r+tsTo=";
    };
    x86_64-linux-311 = {
      name = "torch-2.5.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.5.1%2Bcu124-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-aylm7emv/i/WngdlaRynI+yHDgw0x3YfTVuOMYOD/a8=";
    };
    x86_64-linux-312 = {
      name = "torch-2.5.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torch-2.5.1%2Bcu124-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-v2SEv+W8T5KkoaG/VTBBUF4ZqRH3FwZTMOsGGv4OFNc=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.5.1-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.1-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-gEZ2i39tNbhdEBtLOMuoqi881RlSvEwGpJWA8s5oIpE=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.5.1-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.1-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-I9Biv3B3aj0E2+dNuVDbKlJF4bpPJyCKh/DXQ7DQboY=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.5.1-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.1-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-MfjDlmCWL5rk7uyZXjBJtUkutzYN1PBzd2WO9Nco+kw=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.5.1-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.1-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-jHEt9hEBlk6xGRCoRlFAEfC29ZIMVdv1Z7/4o0Fj1bE=";
    };
    aarch64-linux-39 = {
      name = "torch-2.5.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-x09z2hefp+qiFnqwtJPyZ65IGmwAckniZ0y9C69KXME=";
    };
    aarch64-linux-310 = {
      name = "torch-2.5.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-JpsQw0Qwqo6WQ9vgNdxSXEqbHWcc09vI7Lyu0oCuMi0=";
    };
    aarch64-linux-311 = {
      name = "torch-2.5.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-1bMgPxkbxAeDyZSI0ud23Pk6xDGllJHWJ6HKWzriCyI=";
    };
    aarch64-linux-312 = {
      name = "torch-2.5.1-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.5.1-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-NtG+mSgbb2Atljm9CvPuAAbnqrFvZxjYb3CdOVtvJiw=";
    };
  };
}
