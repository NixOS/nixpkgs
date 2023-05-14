{ lib
, buildPlatform
, callPackage
, kaem
, mescc-tools-extra
}:

let
  checkMeta = callPackage ../../../stdenv/generic/check-meta.nix { };
in
rec {
  fetchurl = import ../../../build-support/fetchurl/boot.nix {
    inherit (buildPlatform) system;
  };

  derivationWithMeta = attrs:
    let
      passthru = attrs.passthru or {};
      validity = checkMeta.assertValidity { inherit meta attrs; };
      meta = checkMeta.commonMeta { inherit validity attrs; };
    in
    lib.extendDerivation
      validity.handled
      ({ inherit meta passthru; } // passthru)
      (derivation ({
        inherit (buildPlatform) system;
        inherit (meta) name;
      } // (builtins.removeAttrs attrs [ "meta" "passthru" ])));

  writeTextFile =
    { name # the name of the derivation
    , text
    , executable ? false # run chmod +x ?
    , destination ? ""   # relative path appended to $out eg "/bin/foo"
    , allowSubstitutes ? false
    , preferLocalBuild ? true
    }:
    derivationWithMeta {
      inherit name text executable allowSubstitutes preferLocalBuild;
      passAsFile = [ "text" ];

      builder = "${kaem}/bin/kaem";
      args = [
        "--verbose"
        "--strict"
        "--file"
        (builtins.toFile "write-text-file.kaem" ''
          target=''${out}''${destination}
          if match x''${mkdirDestination} x1; then
            mkdir -p ''${out}''${destinationDir}
          fi
          cp ''${textPath} ''${target}
          if match x''${executable} x1; then
            chmod 555 ''${target}
          fi
        '')
      ];

      PATH = lib.makeBinPath [ mescc-tools-extra ];
      mkdirDestination = if builtins.dirOf destination == "." then "0" else "1";
      destinationDir = builtins.dirOf destination;
      inherit destination;
    };

  writeText = name: text: writeTextFile {inherit name text;};

}
