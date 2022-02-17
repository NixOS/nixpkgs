{
  fetchurl,
  lib,
  stdenvNoCC,
  undmg
}:

{
  meta,
  pname
}:

with lib;

let
  # Check these places for new versions:
  # https://prerelease.keybase.io/index.html
  version = "5.9.2";
  versionSuffix = "20220131223535%2Ba25f15e42b";
  fileName = "Keybase-${version}-${versionSuffix}.dmg";
in
  stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      # Workaround for https://github.com/NixOS/nix/issues/6116.
      name = builtins.replaceStrings ["%2B"] ["+"] fileName;
      url = "https://s3.amazonaws.com/prerelease.keybase.io/darwin/${fileName}";
      sha256 = "15a20d62a860d21c8c5397b6e3b36dcada6029a39649444753de59c0c9c547dd";
    };
    sourceRoot = ".";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      mkdir -p "$out/Applications"
      cp -r "Keybase.app" "$out/Applications"
    '';

    meta = meta // {
      platforms = [ "x86_64-darwin" ];
      maintainers = with maintainers; [ steinybot ];
    };
  }
