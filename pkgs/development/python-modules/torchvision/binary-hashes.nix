# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.15.2" = {
    x86_64-linux-38 = {
      name = "torchvision-0.15.2-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchvision-0.15.2%2Bcu118-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-r2gH1eWZ/lOByRYjWlWBQH6FDrd8PUOJnzehUR/4HMA=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.15.2-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchvision-0.15.2%2Bcu118-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-8sb1oQC8+QILgvXUyHzX4mrwQJzzO5D7eXsRJ9zULeY=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.15.2-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchvision-0.15.2%2Bcu118-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-GcpKtdYXm75Tz/ed8ahV7mUzwoYd3HOJ9oNJ2Ln4MCo=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.15.2-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu118/torchvision-0.15.2%2Bcu118-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-3vmvR+vCytVcWqLa0SMNz0Jhgz7W34pz6Dm8Izdk8J4=";
    };
    x86_64-darwin-38 = {
      name = "torchvision-0.15.2-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.2-cp38-cp38-macosx_10_9_x86_64.whl";
      hash = "sha256-jxJBW2htuohPsIb1OsgD9pK+WlzdinWPUIErMP/+ouQ=";
    };
    x86_64-darwin-39 = {
      name = "torchvision-0.15.2-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.2-cp39-cp39-macosx_10_9_x86_64.whl";
      hash = "sha256-R5AmD89HikHH7MYKbVIAqIFZ/djXVunynw+MWcSmemg=";
    };
    x86_64-darwin-310 = {
      name = "torchvision-0.15.2-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.2-cp310-cp310-macosx_10_9_x86_64.whl";
      hash = "sha256-d1QIh3ToEMVnKxQqRdzyCxvZhqWn2pD4ZgxD3EP7hQw=";
    };
    x86_64-darwin-311 = {
      name = "torchvision-0.15.2-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.2-cp311-cp311-macosx_10_9_x86_64.whl";
      hash = "sha256-XzX2vVvMRWjmUi5BN/pg/McvT6PmFTIcJs2H6FWs05g=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.15.2-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.2-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-MSEcAfi47DO4pjgye1RjIS55oD5DyJX4gEn5evG9Ev0=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.15.2-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.2-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-mHq2IiW0FRoR5T/QYVDFJYztJKydfFR+Dkq2+8qSpc4=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.15.2-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.2-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-N+sTjhP2ISU3owCawhhpVIOmNcQEtswdjg0Nl4AmqG0=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.15.2-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.15.2-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-dXUFoKsr5wlsudK/RyMgLJcczt23LHlSp+h393PeD4o=";
    };
  };
}
