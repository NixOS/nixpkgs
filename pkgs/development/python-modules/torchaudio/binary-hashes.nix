# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.13.0" = {
    x86_64-linux-37 = {
      name = "torchaudio-0.13.0-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchaudio-0.13.0%2Bcu116-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-OvF+dT8O2tLcb4bfIyWLUooFuAjBnYfK+PeuL9WKmWk=";
    };
    x86_64-linux-38 = {
      name = "torchaudio-0.13.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchaudio-0.13.0%2Bcu116-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-bdL04MnHV95l93Bht8md/bMZHPKu7L6+PUReWdjZ27Y=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-0.13.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchaudio-0.13.0%2Bcu116-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-gY+ISeHQukn5OxpU4h/sfBXGDoMpp2a/ojfsMb/bKfs=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-0.13.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu116/torchaudio-0.13.0%2Bcu116-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-BV1qgrCA1o8wF0gh8F2qGKMaTVph42i4Yhshwibt1cM=";
    };
    x86_64-darwin-37 = {
      name = "torchaudio-0.13.0-cp37-cp37m-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.13.0-cp37-cp37m-macosx_10_9_x86_64.whl";
      hash = "sha256-UjOFPP1gy/OmsBlOQB2gqKhXV/SyLc70X+vF00r3src=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-0.13.0-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.13.0-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-QuigF0HACNRPZIDOBkbHSF2YwpwBXHNiUWbbEkByn3Y=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-0.13.0-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.13.0-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-i/P/vBwdJUJimtHsBkzwG8RiIN53pJo5s2xnB+aMlU8=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-0.13.0-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.13.0-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-K3vMX0qIFMIqZrVa0tjiMBXAgazJkGPtry0VLI+wzns=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-0.13.0-cp38-cp38-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-0.13.0-cp38-cp38-macosx_12_0_arm64.whl";
      hash = "sha256-qr3i19PWbi1eR0Y0XWGXLifWY2C4/bObnq3KTHOWRxM=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-0.13.0-cp39-cp39-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-0.13.0-cp39-cp39-macosx_12_0_arm64.whl";
      hash = "sha256-uQnAQRdWGwDV5rZTHTIO2kIjZ4mHoJyDJsFqCyNVbcA=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-0.13.0-cp310-cp310-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-0.13.0-cp310-cp310-macosx_12_0_arm64.whl";
      hash = "sha256-6gUo8Kccm1FRjTBGActHx1N01uq6COFnlMH5lmOuTCA=";
    };
  };
}
