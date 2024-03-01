{ lib, stdenv, fetchFromGitLab, postgresql, nixosTests, ... }:

stdenv.mkDerivation (finalAttrs: {
  pname = "postgresql_anonymizer";
  version = "1.3.1";

  src = fetchFromGitLab {
    owner = "dalibo";
    repo = "postgresql_anonymizer";
    rev = finalAttrs.version;
    hash = "sha256-Z5Oz/cIYDxFUZwQijRk4xAOUdOK0LWR+px8WOcs+Rs0=";
  };

  buildInputs = [ postgresql ];
  nativeBuildInputs = [ postgresql ] ++ lib.optional postgresql.jitSupport postgresql.llvm;

  strictDeps = true;

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "datadir=${placeholder "out"}/share/postgresql"
    "pkglibdir=${placeholder "out"}/lib"
    "DESTDIR="
  ];

  passthru.tests = { inherit (nixosTests) pg_anonymizer; };

  meta = with lib; {
    description = "postgresql_anonymizer is an extension to mask or replace personally identifiable information (PII) or commercially sensitive data from a PostgreSQL database.";
    homepage = "https://postgresql-anonymizer.readthedocs.io/en/stable/";
    maintainers = teams.flyingcircus.members;
    license = licenses.postgresql;
  };
})
