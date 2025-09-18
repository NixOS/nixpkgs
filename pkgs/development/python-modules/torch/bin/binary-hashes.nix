# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.8.0" = {
    x86_64-linux-39 = {
      name = "torch-2.8.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.8.0%2Bcu128-cp39-cp39-manylinux_2_28_x86_64.whl";
      hash = "sha256-uTV6h1laPXsqVlumArlzkqN8VvC4VpjwzPCixY++9ew=";
    };
    x86_64-linux-310 = {
      name = "torch-2.8.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.8.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-DJaZnRXPHxPdfJE+CyGpo1VTjmz8EIYaFxWDICkvWVQ=";
    };
    x86_64-linux-311 = {
      name = "torch-2.8.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.8.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-A5udzda9uqEKilzWviLEyz41iaNB5fkEy7Vxyij1W+0=";
    };
    x86_64-linux-312 = {
      name = "torch-2.8.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.8.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-Q1T8Bbt5sgjWmVoEyhzu9qlUexxDNENVdDU9OBxVCHw=";
    };
    x86_64-linux-313 = {
      name = "torch-2.8.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torch-2.8.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-OoUjaaON7DQ9RezQvDZg95uIoj4Mh40YcH98E79JU48=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.8.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.8.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-a+wfJAlodJ4ju7fqj2YXoI/D2xtMdmtczq34ootBl9k=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.8.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.8.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-pGe0n+iTpqbM6J467lVu39xkpyLXGV/f3XXOyd6hN3k=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.8.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.8.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-PQUBfRm8mXQSiORYiIKDpEsO6IHVPwX3L4sc/qiZgSI=";
    };
    aarch64-darwin-312 = {
      name = "torch-2.8.0-cp312-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.8.0-cp312-none-macosx_11_0_arm64.whl";
      hash = "sha256-pHt5hr7j9hrSF9ioziRgWAmrQluvNJ+X3nWIFe3S71Q=";
    };
    aarch64-darwin-313 = {
      name = "torch-2.8.0-cp313-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.8.0-cp313-none-macosx_11_0_arm64.whl";
      hash = "sha256-BX79MKZ3jS7l4jdM1jpj9jMRqm8zMh5ifGVd9gq905A=";
    };
    aarch64-linux-39 = {
      name = "torch-2.8.0-cp39-cp39-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.8.0%2Bcpu-cp39-cp39-manylinux_2_28_aarch64.whl";
      hash = "sha256-6si371x8oQba7F6CnfqMpWykdgHbE7QC0mCIYa06uSY=";
    };
    aarch64-linux-310 = {
      name = "torch-2.8.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.8.0%2Bcpu-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-shSYWLg0Cu6x8wVuC/9bgrluQ7WW/kmp26MYRSImEhM=";
    };
    aarch64-linux-311 = {
      name = "torch-2.8.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.8.0%2Bcpu-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-aAEp797uw9tdo/iO5dKMGx4QO3dK70D51jjizOj42Ng=";
    };
    aarch64-linux-312 = {
      name = "torch-2.8.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.8.0%2Bcpu-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-YQ9gDBAjhuWBMn1e/BjA1u3suYILQUDSYWM1SpnNgA0=";
    };
    aarch64-linux-313 = {
      name = "torch-2.8.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.8.0%2Bcpu-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-pQZLXiN3LI0WQGjMfBLgGnX697lI7NlaDUAH10h+XyU=";
    };
  };
}
