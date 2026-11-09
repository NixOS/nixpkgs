# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.11.1" = {
    x86_64-linux = {
      name = "torchaudio-2.11.1-py3-none-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu132/torchaudio-2.11.1%2Bcu132-py3-none-manylinux_2_28_x86_64.whl";
      hash = "sha256-D+Axhc8vbgSSxiK8zmIiskkmRsjmUfmP88Gz6FRLGu4=";
    };
    aarch64-darwin = {
      name = "torchaudio-2.11.1-py3-none-macosx_14_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.1-py3-none-macosx_14_0_arm64.whl";
      hash = "sha256-kXZnqz41fShrDiQFoz3FOOQ0TVVLcuGysDOCpDUsqFc=";
    };
    aarch64-linux = {
      name = "torchaudio-2.11.1-py3-none-manylinux_2_28_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.11.1%2Bcpu-py3-none-manylinux_2_28_aarch64.whl";
      hash = "sha256-aE1BjVqiyYqN/5pOiRGCXaEQnNqbnnV+r1j/lCjEV3s=";
    };
  };
}
