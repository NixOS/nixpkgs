{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  postgresql,
  msgpack-c,
  groonga,
  buildPostgresqlExtension,
  xxHash,
}:

buildPostgresqlExtension rec {
  pname = "pgroonga";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "pgroonga";
    repo = "pgroonga";
    rev = "${version}";
    hash = "sha256-9rDb7rNd/HpvdQ/lMQGCr1Hq/4TBBo9HaA2b0zmC9QY=";
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

  meta = with lib; {
    description = "PostgreSQL extension to use Groonga as the index";
    longDescription = ''
      PGroonga is a PostgreSQL extension to use Groonga as the index.
      PostgreSQL supports full text search against languages that use only alphabet and digit.
      It means that PostgreSQL doesn't support full text search against Japanese, Chinese and so on.
      You can use super fast full text search feature against all languages by installing PGroonga into your PostgreSQL.
    '';
    homepage = "https://pgroonga.github.io/";
    changelog = "https://github.com/pgroonga/pgroonga/releases/tag/${version}";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ DerTim1 ];
  };
}
