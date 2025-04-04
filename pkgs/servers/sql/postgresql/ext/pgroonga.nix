{
  fetchFromGitHub,
  groonga,
  lib,
  msgpack-c,
  pkg-config,
  postgresql,
  postgresqlBuildExtension,
  stdenv,
  xxHash,
}:

postgresqlBuildExtension rec {
  pname = "pgroonga";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "pgroonga";
    repo = "pgroonga";
    tag = "${version}";
    hash = "sha256-a5nNtlUiFBuuqWAjIN0gU/FaoV3VpJh+/fab8R/77dw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    msgpack-c
    groonga
    xxHash
  ];

  makeFlags = [
    "HAVE_XXHASH=1"
    "HAVE_MSGPACK=1"
    "MSGPACK_PACKAGE_NAME=msgpack-c"
  ];

  meta = {
    description = "PostgreSQL extension to use Groonga as the index";
    longDescription = ''
      PGroonga is a PostgreSQL extension to use Groonga as the index.
      PostgreSQL supports full text search against languages that use only alphabet and digit.
      It means that PostgreSQL doesn't support full text search against Japanese, Chinese and so on.
      You can use super fast full text search feature against all languages by installing PGroonga into your PostgreSQL.
    '';
    homepage = "https://pgroonga.github.io/";
    changelog = "https://github.com/pgroonga/pgroonga/releases/tag/${version}";
    license = lib.licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with lib.maintainers; [ DerTim1 ];
  };
}
