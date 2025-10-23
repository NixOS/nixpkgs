{
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  protobufc,
}:

postgresqlBuildExtension {
  pname = "cstore_fdw";
  version = "1.7.0-unstable-2021-03-08";

  buildInputs = [ protobufc ];
  nativeBuildInputs = [ protobufc ];

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "cstore_fdw";
    rev = "90e22b62fbee6852529104fdd463f532cf7a3311";
    hash = "sha256-02wcCqs8A5ZOZX080fgcNJTQrYQctnlwnA8+YPaRTZc=";
  };

  meta = {
    broken = lib.versionAtLeast postgresql.version "14";
    description = "Columnar storage for PostgreSQL";
    homepage = "https://github.com/citusdata/cstore_fdw";
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.asl20;
  };
}
