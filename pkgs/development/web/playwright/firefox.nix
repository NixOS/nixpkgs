{
  stdenv,
  fetchzip,
  firefox-bin,
  revision,
  system,
  throwSystem,
}:
let
  download =
    (import ./browser-downloads.nix {
      name = "firefox";
      inherit revision;
    }).${system} or throwSystem;

  firefox-linux = stdenv.mkDerivation {
    name = "playwright-firefox";
    src = fetchzip {
      inherit (download) url stripRoot;
      hash =
        {
          x86_64-linux = "sha256-GmjRWhlSv7by3PFtrKgo6EBmHigmp55HwG8iA/Ykq88=";
          aarch64-linux = "sha256-7vxVe82NxebzoSSoSFg9qNxKOqlT7EOwCxQVavkDoMM=";
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
    inherit (download) url stripRoot;
    hash =
      {
        aarch64-darwin = "sha256-E7/Kbvjg1dcWwSe/07hMR+W6NR0JHoAPxp1e+SncQYs=";
      }
      .${system} or throwSystem;
  };
in
{
  x86_64-linux = firefox-linux;
  aarch64-linux = firefox-linux;
  aarch64-darwin = firefox-darwin;
}
.${system} or throwSystem
