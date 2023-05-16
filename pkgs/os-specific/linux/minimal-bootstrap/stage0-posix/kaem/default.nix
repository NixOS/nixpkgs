{ lib
, derivationWithMeta
, writeText
, kaem
, kaem-unwrapped
, mescc-tools
, mescc-tools-extra
, version
<<<<<<< HEAD
, platforms
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

# Once mescc-tools-extra is available we can install kaem at /bin/kaem
# to make it findable in environments
derivationWithMeta {
  inherit version kaem-unwrapped;
  pname = "kaem";
  builder = kaem-unwrapped;
  args = [
    "--verbose"
    "--strict"
    "--file"
    (builtins.toFile "kaem-wrapper.kaem" ''
      mkdir -p ''${out}/bin
      cp ''${kaem-unwrapped} ''${out}/bin/kaem
      chmod 555 ''${out}/bin/kaem
    '')
  ];
  PATH = lib.makeBinPath [ mescc-tools-extra ];

  passthru.runCommand = name: env: buildCommand:
    derivationWithMeta ({
      inherit name;

      builder = "${kaem}/bin/kaem";
      args = [
        "--verbose"
        "--strict"
        "--file"
        (writeText "${name}-builder" buildCommand)
      ];

      PATH = lib.makeBinPath ((env.nativeBuildInputs or []) ++ [ kaem mescc-tools mescc-tools-extra ]);
    } // (builtins.removeAttrs env [ "nativeBuildInputs" ]));

  meta = with lib; {
    description = "Minimal build tool for running scripts on systems that lack any shell";
    homepage = "https://github.com/oriansj/mescc-tools";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = teams.minimal-bootstrap.members;
    inherit platforms;
=======
    maintainers = with maintainers; [ emilytrau ];
    platforms = [ "i686-linux" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
