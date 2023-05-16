{ lib
, buildPlatform
, callPackage
, kaem
, mescc-tools-extra
<<<<<<< HEAD
, checkMeta
}:
rec {
=======
}:

let
  checkMeta = callPackage ../../../stdenv/generic/check-meta.nix { };
in
rec {
  fetchurl = import ../../../build-support/fetchurl/boot.nix {
    inherit (buildPlatform) system;
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  derivationWithMeta = attrs:
    let
      passthru = attrs.passthru or {};
      validity = checkMeta.assertValidity { inherit meta attrs; };
      meta = checkMeta.commonMeta { inherit validity attrs; };
<<<<<<< HEAD
      baseDrv = derivation ({
        inherit (buildPlatform) system;
        inherit (meta) name;
      } // (builtins.removeAttrs attrs [ "meta" "passthru" ]));
      passthru' = passthru // lib.optionalAttrs (passthru ? tests) {
        tests = lib.mapAttrs (_: f: f baseDrv) passthru.tests;
      };
    in
    lib.extendDerivation
      validity.handled
      ({ inherit meta; passthru = passthru'; } // passthru')
      baseDrv;
=======
    in
    lib.extendDerivation
      validity.handled
      ({ inherit meta passthru; } // passthru)
      (derivation ({
        inherit (buildPlatform) system;
        inherit (meta) name;
      } // (builtins.removeAttrs attrs [ "meta" "passthru" ])));
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  writeTextFile =
    { name # the name of the derivation
    , text
    , executable ? false # run chmod +x ?
    , destination ? ""   # relative path appended to $out eg "/bin/foo"
<<<<<<< HEAD
    }:
    derivationWithMeta {
      inherit name text;
=======
    , allowSubstitutes ? false
    , preferLocalBuild ? true
    }:
    derivationWithMeta {
      inherit name text executable allowSubstitutes preferLocalBuild;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      passAsFile = [ "text" ];

      builder = "${kaem}/bin/kaem";
      args = [
        "--verbose"
        "--strict"
        "--file"
<<<<<<< HEAD
        (builtins.toFile "write-text-file.kaem" (''
          target=''${out}''${destination}
        '' + lib.optionalString (builtins.dirOf destination == ".") ''
          mkdir -p ''${out}''${destinationDir}
        '' + ''
          cp ''${textPath} ''${target}
        '' + lib.optionalString executable ''
          chmod 555 ''${target}
        ''))
      ];

      PATH = lib.makeBinPath [ mescc-tools-extra ];
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      destinationDir = builtins.dirOf destination;
      inherit destination;
    };

  writeText = name: text: writeTextFile {inherit name text;};

}
