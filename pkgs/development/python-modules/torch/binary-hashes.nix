# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.0.1" = {
    x86_64-linux-38 = {
      name = "torch-2.0.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.0.1%2Bcu118-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-LOOKbk6nxLf1uqUeZSQ6X2h/bhmreRW6WypDEQX1C74=";
    };
    x86_64-linux-39 = {
      name = "torch-2.0.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.0.1%2Bcu118-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-61XynbV0TtqKlvVZTmN9rtDVIngnMAXedZlw5nz6alo=";
    };
    x86_64-linux-310 = {
      name = "torch-2.0.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.0.1%2Bcu118-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-p6SdRZv0hi9k97waaL7M+IgcL6nz4FaWCOFrpvhev3s=";
    };
    x86_64-linux-311 = {
      name = "torch-2.0.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.0.1%2Bcu118-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-FDtsZYwX1DN24t+6osEG01Y51hXl6N7EQpzx5RDdjWE=";
    };
    x86_64-darwin-38 = {
      name = "torch-2.0.1-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.1-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-Gttg02nyZQysjpqVsdV1jiXVJqNICPdEjQvVmeSukHI=";
    };
    x86_64-darwin-39 = {
      name = "torch-2.0.1-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.1-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-xi35k1K9buWlqNGDJFIRBDXReLUWTeRQgxo6jMFNxoA=";
    };
    x86_64-darwin-310 = {
      name = "torch-2.0.1-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.1-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-Vn+E1lftxVgtcWkAVD5uYjU9videYc3DbtpJKeRt+ec=";
    };
    x86_64-darwin-311 = {
      name = "torch-2.0.1-cp311-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.1-cp311-none-macosx_10_9_x86_64.whl";
      hash = "sha256-72VEJ9kWABKYZGRONd7qdh+x/hMXEBgLlSpvLiIHB14=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.0.1-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.1-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-G8/8FrieKWgmszuY21Fm+ZDjtyZUorkGc+gXsWxQ4ys=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.0.1-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.1-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-ZxolZeP2O4/o5Crj42rSSf5eVnQ16ie5TtqmcqfQxBY=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.0.1-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.1-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-eHtaeKp5F0Zem5Y5m4g5IMiKCPTrY7Wl0tGhbifS+Js=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.0.1-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.1-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-JapDyoDc3zLxPaBMUD7Hr9+Od+OgGD3YXNPlOyhC5Sc=";
    };
    aarch64-linux-38 = {
      name = "torch-2.0.1-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.0.1-cp38-cp38-manylinux2014_aarch64.whl";
      hash = "sha256-CIIkN1X/KIlejm3GvCbrz1qgkR7YGyoS8kH8SwkHWxM=";
    };
    aarch64-linux-39 = {
      name = "torch-2.0.1-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.0.1-cp39-cp39-manylinux2014_aarch64.whl";
      hash = "sha256-Qj4K4le3VrtFpLSQcgRnctGtDFkiZcUIAHDgdn2k5JA=";
    };
    aarch64-linux-310 = {
      name = "torch-2.0.1-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.0.1-cp310-cp310-manylinux2014_aarch64.whl";
      hash = "sha256-NZv6rZTRzaAqt3XcHMOG1YVxIym7R7h0FgfvbvSVB0c=";
    };
    aarch64-linux-311 = {
      name = "torch-2.0.1-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.0.1-cp311-cp311-manylinux2014_aarch64.whl";
      hash = "sha256-tgGbHeSXjpbaoh1qPrtB6IoLR0iY/iUf2WGJWHQIhz4=";
    };
  };
}
