{ lib
, system
, mkKaemDerivation0
, fetchurl
, kaem
, mescc-tools
, mescc-tools-extra
}:

rec {
  writeTextFile =
    { name # the name of the derivation
    , text
    , executable ? false # run chmod +x ?
    , destination ? ""   # relative path appended to $out eg "/bin/foo"
    , allowSubstitutes ? false
    , preferLocalBuild ? true
    }:
    mkKaemDerivation0 {
      inherit name text executable allowSubstitutes preferLocalBuild;
      passAsFile = [ "text" ];

      PATH = lib.makeBinPath [ mescc-tools-extra ];
      script = builtins.toFile "write-text-file.kaem" ''
        target=''${out}${destination}
        if match x${if builtins.dirOf destination == "" then "0" else "1"} x1; then
          mkdir -p ''${out}${builtins.dirOf destination}
        fi
        cp ''${textPath} ''${target}
        if match x''${executable} x1; then
          chmod 555 ''${target}
        fi
      '';
    };

  writeText = name: text: writeTextFile {inherit name text;};

  runCommand = name: env: buildCommand:
    derivation ({
      inherit name system;

      builder = "${kaem}/bin/kaem";
      args = [
        "--verbose"
        "--strict"
        "--file"
        (writeText "${name}-builder" buildCommand)
      ];

      PATH = lib.makeBinPath ((env.nativeBuildInputs or []) ++ [ kaem mescc-tools mescc-tools-extra ]);
    } // (builtins.removeAttrs env [ "nativeBuildInputs" ]));

  # Fetch and unpack a .tar.gz file. Does not strip top-level directory
  fetchtarball =
    { url
      # Unlike fetchzip, this hash is of the tarball and not the decompressed output
    , sha256
    , name ? baseNameOf (toString url)
    , postFetch ? ""
    }:
    let
      tarball = fetchurl { inherit url sha256; };
    in
    runCommand name {} ''
      cd ''${TMP}
      ungz --file ${tarball} --output tmp.tar
      mkdir ''${out}
      cd ''${out}
      untar --file ''${TMP}/tmp.tar

      ${postFetch}
    '';
}
