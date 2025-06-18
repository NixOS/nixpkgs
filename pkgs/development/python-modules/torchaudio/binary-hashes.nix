# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.7.1" = {
    x86_64-linux-39 = {
      name = "torchaudio-2.7.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.7.1%2Bcu128-cp39-cp39-manylinux_2_28_x86_64.whl";
      hash = "sha256-DBRNX/tO7IbHn/ETar2RvT+DfzBCcTeV4QdYrtxC3Og=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.7.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.7.1%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-K6CBbu5lnjQ4UanF3GDI4euBmjlpspJo+rJ9MUMnPXg=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.7.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.7.1%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-hOxyfx/a/fhd0cAYptO/q+tWZbEOC18nOmdetzD1nOU=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.7.1-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.7.1%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-DB1Af5NNRPh5NbE5mR2IcvgfiPimvpt70lkYv3ROK+Y=";
    };
    x86_64-linux-313 = {
      name = "torchaudio-2.7.1-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.7.1%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-fpfqil1eVhCNHAcUFmE7xhoONTHC5rpqm2RiMtbkEIg=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.7.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-oHEA/iz3r0+mnYywRqK3QEZhJiGhpUivpa8caeAur4E=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.7.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-RzmvV9DrlDR9HGobVmi+eKc4Ov6Cbd4YoEiDufnyY7E=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.7.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-1aYviMYpA1kT9QbfA/cQxI/Iu5Y3GRkz8nxnCI1coTY=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.7.1-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.1-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-kwbc/EWGzr12R6k/6aRI55HE+Dk02mFrlDO3VZeh+Xg=";
    };
    aarch64-darwin-313 = {
      name = "torchaudio-2.7.1-cp313-cp313-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.1-cp313-cp313-macosx_11_0_arm64.whl";
      hash = "sha256-5fBZmlB/RoNUaHjtlmfhsy18o8ipV+TBXGswI3jvTe4=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.7.1-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.1-cp39-cp39-manylinux_2_28_aarch64.whl";
      hash = "sha256-6LLaEaf3eCsAuCPJnoEusA7os0Va1HT4/UKg2gvE9Go=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.7.1-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.1-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-wInb/BTF9HCRt78/a/K7rJO4ZhkpnQTZwQL0rVN1iZA=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.7.1-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.1-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-U7xLoS50aL40p8ou6DfuXIvVdVslwS9mWvkznK434mU=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.7.1-cp312-cp312-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.1-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-1mvXayJv3UE1yXZQ4bfrY/t2WbTtDjp3iJjkHbuiG2E=";
    };
    aarch64-linux-313 = {
      name = "torchaudio-2.7.1-cp313-cp313-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.7.1-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-Jx9xeETlx/ngXIMo3oF7+Q9G2DKBx5HpT1TU7eovWBc=";
    };
  };
}
