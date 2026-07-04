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
          x86_64-linux = "sha256-DXUCNHLzN8rdq/I7JRAHbSPtgK8pJy3sKNEx4xsbd0E=";
          aarch64-linux = "sha256-Kl7Z9mE+1Vy6VEnnl0DOZY/jtYjhUTwjqfFe9UZu2UA=";
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
        x86_64-darwin = "sha256-eXS88URYKAbFP6/3pukb2qgrdqVBOR99VGyqKPFZ2Tw=";
        aarch64-darwin = "sha256-lVNFp20v+zBC3Up9ElhWh8C8ptEUqCHEsfQiuPp3lVM=";
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
