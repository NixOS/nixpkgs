# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.13.1" = {
    x86_64-linux-37 = {
      name = "torchaudio-0.13.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu117/torchaudio-0.13.1%2Bcu117-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-wQJJ2BPkQAGxXx8H0rt3P39wsl/6KhbF27wYHT5L6/o=";
    };
    x86_64-linux-38 = {
      name = "torchaudio-0.13.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu117/torchaudio-0.13.1%2Bcu117-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-QCY7LUVyj7/x2zOBJyvkKXD/blj5KZSqWHKlvUx+cmQ=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-0.13.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu117/torchaudio-0.13.1%2Bcu117-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-Zbs2FdQz1bkwrNwQNu+xJAR9VxfbpN63D0GSkNlC+DY=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-0.13.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu117/torchaudio-0.13.1%2Bcu117-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-k/RVSktT+WmNAiJJA8kjwSpsIrPJQtz8IXm1gdjzcUY=";
    };
    x86_64-darwin-37 = {
      name = "torchaudio-0.13.1-cp37-cp37m-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.13.1-cp37-cp37m-macosx_10_9_x86_64.whl";
      hash = "sha256-D6fMGiswVvxs7ubWDbze9YlVp8pTRmfQ25tPye+gh6E=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-0.13.1-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.13.1-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-Qs5cZtMEvCzWgziRa4Ij4yLgmoTcvZIogU7za8R3o3s=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-0.13.1-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.13.1-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-nSFwVA3jKuAxqrOTYSmGjoluoEFhe21mkt3mqi37CiM=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-0.13.1-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.13.1-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-Xg89xmmVBlITZCZnBOa/idDQV5/UNdEsXC9YWNUt5Po=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-0.13.1-cp38-cp38-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-0.13.1-cp38-cp38-macosx_12_0_arm64.whl";
      hash = "sha256-sJOz52YchRaOyd3iz5c0WWXqCTHT0qfni9QJIh5taZg=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-0.13.1-cp39-cp39-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-0.13.1-cp39-cp39-macosx_12_0_arm64.whl";
      hash = "sha256-kfz79HAAQC0Sv/JiTmIgoP07jKjub/Ue31lF7DmrCn8=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-0.13.1-cp310-cp310-macosx_12_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-0.13.1-cp310-cp310-macosx_12_0_arm64.whl";
      hash = "sha256-7HKhfU0heIKed4BoKZm1Nc9X/hYNDCCw1r3BrRqHxN0=";
    };
  };
}
