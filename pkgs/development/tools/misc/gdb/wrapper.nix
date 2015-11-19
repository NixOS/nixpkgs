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
    echo add-auto-load-safe-path ${lib.concatStringsSep ":" safePaths} > $out/share/gdb/system-gdbinit/safePaths.py
    makeWrapper "${gdb}/bin/gdb" \
      "$out/bin/gdb" \
      --add-flags -x $out/share/gdb/system/gdbinit/safePaths.py
    '';
  meta = gdb.meta;
}
