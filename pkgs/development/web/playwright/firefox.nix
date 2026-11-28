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
          x86_64-linux = "sha256-ucbiiO5F8NJAkELa5fkPtmrUEbJ/EgQzJSAEeLpjAqQ=";
          aarch64-linux = "sha256-H2WU+P1XuXrSs2qZwNIkAOP2o5KS76SvALEZ/YuEHSs=";
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
        aarch64-darwin = "sha256-Hb3JLggEQzrNFGrmCQHN4QbGQXCifHL6SYOtQtVLPH4=";
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
