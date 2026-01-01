{
  lib,
  stdenv,
  fetchzip,
  firefox-bin,
  suffix,
  revision,
  system,
  throwSystem,
}:
let
  firefox-linux = stdenv.mkDerivation {
    name = "playwright-firefox";
    src = fetchzip {
      url = "https://playwright.azureedge.net/builds/firefox/${revision}/firefox-${
        "ubuntu-22.04" + (lib.removePrefix "linux" suffix)
      }.zip";
      hash =
        {
<<<<<<< HEAD
          x86_64-linux = "sha256-qdAlGPnpiOfa49zJZsbLvNtEqh4xnaPDH3TvX5fA+PA=";
          aarch64-linux = "sha256-6880Y68m5uvD+e/ZLqJqoTQNPcmK8CUKgaR2wBdBxsw=";
=======
          x86_64-linux = "sha256-j7gOuXMyftNQencgfpk8Y4ED2LuT7TAa30IPyzmir48=";
          aarch64-linux = "sha256-deIUGKBrp56TsDr61cbNbRRSRcVpSoa6pdmMk4oB/Eg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        }
        .${system} or throwSystem;
    };

    inherit (firefox-bin.unwrapped)
      nativeBuildInputs
      buildInputs
      runtimeDependencies
      appendRunpaths
      patchelfFlags
      ;

    buildPhase = ''
      mkdir -p $out/firefox
      cp -R . $out/firefox
    '';
  };
  firefox-darwin = fetchzip {
    url = "https://playwright.azureedge.net/builds/firefox/${revision}/firefox-${suffix}.zip";
    stripRoot = false;
    hash =
      {
<<<<<<< HEAD
        x86_64-darwin = "sha256-3NEDS0Uw2k0W2hUuIIU4pO/xCnPEc5iowP88M5NNAuA=";
        aarch64-darwin = "sha256-XXJf0nBdLQjHdes5ZAA4zhKK+E9caqD42CFqCQ92EKM=";
=======
        x86_64-darwin = "sha256-ljgFoyqCg9kma2cDFodNjbkAeEylIzVdWkS1vU/9Rbg=";
        aarch64-darwin = "sha256-W2J5APPWEkmoDgBEox6/ygg2xyWpOHZESXFG0tZbj1M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      }
      .${system} or throwSystem;
  };
in
{
  x86_64-linux = firefox-linux;
  aarch64-linux = firefox-linux;
  x86_64-darwin = firefox-darwin;
  aarch64-darwin = firefox-darwin;
}
.${system} or throwSystem
