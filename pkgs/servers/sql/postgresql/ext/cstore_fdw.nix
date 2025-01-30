{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
  protobufc,
  buildPostgresqlExtension,
}:

buildPostgresqlExtension rec {
  pname = "cstore_fdw";
  version = "1.7.0-unstable-2021-03-08";

  nativeBuildInputs = [ protobufc ];

  src = fetchFromGitHub {
    owner = "citusdata";
    repo = "cstore_fdw";
    rev = "90e22b62fbee6852529104fdd463f532cf7a3311";
    sha256 = "sha256-02wcCqs8A5ZOZX080fgcNJTQrYQctnlwnA8+YPaRTZc=";
  };

  meta = with lib; {
    broken = versionAtLeast postgresql.version "14";
    description = "Columnar storage for PostgreSQL";
    homepage = "https://github.com/citusdata/cstore_fdw";
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = postgresql.meta.platforms;
    license = licenses.asl20;
  };
}
