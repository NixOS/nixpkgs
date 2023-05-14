# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.0.1" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.0.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchaudio-2.0.1%2Bcu118-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-lLDpx2ypHR4CiYlZIPv+jBF0ZNdXtktd+tsTCM+ZBPk=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.0.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchaudio-2.0.1%2Bcu118-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-Bws4SWlhQr49keCycHbaHz+MtDKrzONc2VbRkfwNgYc=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.0.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchaudio-2.0.1%2Bcu118-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-GcTvkBIyTE+4DqZpNFUbeAfZcUjChTji6rr+FqtQ6Rw=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.0.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchaudio-2.0.1%2Bcu118-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-GicitvZleO3FY+d7TMB6ItZjorte5cneJTlmGpihTbk=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-2.0.1-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.1-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-AiyhuqS7gZt4NDvUe1f/bcb5/Bn6TvJplGqt9+Yts8A=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-2.0.1-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.1-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-48bI+eqfDi33oLk3Ww3PlVkG44/BL6tUK3KoYVZK+Oc=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-2.0.1-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.1-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-tdIeu7VecEDUGNUGKw6IL5Zg1otHezj9Q2+mySzLtSo=";
    };
    x86_64-darwin-311 = {
      name = "torchaudio-2.0.1-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.1-cp311-cp311-macosx_10_9_x86_64.whl";
      hash = "sha256-4qBHZ1STwKolj+xiHvQOiwGr49jbyHIVLktZmEGKo8U=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.0.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-oVOtXNti3o7J/RNgoNCAu6851XiuBOeI2yEVceZ1t+A=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.0.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-HQzwd5ozTsGGHp+ii862amM8Quj2szIuLjf/nyDQroE=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.0.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-bbzZOynXGi9QDzajTqXkZ/UQ93PahTIgmOa92MncmUg=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.0.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.0.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-kaKOWH9wigMyDt28xKfdGtcVCz1IRrbBVX2FzImo0Gw=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.0.1-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.0.1-cp38-cp38-manylinux2014_aarch64.whl";
      hash = "sha256-qlsjzsMVcWRKpn1s1QGzl/QmVX3F8y6NtuzbJ7GUClg=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.0.1-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.0.1-cp39-cp39-manylinux2014_aarch64.whl";
      hash = "sha256-ry16SysebkDnnA7d0Qezu0MVkdBJTX+X7ffBhkN7XBo=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.0.1-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.0.1-cp310-cp310-manylinux2014_aarch64.whl";
      hash = "sha256-6f/6Y0Gbxl7Pg5Vo3QS+O6VibF9bJsmlZsA4KtKXcck=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.0.1-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.0.1-cp311-cp311-manylinux2014_aarch64.whl";
      hash = "sha256-MkQuKxHfwJxMW2zEuSTT84wslGPuKOSGUi+fSLCbf7c=";
    };
  };
}
