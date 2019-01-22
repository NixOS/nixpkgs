{ stdenv, fetchurl, pkgconfig, postgresql, msgpack, groonga }:

stdenv.mkDerivation rec {
  name = "pgroonga-${version}";
  version = "2.1.7";

  src = fetchurl {
    url = "https://packages.groonga.org/source/pgroonga/${name}.tar.gz";
    sha256 = "1mpns28f5hk528i5x7rkj9jp3qdhxmicmz13aj4lzlwa8yssx9ws";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ postgresql msgpack groonga ];

  makeFlags = [ "HAVE_MSGPACK=1" ];

  installPhase = ''
    mkdir -p $out/bin
    install -D pgroonga.so -t $out/lib/
    install -D ./{pgroonga-*.sql,pgroonga.control} -t $out/share/extension
  '';

  meta = with stdenv.lib; {
    description = "A PostgreSQL extension to use Groonga as the index";
    longDescription = "PGroonga is a PostgreSQL extension to use Groonga as the index. PostgreSQL supports full text search against languages that use only alphabet and digit. It means that PostgreSQL doesn't support full text search against Japanese, Chinese and so on. You can use super fast full text search feature against all languages by installing PGroonga into your PostgreSQL.";
    homepage = https://pgroonga.github.io/;
    license = licenses.postgresql;
    maintainers = with maintainers; [ DerTim1 ];
  };
}
