# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.3.0" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.3.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.3.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-Q/Iv/36izuH9uzAqE26aC51XFTUXaaYn1JDGfKzsCfQ=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.3.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.3.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-4n2qE/jPQ8sLyq81TIEj7qlpBsg/FDNCZiCSvMH7atc=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.3.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.3.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-OLSTk/jDItyqKdGeWsv1oLGXjPG3GURatnDx+0huOqY=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.3.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.3.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-jdZpE+ewjGPHayGwcGEwwkruTtStwLwS+NYt+YtcbqA=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.3.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.3.0%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-IA7PUlHYPRTook/X9V3odqrSVR/5jqvxzdhCeQXJXFU=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.3.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-e6kyZUVdw2M4XpjAz8rrWGt0Aa+KLIJIEe4UZhNKTzA=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.3.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-9Lkzd28go2r13cV5aPyz2jTdA4gduNZ2Dz4RdoA7nPg=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.3.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-NCEI2oOqGaRXyaEosSBvrbYDdTtRzKAiufWFqsL0dUw=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.3.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-NByjBIzm7cxzFRmzAYfwsTrLJFxO/hb5JfafnVM1RuE=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.3.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-U1FEovu6lfuzuIMiT/z0R4jkzsurvknEoa4+enT3FIU=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.3.0-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.0-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-7Rhm9QjcaJxPaC0zCy7UyDEI01hl5PuJQxgZNk2K2e0=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.3.0-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.0-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-0kO7ih7iY8LNr7n+7RVpw3QtgTVzHo94GN4S9ODIPig=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.3.0-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.0-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-5btQt6SHTtlwhsnlFt2QsQPZVO3LXtSzb0/CLEAApac=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.3.0-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.0-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-Ye2wKunA7+pDmfnB+JlgETayTzXUMFSChOqOr2zL474=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.3.0-cp312-cp312-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.3.0-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-ZoqLaU5VIs/yjNXgLQGqG3XOlAqp+0BICJK9xiOxc10=";
    };
  };
}
