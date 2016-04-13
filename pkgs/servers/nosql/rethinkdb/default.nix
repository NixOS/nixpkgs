{ stdenv, fetchurl, which, m4, python
, protobuf, boost, zlib, curl, openssl, icu, jemalloc, libtool
}:

stdenv.mkDerivation rec {
  name = "rethinkdb-${version}";
  version = "2.3.0";

  src = fetchurl {
    url = "http://download.rethinkdb.com/dist/${name}.tgz";
    sha256 = "0b787ibnrmziypiw86yx4gpmlj4ima6j6g9hzshbpilxy7lrq1cb";
  };

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/raise.*No Xcode or CLT version detected.*/version = "7.0.0"/' external/v8_3.30.33.16/build/gyp/pylib/gyp/xcode_emulation.py

    # very meta
    substituteInPlace mk/support/pkg/re2.sh --replace "-i '''" "-i"
  '';

  preConfigure = ''
    export ALLOW_WARNINGS=1
    patchShebangs .
  '';

  configureFlags = stdenv.lib.optionals (!stdenv.isDarwin) [
    "--with-jemalloc"
    "--lib-path=${jemalloc}/lib"
  ];

  buildInputs = [ protobuf boost zlib curl openssl icu ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) jemalloc
    ++ stdenv.lib.optional stdenv.isDarwin libtool;

  nativeBuildInputs = [ which m4 python ];

  enableParallelBuilding = true;

  meta = {
    description = "An open-source distributed database built with love";
    longDescription = ''
      RethinkDB is built to store JSON documents, and scale to
      multiple machines with very little effort. It has a pleasant
      query language that supports really useful queries like table
      joins and group by, and is easy to setup and learn.
    '';
    homepage    = http://www.rethinkdb.com;
    license     = stdenv.lib.licenses.agpl3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice bluescreen303 ];
  };
}
