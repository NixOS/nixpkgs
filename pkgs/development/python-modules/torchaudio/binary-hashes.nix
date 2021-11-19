# Warning: Need to update at the same time as pytorch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.10.0" = {
    x86_64-linux-37 = {
      name = "torchaudio-0.10.0-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchaudio-0.10.0%2Bcu113-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-FspXTTODdkO0nPUJcJm8+vLIvckUa8gRfBPBT9LcKPw=";
    };
    x86_64-linux-38 = {
      name = "torchaudio-0.10.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchaudio-0.10.0%2Bcu113-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-Mf7QdXBSIIWRfT7ACthEwFA1V2ieid8legbMnRQnzqI=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-0.10.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu113/torchaudio-0.10.0%2Bcu113-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-LMSGNdmku1iHRy1jCRTTOYcQlRL+Oc9jjZC1nx++skA=";
    };
  };
}
