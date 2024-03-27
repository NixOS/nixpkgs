# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.2.2" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.2.2-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.2%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-KPwkn2+sVuS9GbZdk7f6lSJ956D1WLY2YS7k3qE3tog=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.2.2-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.2%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-YzzBeuAiMH0HPyZhvK/z9Q2bPW99MukXMFRCAybiDRs=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.2.2-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.2%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-/eGFVNhP0AR1iPC87QPXcPZVPxeFGjtEE3kWShPJmwc=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.2.2-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.2%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-DgdNBcIlizAU3aAu7wB60Xq0TP0B2XgMmpFOXZcqwAs=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-2.2.2-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-jOTfBlqUmRHStngqpME2h++t6iP/x8em8V9+euXIlSQ=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-2.2.2-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-23CxOocaSUh72QQr8EsS90rtd7GofS++to0J2bZLxSg=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-2.2.2-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-sdWCAdEI6F2z41uEMZ8ziE9h8yfDjq2GkTIYyMGsw90=";
    };
    x86_64-darwin-311 = {
      name = "torchaudio-2.2.2-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-8agaUYo+hsAEEl64kfxDPOj7I0MpW11hLQ83sk4THv0=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.2.2-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-s7ir4msGfpxKbj26FWuR16hSR+iN2nC3xDhZ9VuXjdw=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.2.2-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-S3ioShib89pLlmN1zr3sxYSk3F9g4L3nIdc0Ae1crUU=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.2.2-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-pSDhTqC6idncJ5IutGCfnqxcAcJ5gw4PIWucngF9Q4s=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.2.2-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-AUgvyFEX+F7kT4qo6cEbHAIjJhc+B0h4ntQrIZECk38=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.2.2-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-T3VqbmZ92IQb8hoH6tPv7ap6J9VYUnecJm9vKhBkyZQ=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.2.2-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-cj9OV7XQwSA1fKYM1VtObPrIRbwOzMtLQXpEqk68Ums=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.2.2-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-sPOOfTVIkU14qvwn/wD3cBsaUL/N3FiWX1RfySzNSmY=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.2.2-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.2-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-CgOki21V0X1I9Bmn8dDUAY1IoEx2WFwWqbXmkoH5L5Q=";
    };
  };
}
