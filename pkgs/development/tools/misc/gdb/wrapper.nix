{ stdenv, lib, makeWrapper, buildEnv, gdbWithoutWrapper, safePaths}:

let gdb = gdbWithoutWrapper; in
stdenv.mkDerivation {
  name = gdb.name;
  buildInputs = [makeWrapper];
  propagatedBuildInputs = [gdb];
  propagatedUserEnvPkgs = [gdb];
  phases = "installPhase fixupPhase";
  installPhase = ''
    mkdir -p $out/share/gdb/system-gdbinit
    allSafePaths=${lib.concatStringsSep ":" safePaths}
    for safePath in ${lib.concatStringsSep " " safePaths}; do
      if [ -e $safePath/nix-support/propagated-user-env-packages ]; then
        for package in $(cat $safePath/nix-support/propagated-user-env-packages); do
          allSafePaths=$allSafePaths:$package
        done
      fi
    done
    echo add-auto-load-safe-path $allSafePaths > $out/share/gdb/system-gdbinit/safePaths
    makeWrapper "${gdb}/bin/gdb" \
      "$out/bin/gdb" \
      --add-flags "-x $out/share/gdb/system-gdbinit/safePaths"
    '';
  meta = gdb.meta;
}
