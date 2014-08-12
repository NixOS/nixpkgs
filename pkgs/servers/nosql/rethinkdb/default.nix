{ stdenv, fetchurl, which, protobuf, gperftools, boost, zlib, python, m4 }:

stdenv.mkDerivation rec {
  name = "rethinkdb-1.12.4";

  src = fetchurl {
    url = "http://download.rethinkdb.com/dist/${name}.tgz";
    sha256 = "1dq2vbgms016ic2hifclm1m58i4804khkn0lnvz47rkm7i0564if";
  };

  preConfigure = ''
    export ALLOW_WARNINGS=1
    patchShebangs .
  '';

  configureFlags = "--lib-path ${gperftools}/lib";

  buildInputs = [ protobuf zlib boost ];

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
