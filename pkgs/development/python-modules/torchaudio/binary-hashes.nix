# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.3.1" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.3.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.3.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-4QoP0bNR6EnnzZ4ekw3KP/uMow+WI5vqEx8YP2WUXNs=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.3.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.3.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-bOv8CdkcpAPASLnPKuPWS09UzzGghYTQ0/v3+VAewNw=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.3.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.3.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-C0I/SuM1bxH2cj6MdyCKw/k2Gk+UHkzAjYbDLBN1lLw=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.3.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.3.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-LZE2vzybarltxC8m9suDbUXRFfV2bhav9Sg1yOfN5WU=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.3.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.3.1%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-sAdz3eOqMNmxuYh1ZQQo+/tp/jC5jrtc7/vY/GHegSU=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.3.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-zkXgWs1URpbGpvAj1P6GFK3ldRV5mhEDskGOhUg41KU=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.3.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-NujAtlMlccJ6CKQNrkKM00ryJQB/FbzXcnJkO2JmuB0=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.3.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-H5E0sn5afwweMzgvwP4njlNpV2jLCvAujSK1AGx0oq0=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.3.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-AZhPODmMpemOz7/q+3KuWyEx0LuKpGS1d3rds+SCaHc=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.3.1-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.1-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-XjZoVCCgehdhRunW4PqCJRmPEm4WegB4VTj4U4B+LUM=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.3.1-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.1-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-n9D0u8P9WF+9fZdqmI/m54P8suDbnXDaxg9AvgcsZQQ=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.3.1-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.1-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-TjvKIy+CDGoPpTlEJAdsxRn64yKI5/9vbWi9cXlNw1Q=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.3.1-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.1-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-a1fnc6rXJ0PVCmSnQCoGy4vfzHCe/G2MJkKdlA5niOI=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.3.1-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.1-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-yMcnyDQYJb0Y2RAXxMAPNrU7CPIXbNub3LDe8cRQsh0=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.3.1-cp312-cp312-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.1-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-Qq9sekMOYmjywCjgYHjUE5ErXsbvoooJfr3Tw8eWWd8=";
    };
  };
}
