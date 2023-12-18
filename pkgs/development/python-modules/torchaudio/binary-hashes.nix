# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.1.2" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.1.2-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.2%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-nptbhxqUhL5rUK687w+M8Cb5w9MLhtfEz0mHbDAwGBU=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.1.2-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.2%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-L1s1TSIGHHm4fdDBoIQamQVtMuqNuIIf2NZz1rB3wbI=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.1.2-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.2%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-HoqSB2Mei6bsve48nWbx6dQ4rWKwtNTxhAFti+idaKc=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.1.2-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.2%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-jFpvXk1EDXfU/KxVFV7/xGSpkGIddkinFVZ7eJWr8nU=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-2.1.2-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.2-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-0O/QCMNd7JYrgPXc40aL0biDAc9lFSu/p/dMAAWhfok=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-2.1.2-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.2-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-rlDc801cb3MYDPaUGV7jEZS51gkDKFdcMKWWC8cW+lI=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-2.1.2-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.2-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-BvjAKBTmzdeGJrv0StK7ivpbOatlDGrxgyijIxFGEFg=";
    };
    x86_64-darwin-311 = {
      name = "torchaudio-2.1.2-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.2-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-wQhO7fTO0a+f3RiRBpD/YV+JuuswsyAwgGVD+8bzZX4=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.1.2-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.2-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-MK2XESQSWSUYlT88ws0bauFT1lY91b2eq2qXIxX+nZ4=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.1.2-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.2-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-FHKcyd9S3vpnT89e1N4NZQcDjvGAErlqL1anftcGdt0=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.1.2-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.2-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-nWdmc8HOTdEfyhReOmzZtOW4l8/60PYX0pBvLT/Iw6k=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.1.2-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.2-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-hgrMMuZQcGPywT2B4mcYGZ4hXzSivNbJYJol6b8hqjY=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.1.2-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.2-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-/3FWsw6wXpEkKGwwyA2oS5PiJ9AJrblusZSJYAtFkzI=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.1.2-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.2-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-s7u1Mk5wXe13YW5UZZGySa51iNNaPowsTB2Yal6lHvQ=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.1.2-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.2-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-+CZX/E7DtHO/bHUsDuYtf1Ea+e835RQ/gznsBJUE12c=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.1.2-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.2-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-mmut6KJJWnJPTuastehoKP9Ag9xsfFfGOGtUoOp6/nE=";
    };
  };
}
