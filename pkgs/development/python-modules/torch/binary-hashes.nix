# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.3.1" = {
    x86_64-linux-38 = {
      name = "torch-2.3.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.3.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-TkEPNC/YbHO+oO0kVQnV/15od72lSySfdaM9U1yHfy8=";
    };
    x86_64-linux-39 = {
      name = "torch-2.3.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.3.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-3+phA2LA4qX/KNMi1qpl1l4D4TNJlhGaWjdwx9GCGsQ=";
    };
    x86_64-linux-310 = {
      name = "torch-2.3.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.3.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-8N610vkypo7VRiW6FA7dvyryK+l47hm5tjyYat1kJbI=";
    };
    x86_64-linux-311 = {
      name = "torch-2.3.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.3.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-kl40rwkFBipItPgtDmZWNBrU1iaDSmqCRe9OruU3XJg=";
    };
    x86_64-linux-312 = {
      name = "torch-2.3.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torch-2.3.1%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-s8WG9Ksl6D7//M+5cHnpEyUym8IoFmVVxLuTlXdT1Oo=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.3.1-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.1-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-vuC9M9xYqo/Ip1J4dum5oOgSrQgSIFSlv/LOWr8AWxA=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.3.1-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.1-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-K7WveAxVvmj+EA/rBSjS7eus4dVcsuNR3nNYCbpzkes=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.3.1-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.1-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-fAmpQ2J3hChIS8+ZX2AEsElSEGruDvRf8LS6tIT1SY0=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.3.1-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.1-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-p91O04itHz1QK/CUU9X+WWx7Eh3n4M+soeIBd4Lpu6w=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.3.1-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.1-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-PDM9wuvBiVYVFO2gboHfIr+Ptk4jhHRrLLnwT5bR1Mg=";
    };
    aarch64-linux-38 = {
      name = "torch-2.3.1-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.1-cp38-cp38-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-O3wUmPkE9n6x4zHy6+h0J3GiznG57pvAHelnJX6IHH0=";
    };
    aarch64-linux-39 = {
      name = "torch-2.3.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.1-cp39-cp39-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-22v/S6YnO1muRD3gS1rcNtakC7KJiGYTO/8tUvJ26v4=";
    };
    aarch64-linux-310 = {
      name = "torch-2.3.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.1-cp310-cp310-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-ZUT98pAYZowKbUobzJVZgsGtpwgGKBsBDLqTvc+9zyI=";
    };
    aarch64-linux-311 = {
      name = "torch-2.3.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.1-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-Kq8ON3NMvF/mv8yBraNuy7iZ1N2+E0mL2EqsqKkchig=";
    };
    aarch64-linux-312 = {
      name = "torch-2.3.1-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.3.1-cp312-cp312-manylinux_2_17_aarch64.manylinux2014_aarch64.whl";
      hash = "sha256-d9LeGklaHAf1ksM4oNWS5VzAudL4ADCeRqDqLA46KRk=";
    };
  };
}
