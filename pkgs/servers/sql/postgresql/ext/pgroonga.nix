{ lib, stdenv, fetchurl, pkg-config, postgresql, msgpack, groonga }:

stdenv.mkDerivation rec {
  pname = "pgroonga";
  version = "2.2.8";

  src = fetchurl {
    url = "https://packages.groonga.org/source/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-YDDO3t6ARbQv72QotjA7DNxOlRo2O5CYzrH+/eEzj3w=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ postgresql msgpack groonga ];

  makeFlags = [ "HAVE_MSGPACK=1" ];

  installPhase = ''
    install -D pgroonga.so -t $out/lib/
    install -D ./{pgroonga-*.sql,pgroonga.control} -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "A PostgreSQL extension to use Groonga as the index";
    longDescription = ''
      PGroonga is a PostgreSQL extension to use Groonga as the index.
      PostgreSQL supports full text search against languages that use only alphabet and digit.
      It means that PostgreSQL doesn't support full text search against Japanese, Chinese and so on.
      You can use super fast full text search feature against all languages by installing PGroonga into your PostgreSQL.
    '';
    homepage = "https://pgroonga.github.io/";
    license = licenses.postgresql;
    platforms = postgresql.meta.platforms;
    maintainers = with maintainers; [ DerTim1 ];
  };
}
