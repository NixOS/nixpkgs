# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.18.0" = {
    x86_64-linux-38 = {
      name = "torchvision-0.18.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.18.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-wkg7LMYiePuqa2fSqdgI0kUET4tkqCFZbq5o7GoNXtA=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.18.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.18.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-G/4MZ/1UYaOlk/jxfhVE8Hpr1mhuFVIA3SRJRwdPzVE=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.18.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.18.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-E+G0jcXOQcy4EAqz3Sb98x2PHpBOzyhlrFJEkwE9DfU=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.18.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.18.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-HlFneVIPySFX1sskWsD9P3mHL+gchLhZOo8umYEG9bE=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.18.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.18.0%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-cA9gGb6+6eDuiwvL2xWIgJyUouuUeh/eLgatw0tg2io=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.18.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-IRWhkGwBX12pzu3ECpgzE7D9biyKFxCKkpkXBvUfaYc=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.18.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-deIuz0ShO4+VuK1CHAJhKC2FnGGBa62soZWeBzzN1pE=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.18.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-3WFiij0YnGhSoS3F7UzS7s5m0tZ/Nahmyxbx3LBsjGI=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.18.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-aJalIWi+/hEF+zyTNShzkO0ifnHR5OxNaLYuijCZ/Ak=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.18.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-652DwOHbtU7LD7BMh/eGMz46b7i5xACsp8MQgfmqVwc=";
    };
    aarch64-linux-38 = {
      name = "torchvision-0.18.0-cp38-cp38-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.0-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-kl0KgszPb5hsGLKbQ5KpQttly9tzwToSnISTgi65428=";
    };
    aarch64-linux-39 = {
      name = "torchvision-0.18.0-cp39-cp39-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.0-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-Nu/YcAHGvuI4PgQ+RqAlr/sDF5dHyPR3e5kYUn/851Y=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.18.0-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.0-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-Uzf2rPof6VnVyzQNAaAGFNazHOekgkzLlUNahcUnO5U=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.18.0-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.0-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-5aJNYgzqFKS7ifJKorUGIwwKFqOtpX/FOtgM/SVqISg=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.18.0-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.18.0-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-qWSvvH3fUKRrlBR39sNXKbQW3u3ROXVr79SIJF4uIm0=";
    };
  };
}
