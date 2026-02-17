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
          x86_64-linux = "sha256-PGTFoSjU2FFRmH7qfWkJsgnGvg3AI+eGrNUwyxRU8PM=";
          aarch64-linux = "sha256-P5aHwaNZ0KfAVgRVugvAl6FsQu2/7sphwulOVyXiTgg=";
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
        x86_64-darwin = "sha256-MI4HfXLmVEwcoL2jlcrDkfiClEN5rI8YcJiMqzE1xYs=";
        aarch64-darwin = "sha256-Il7bTQoP6ZlqizduV4iCTrVsymy33RbGQtVSnVXnhTc=";
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
