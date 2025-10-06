# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.8.0" = {
    x86_64-linux-39 = {
      name = "torchaudio-2.8.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.8.0%2Bcu128-cp39-cp39-manylinux_2_28_x86_64.whl";
      hash = "sha256-2QZsae7B8pPC/wqAW/UEc3OQzL9rd8jmfa+DTbhv2kU=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.8.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.8.0%2Bcu128-cp310-cp310-manylinux_2_28_x86_64.whl";
      hash = "sha256-oBYelShaC3Ft4hD+4DkhUdYB59o8yGWVAI2Car/0iow=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.8.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.8.0%2Bcu128-cp311-cp311-manylinux_2_28_x86_64.whl";
      hash = "sha256-9ECd9WfQcjp6OonTLHVSoX4P9vE36iag0mjGZSWbKZU=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.8.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.8.0%2Bcu128-cp312-cp312-manylinux_2_28_x86_64.whl";
      hash = "sha256-FFuKDCHPyqFwXGcXPF1DkIfg4SDV2pvDRHRvk3kB0kM=";
    };
    x86_64-linux-313 = {
      name = "torchaudio-2.8.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu128/torchaudio-2.8.0%2Bcu128-cp313-cp313-manylinux_2_28_x86_64.whl";
      hash = "sha256-QQu46kYiXv5ljl0no4AsGBoiVZEwA2IaXSWlGsqAGNk=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.8.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.8.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-UiKJ4s1X55QB/VzK6bG8D/LkfzUpCSrfWs9XQn6gxqk=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.8.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.8.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-wvRM8nn2c8/N2PV2w0nu6L7fjKqzUaXdeLMpcMw0ohI=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.8.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.8.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-ySdoV9JBxt4levdlwPUfwBGvOMtyVAFJUSGygJEwB88=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.8.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.8.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-3e+UvxgeZEfLsF84vqyo9sW7jSud3O0ao0UgJbn8cNM=";
    };
    aarch64-darwin-313 = {
      name = "torchaudio-2.8.0-cp313-cp313-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.8.0-cp313-cp313-macosx_11_0_arm64.whl";
      hash = "sha256-+FHTLpTKBeRw8MYOJXJuweDrccsspaAga3/QMnLMw8g=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.8.0-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.8.0-cp39-cp39-manylinux_2_28_aarch64.whl";
      hash = "sha256-739/+oKLjYul06VpuCX8BGlojh6JYr9ld9U4vYrxOH0=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.8.0-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.8.0-cp310-cp310-manylinux_2_28_aarch64.whl";
      hash = "sha256-08G4WyagmDLROfbW2mtmyutR0uFuCPhYdmXESp4aqPk=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.8.0-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.8.0-cp311-cp311-manylinux_2_28_aarch64.whl";
      hash = "sha256-RXPGBClQwgJ442CKmjgFC6C8cuAEnhu/0knK+FmoAps=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.8.0-cp312-cp312-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.8.0-cp312-cp312-manylinux_2_28_aarch64.whl";
      hash = "sha256-hi4uQL8J2GXl3wgKhMGjm7zvQOQxQPSxc36zo4nTs48=";
    };
    aarch64-linux-313 = {
      name = "torchaudio-2.8.0-cp313-cp313-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.8.0-cp313-cp313-manylinux_2_28_aarch64.whl";
      hash = "sha256-CVNam3J8B5PNB8Gs6Z8/NTYmKBvMPjDC8jFOPrydP5Y=";
    };
  };
}
