{ stdenv, fetchurl, which, protobuf, gperftools
, boost, zlib, curl, python, m4, icu, jemalloc }:

stdenv.mkDerivation rec {
  name = "rethinkdb-${version}";
  version = "2.0.3";

  src = fetchurl {
    url = "http://download.rethinkdb.com/dist/${name}.tgz";
    sha256 = "1580h5clkw8kprdb9waaf8al3wa2vj5d2l2m394r91fq45ss23sd";
  };

  preConfigure = ''
    export ALLOW_WARNINGS=1
    patchShebangs .
  '';

  configureFlags = "--lib-path ${gperftools}/lib --lib-path ${jemalloc}/lib";

  buildInputs = [ protobuf boost zlib curl icu jemalloc ];

  patches = if stdenv.isDarwin then [ ./sedDarwin.patch ] else null;

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
