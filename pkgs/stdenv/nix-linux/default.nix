{stdenv, glibc, pkgs, genericStdenv, gccWrapper}:

let {

  body =

    genericStdenv {
      name = "stdenv-nix-linux";
      preHook = ./prehook.sh;
      initialPath = (import ../nix/path.nix) {pkgs = pkgs;};

      inherit stdenv;

      gcc = gccWrapper {
        name = pkgs.gcc.name;
        nativeTools = false;
        nativeGlibc = false;
        inherit (pkgs) gcc binutils;
        inherit stdenv glibc;
      };

      param1 = pkgs.bash;
    }

    # Add a utility function to produce derivations that use this
    # stdenv and its the bash shell.
    // {
      mkDerivation = attrs: derivation (attrs // {
        builder = pkgs.bash ~ /bin/sh;
        args = ["-e" attrs.builder];
        stdenv = body;
        system = body.system;
      });
    };

}
