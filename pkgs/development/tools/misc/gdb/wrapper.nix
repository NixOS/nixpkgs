{ stdenvNoCC, targetPackages
, makeWrapper
, gdb-unwrapped
, safePaths ? [
   # $debugdir:$datadir/auto-load are whitelisted by default by GDB
   "$debugdir" "$datadir/auto-load"
   # targetPackages so we get the right libc when cross-compiling and using buildPackages.gdb
   targetPackages.stdenv.cc.cc.lib
  ]
}:

let
  gdb = gdb-unwrapped;

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  targetPrefix = stdenvNoCC.lib.optionalString
    (stdenvNoCC.targetPlatform != stdenvNoCC.hostPlatform)
    (stdenvNoCC.targetPlatform.config + "-");
in
  stdenvNoCC.mkDerivation {
    name = gdb.name;
    nativeBuildInputs = [ makeWrapper ];
    propagatedUserEnvPkgs = [ gdb ];
    phases = "installPhase fixupPhase";

    # Find all gdb plugins in `safePaths` and
    # mark these files as safe to load.
    # TODO `set arch` in script too
    installPhase = ''
      mkdir -p $out/share/gdb
      initScript=$out/share/gdb/gdbinit
      touch $initScript

      for safePath in ${stdenvNoCC.lib.concatStringsSep " " safePaths}; do
        for plugin in $(find $safePath | grep -- '.*-gdb.*'); do
          echo add-auto-load-safe-path $plugin >> $initScript
        done
      done

      makeWrapper "${gdb}/bin/gdb" \
        "$out/bin/${targetPrefix}gdb" \
        --add-flags "-x $initScript"
    '';

    meta = gdb.meta;
  }
