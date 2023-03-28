# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.0.0" = {
    x86_64-linux-38 = {
      name = "torch-2.0.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.0.0%2Bcu118-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-H4766/y7fsOWL9jHw74CxmZu/1OhIEMAanSdZHZWFj4=";
    };
    x86_64-linux-39 = {
      name = "torch-2.0.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.0.0%2Bcu118-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-6rl6n+WefjHWVisYb0NecXsd8zMcrcd25sBzIjmp7Tk=";
    };
    x86_64-linux-310 = {
      name = "torch-2.0.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.0.0%2Bcu118-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-S2kOK3fyEHNQDGXYu56pZWuMtOlp81c3C7yZKjsHR2Q=";
    };
    x86_64-linux-311 = {
      name = "torch-2.0.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torch-2.0.0%2Bcu118-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-I4Vz02LFZBE0UQRvZwjDuBWP5rG39sA7cnMyfZVd61Q=";
    };
    x86_64-darwin-38 = {
      name = "torch-2.0.0-cp38-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.0-cp38-none-macosx_10_9_x86_64.whl";
      hash = "sha256-zHiMu7vG60yQ5SxVDv0GdYbCaTCSzzZ8E1s0iTpkrng=";
    };
    x86_64-darwin-39 = {
      name = "torch-2.0.0-cp39-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.0-cp39-none-macosx_10_9_x86_64.whl";
      hash = "sha256-bguXvrA3oWVmnDElkfJCOC6RCaJA4gBU1aV4LZI2ytA=";
    };
    x86_64-darwin-310 = {
      name = "torch-2.0.0-cp310-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.0-cp310-none-macosx_10_9_x86_64.whl";
      hash = "sha256-zptaSb1RPf95UKWgfW4mWU3VGYnO4FujiLA+jjZv1dU=";
    };
    x86_64-darwin-311 = {
      name = "torch-2.0.0-cp311-none-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.0-cp311-none-macosx_10_9_x86_64.whl";
      hash = "sha256-AYWGIPJfJeep7EtUf/OOXifJLTjsTMupz7+zHXBx7Zw=";
    };
    aarch64-darwin-38 = {
      name = "torch-2.0.0-cp38-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.0-cp38-none-macosx_11_0_arm64.whl";
      hash = "sha256-0pJkDw/XK3oxsqbjtjXrUGX8vt1EePnK0aHnqeyGHTU=";
    };
    aarch64-darwin-39 = {
      name = "torch-2.0.0-cp39-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.0-cp39-none-macosx_11_0_arm64.whl";
      hash = "sha256-KXpJGa/xwPmKWOvpaSAPcTUKHU1PmG2/1gwC/854Dpk=";
    };
    aarch64-darwin-310 = {
      name = "torch-2.0.0-cp310-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.0-cp310-none-macosx_11_0_arm64.whl";
      hash = "sha256-U+HDPGiWWDzbmlg2k+IumSZkRMSkM5Ld3FYmQNOeVCs=";
    };
    aarch64-darwin-311 = {
      name = "torch-2.0.0-cp311-none-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torch-2.0.0-cp311-none-macosx_11_0_arm64.whl";
      hash = "sha256-mi5TtXg+9YlqavM4s214LyjoPI3fwqxEtnsGbZ129Jg=";
    };
    aarch64-linux-38 = {
      name = "torch-2.0.0-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.0.0-cp38-cp38-manylinux2014_aarch64.whl";
      hash = "sha256-EbA4T+PBjAG4/FmS5w/FGc3mXkTFHMh74YOMGAPa9C8=";
    };
    aarch64-linux-39 = {
      name = "torch-2.0.0-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.0.0-cp39-cp39-manylinux2014_aarch64.whl";
      hash = "sha256-qDsmvWrjb79f7j1Wlz2YFuIALoo7fZIFUxFnwoqqOKc=";
    };
    aarch64-linux-310 = {
      name = "torch-2.0.0-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.0.0-cp310-cp310-manylinux2014_aarch64.whl";
      hash = "sha256-nwH+H2Jj8xvQThdXlG/WOtUxrjfyi7Lb9m9cgm7gifQ=";
    };
    aarch64-linux-311 = {
      name = "torch-2.0.0-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torch-2.0.0-cp311-cp311-manylinux2014_aarch64.whl";
      hash = "sha256-1Dmuw0nJjxKBnoVkuMVACORhPdRChYKvDm4UwkyoWHA=";
    };
  };
}
