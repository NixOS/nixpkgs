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
          x86_64-linux = "sha256-+mwhR8QQ9fs7hD3C4Xn9xcL8LRU+rt2JO8Gcg/KjqRU=";
          aarch64-linux = "sha256-drL8jduYK0rnmLYW9jzSTKHb0pKaezMnpER5kLikEvY=";
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
        x86_64-darwin = "sha256-uxPOq2U1D9gFXqvNzclctLbHx4fZ9O92GtDQjCRYGiM=";
        aarch64-darwin = "sha256-ZFRmtlNrzrjB3ELXmGC67XO1IhfWsWZ7rXaUQ6If65s=";
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
