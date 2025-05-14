# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.7.0" = {
    x86_64-linux-39 = {
      name = "torchaudio-2.7.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.7.0%2Bcu128-cp39-cp39-manylinux_2_28_x86_64.whl";
      hash = "sha256-DppKLE9UPO/voB3UD0nExEBvve0KcpWpkVgnZ4NFeQ8=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.7.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.7.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-1itum3kq03r20SibooPhAp5xtP+c08bPfw53dvIyVLI=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.7.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.7.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-lB9ZwDc5DiiLznmPnOU9wXuJT3B/f0a1C6OqHDFE0oM=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.7.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.7.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-G/R44k6Uqkm2gua2q0gZmMtULQb3faqar8ks7daiESc=";
    };
    x86_64-linux-313 = {
      name = "torchaudio-2.7.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.7.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-TgfEDMFF6GS6I5n9+27t78aC9kYk8rjYv1ZwPDEBAFw=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.7.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-DUIaoiW5NWTJjTuhbxlg3uLtyLTjdfYlGftR4sSJwSM=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.7.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-HEpkbJ6TR4NsCell7rxY3QKOxu80xG0+eJG//Y3GReo=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.7.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-hi2cXP4VaIp4RpYrXTyflZvv/oKx5UQZNcejdQTFxec=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.7.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-ZbT8m38oNn+RiwKuTbQpBFe8T90WDyK31oTpOrjcuVY=";
    };
    aarch64-darwin-313 = {
      name = "torchaudio-2.7.0-cp313-cp313-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.0-cp313-cp313-macosx_11_0_arm64.whl";
      hash = "sha256-FQ+95B2mApbv/tdyt6Fw9WPNRJZ1VauwYD/Fc/Oc4kU=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.7.0-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.0-cp39-cp39-manylinux_2_28_aarch64.whl";
      hash = "sha256-DopLBfFZ/7qBB5ic3vKKqyaWMH88f3i7nS4K9z7smAo=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.7.0-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-nkBzmS9PjnET5LUF2VCVNhzrLyHde5MQd2FgokJm+PY=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.7.0-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-Z3vTIDExDuc6R9buvC5050wc9GeTKUXuiAgqOTW1yVA=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.7.0-cp312-cp312-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-MwBO1H8Y8ABEyX7ozZ4/XhwuJu8j1PcrXxrjPmGCWHs=";
    };
    aarch64-linux-313 = {
      name = "torchaudio-2.7.0-cp313-cp313-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-nZIe6wNlEqh+/eAHl3snvTJjIM181fQxlYJBc/6C6Ig=";
    };
  };
}
