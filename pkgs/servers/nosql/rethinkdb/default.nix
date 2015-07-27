{ stdenv, fetchurl, which, m4, python
, protobuf, boost, zlib, curl, openssl, icu, jemalloc
}:

stdenv.mkDerivation rec {
  name = "rethinkdb-${version}";
  version = "2.0.4";

  src = fetchurl {
    url = "http://download.rethinkdb.com/dist/${name}.tgz";
    sha256 = "19qhia4lfa8a0rzp2v6lnlxp2lf4z4vqhgfxnicfdnx07q4r847i";
  };

  preConfigure = ''
    export ALLOW_WARNINGS=1
    patchShebangs .
  '';

  configureFlags = [
    "--with-jemalloc"
    "--lib-path=${jemalloc}/lib"
  ];

  buildInputs = [ protobuf boost zlib curl openssl icu jemalloc ];

  nativeBuildInputs = [ which m4 python ];

  enableParallelBuilding = true;

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
