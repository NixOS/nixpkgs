# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.0.2" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.0.2-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchaudio-2.0.2%2Bcu118-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-lU3njk8Gb+lvpvQYtfHX1Y0bD7z2otNzDwQaL9eW93I=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.0.2-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchaudio-2.0.2%2Bcu118-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-MixBw26OYv03qzURSmeSGuVCvNlA1YPNE+DhUUHISPk=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.0.2-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchaudio-2.0.2%2Bcu118-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-JmkmReoGGgBcV+xYGi0EJSEKxrqfkj7fEcybDvOhEek=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.0.2-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchaudio-2.0.2%2Bcu118-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-e8C1Cg2DokvcORYnDCOTQ0WshDUd92vTuwiDS9snHfY=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-2.0.2-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.2-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-qCg91hxXnqWxTWdzu8C/hFc7ErN/BfArtLJCXXd2coQ=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-2.0.2-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.2-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-ETihw52iRFocrKIN3OHnfJZX6SJj6zQ3YCT1F/UoTUs=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-2.0.2-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.2-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-gMZNq7nYwzvG8qjgx+vhfqh/UCiTHA1qL3O54WtSctA=";
    };
    x86_64-darwin-311 = {
      name = "torchaudio-2.0.2-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.2-cp311-cp311-macosx_10_9_x86_64.whl";
      hash = "sha256-psuoDZqzouwTF83Fy8BlShiaJuPYso75+DM2FZ/V5ek=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.0.2-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.2-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-KMm+gwYI+TyQZ3Dre0iAli+P75vVJ1rFtIyFDzzEvDI=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.0.2-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.2-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-3l2Uy4MFwAJo37xXbKfkRfQIkeAkqeXijGOtn4UeVBo=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.0.2-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.2-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-FhlnNQD+CK6WtxlS8D7Px059CEPNmIIZPQZCqCck9Tc=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.0.2-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.2-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-FTJxMrKPNJY7qm/hgTAwpjTSWBqpyhIPcwwej6vcEQI=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.0.2-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.0.2-cp38-cp38-manylinux2014_aarch64.whl";
      hash = "sha256-7gjsMDBQQFmY50oKNkmu5NFkCMLrS7H4x6cmMYsc4bc=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.0.2-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.0.2-cp39-cp39-manylinux2014_aarch64.whl";
      hash = "sha256-p08z2gs8U7dw9YOgLKvVkZbwift3pl6znNXYEbWiHWM=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.0.2-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.0.2-cp310-cp310-manylinux2014_aarch64.whl";
      hash = "sha256-2t8je0/RVaPSE73+/+3tR/WlU9ODgXUAQ4tE8k+lOFE=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.0.2-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.0.2-cp311-cp311-manylinux2014_aarch64.whl";
      hash = "sha256-sirOqh7FozEMwVZC0Z3QDVOnzjmbkJatHeoLJOUJevM=";
    };
  };
}
