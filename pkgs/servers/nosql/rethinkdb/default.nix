{ stdenv, fetchurl, which, protobuf, gperftools, boost, zlib, curl, python, m4 }:

stdenv.mkDerivation rec {
  name = "rethinkdb-1.15.2";

  src = fetchurl {
    url = "http://download.rethinkdb.com/dist/${name}.tgz";
    sha256 = "1fpx9apqm62i332q2isanpdql8gwwab4qxwzrspqwgcka9zd6gy3";
  };

  preConfigure = ''
    export ALLOW_WARNINGS=1
    patchShebangs .
  '';

  configureFlags = "--lib-path ${gperftools}/lib";

  buildInputs = [ protobuf boost zlib curl ];

  nativeBuildInputs = [ which m4 python ];

  meta = {
    description = "An open-source distributed database built with love";
    longDescription = ''
      RethinkDB is built to store JSON documents, and scale to multiple machines with very little
      effort. It has a pleasant query language that supports really useful queries like table joins
      and group by, and is easy to setup and learn.
    '';
    homepage = http://www.rethinkdb.com;
    license = stdenv.lib.licenses.agpl3;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}
