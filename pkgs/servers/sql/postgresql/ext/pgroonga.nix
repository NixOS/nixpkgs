{ lib, stdenv, fetchurl, pkg-config, postgresql, msgpack-c, groonga, buildPostgresExtension }:

buildPostgresExtension rec {
  pname = "pgroonga";
  version = "3.1.8";

  src = fetchurl {
    url = "https://packages.groonga.org/source/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-Wjh0NJK6IfcI30R7HKCsB87/lxXZYEqiMD9t2nldCW4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ msgpack-c groonga ];

  makeFlags = [
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
