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
          x86_64-linux = "sha256-hGlG7Snw/YVgXDHWXK24Ci87JxpENEfhpve7fu+ol1E=";
          aarch64-linux = "sha256-R5wl+oln2gFse+31NFfLaIsGQOOVrCRj8drOE9qmiwY=";
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
        x86_64-darwin = "sha256-qov3gZspe95py/tHcKzGVvzvmcKWsOtGNMj76QPhFbE=";
        aarch64-darwin = "sha256-8mfFZuNuOo04ZNwqrm2JQJoSkJC6ChdwPDgIDKse34s=";
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
