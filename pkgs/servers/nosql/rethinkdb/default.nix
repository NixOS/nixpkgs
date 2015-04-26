{ stdenv, fetchurl, which, protobuf, gperftools
, boost, zlib, curl, python, m4, icu, jemalloc }:

stdenv.mkDerivation rec {
  name = "rethinkdb-${version}";
  version = "2.0.0-1";

  src = fetchurl {
    url = "http://download.rethinkdb.com/dist/${name}.tgz";
    sha256 = "0fbxs6gmlmgkbfrmi0f4xyr3vqwylr6i7fa4p68y12qy6kv7q9pc";
  };

  preConfigure = ''
    export ALLOW_WARNINGS=1
    patchShebangs .
  '';

  configureFlags = "--lib-path ${gperftools}/lib --lib-path ${jemalloc}/lib";

  buildInputs = [ protobuf boost zlib curl icu jemalloc ];

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
