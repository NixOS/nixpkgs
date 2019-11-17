{ stdenv, lib, makeWrapper, gdb-unwrapped, safePaths }:

let
  gdb = gdb-unwrapped;
in
  stdenv.mkDerivation {
    name = gdb.name;
    buildInputs = [ makeWrapper ];
    propagatedBuildInputs = [ gdb ];
    propagatedUserEnvPkgs = [ gdb ];
    phases = "installPhase fixupPhase";

    # Find all gdb plugins in `safePaths` and
    # mark these files as safe to load.
    installPhase = ''
      mkdir -p $out/share/gdb
      initScript=$out/share/gdb/gdbinit
      touch $initScript

      for safePath in ${lib.concatStringsSep " " safePaths}; do
        for plugin in $(find $safePath | grep -- '.*-gdb.*'); do
          echo add-auto-load-safe-path $plugin >> $initScript
        done
      done

      makeWrapper "${gdb}/bin/gdb" \
        "$out/bin/gdb" \
        --add-flags "-x $initScript"
    '';

    meta = gdb.meta;
  }
