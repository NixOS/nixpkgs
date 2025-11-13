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
          x86_64-linux = "sha256-qdAlGPnpiOfa49zJZsbLvNtEqh4xnaPDH3TvX5fA+PA=";
          aarch64-linux = "sha256-6880Y68m5uvD+e/ZLqJqoTQNPcmK8CUKgaR2wBdBxsw=";
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
        x86_64-darwin = "sha256-3NEDS0Uw2k0W2hUuIIU4pO/xCnPEc5iowP88M5NNAuA=";
        aarch64-darwin = "sha256-XXJf0nBdLQjHdes5ZAA4zhKK+E9caqD42CFqCQ92EKM=";
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
