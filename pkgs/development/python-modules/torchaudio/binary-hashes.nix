# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.9.1" = {
    x86_64-linux-310 = {
      name = "torchaudio-2.9.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.9.1%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-YrFkJK9jwOEr6m7+OIm+NYsCBHqWEZmCZz8H8StzmIg=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.9.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.9.1%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-Qwwi7N3ZsYQRe/ZNQdX02NPwNTu2hPMYI2O/gYDj6KU=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.9.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.9.1%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-VOsZ5jS4xWeIahtTtBhFBtlDw7pRORmOn+G5QbxWbzA=";
    };
    x86_64-linux-313 = {
      name = "torchaudio-2.9.1-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.9.1%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-Uil7fft8QuMROFVyvJwBhuYC6hpfIMQpI3Zbrqma/4M=";
    };
    x86_64-linux-314 = {
      name = "torchaudio-2.9.1-cp314-cp314-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.9.1%2Bcu128-cp314-cp314-manylinux_2_28_x86_64.whl";
      hash = "sha256-EsPj06r4VtZ5MopanUbYZryItMUpDyEo8war/5dfpR4=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.9.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-t8tRcrbOZ8q8zFYLgSPe+VA2zRWH4RTcaXont7gdsT0=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.9.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-5qTHlrG129ggvoM4jCCdDxY+9ddKQ6BtUZNg/azTbtE=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.9.1-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.1-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-x3nAOA+7oS1j9WwJPdk74SItbMPK8UCtHYnEpgso7/E=";
    };
    aarch64-darwin-313 = {
      name = "torchaudio-2.9.1-cp313-cp313-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.1-cp313-cp313-macosx_12_0_arm64.whl";
      hash = "sha256-HFIen3D6sugl9rgxrDFKedw39RyNEc1UmMDzyIChIuE=";
    };
    aarch64-darwin-314 = {
      name = "torchaudio-2.9.1-cp314-cp314-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.1-cp314-cp314-macosx_11_0_arm64.whl";
      hash = "sha256-MrZ6VRA+mxElNDErHRlsKmtn4hpXY7qzCPNb9HmFcYU=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.9.1-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.1-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-asvWO+ZK9MstF1vwZo7mpgRgTO8XxlPoBYZvp5V3Q00=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.9.1-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.1-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-nTlW4rz4pn5+hGjXYCCa7Qpd48+91G5K37qAo7wtDXs=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.9.1-cp312-cp312-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.1-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-9vqIK3UDhf2woqpSFaagS5fPlmizdhcDioFMdjCy3I0=";
    };
    aarch64-linux-313 = {
      name = "torchaudio-2.9.1-cp313-cp313-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.1-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-Cz/sxrz+Rvy5BeqCbvY+mgUqbZ0eLNcT9ZpTpQn8i1w=";
    };
    aarch64-linux-314 = {
      name = "torchaudio-2.9.1-cp314-cp314-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.9.1-cp314-cp314-manylinux_2_28_aarch64.whl";
      hash = "sha256-CnA1PulFIGit4h1hgbXaCVn1HThpocgR7O8Xy01nGBw=";
    };
  };
}
