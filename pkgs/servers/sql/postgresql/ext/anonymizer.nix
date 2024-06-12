{ lib, stdenv, pg-dump-anon, postgresql, runtimeShell, jitSupport, llvm }:

stdenv.mkDerivation (finalAttrs: {
  pname = "postgresql_anonymizer";

  inherit (pg-dump-anon) version src passthru;

  buildInputs = [ postgresql ];
  nativeBuildInputs = [ postgresql ] ++ lib.optional jitSupport llvm;

  strictDeps = true;

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "datadir=${placeholder "out"}/share/postgresql"
    "pkglibdir=${placeholder "out"}/lib"
    "DESTDIR="
  ];

  postInstall = ''
    cat >$out/bin/pg_dump_anon.sh <<'EOF'
    #!${runtimeShell}
    echo "This script is deprecated by upstream. To use the new script,"
    echo "please install pkgs.pg-dump-anon."
    exit 1
    EOF
  '';

  meta = lib.getAttrs [ "homepage" "maintainers" "license" ] pg-dump-anon.meta // {
    description = "Extension to mask or replace personally identifiable information (PII) or commercially sensitive data from a PostgreSQL database";
  };
})
