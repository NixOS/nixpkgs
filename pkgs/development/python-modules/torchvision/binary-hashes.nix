# Warning: use the same CUDA version as torch-bin.
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "0.19.1" = {
    x86_64-linux-38 = {
      name = "torchvision-0.19.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.19.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-MFL5ci3Dn9fwJrRKb73vk6so95UgBwEs6E0xPWeWQBE=";
    };
    x86_64-linux-39 = {
      name = "torchvision-0.19.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.19.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-FFMN7gzEx8BgJPC9zJV/d94NK5DptyIZ3NYh+ilSXQA=";
    };
    x86_64-linux-310 = {
      name = "torchvision-0.19.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.19.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-uMxL84G3VSKZW2AeB6G0M7X9kl3D40p/ps0i9EnWU3k=";
    };
    x86_64-linux-311 = {
      name = "torchvision-0.19.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.19.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-U2QXNAaUspzFTDCFB9CYsAy9zB/oaAcqNLVTvtc9nTA=";
    };
    x86_64-linux-312 = {
      name = "torchvision-0.19.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchvision-0.19.1%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-+wzQYi40nfhK1zutjrvqaxx08DPa3YTZqAz0opGSfq4=";
    };
    aarch64-darwin-38 = {
      name = "torchvision-0.19.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-TE5PWyTqawh7Au1JKrHiG7ozUsRXfi3vFCSM/GBzIzg=";
    };
    aarch64-darwin-39 = {
      name = "torchvision-0.19.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-cx9DTZFYZ2niVbXXDtGkRX4KE5SpX0qs8OHn4h+AwJg=";
    };
    aarch64-darwin-310 = {
      name = "torchvision-0.19.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-VOhRMJnm9YY1bHD4CdNPORr3GtGC/gccwyiiivLEBgg=";
    };
    aarch64-darwin-311 = {
      name = "torchvision-0.19.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-QFFCgrSJbWJ2W44m1wkcMuF8NYF9AOxL4jYuo7o9F4c=";
    };
    aarch64-darwin-312 = {
      name = "torchvision-0.19.1-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.1-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-J+zid/8PbNx/7QYnJ5xjLcsuWBh9p3HsoksPvPP4WQ0=";
    };
    aarch64-linux-38 = {
      name = "torchvision-0.19.1-cp38-cp38-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.1-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-TRC8kIPE1frdft17cpcAp75I2rT2InjfO8c/pI5IoVU=";
    };
    aarch64-linux-39 = {
      name = "torchvision-0.19.1-cp39-cp39-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.1-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-4ygwm4ZwouiJsv52ocJ0SgmcEcmE2pqCI1e9nevWmaU=";
    };
    aarch64-linux-310 = {
      name = "torchvision-0.19.1-cp310-cp310-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.1-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-ewYxFhZL5S/G3rR2Lef4yQv6OmX41crxf44tWq3HWgQ=";
    };
    aarch64-linux-311 = {
      name = "torchvision-0.19.1-cp311-cp311-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.1-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-1xpqb+OlKByjSH1MVq1KrSD/cPgvHXx5vLbnsMKvAMg=";
    };
    aarch64-linux-312 = {
      name = "torchvision-0.19.1-cp312-cp312-linux_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchvision-0.19.1-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-wHv0PCoUXXkuzZ0FA9bHNXcUfs5QjUVgDYqsd+TN/Pk=";
    };
  };
}
