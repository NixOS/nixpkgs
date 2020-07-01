{ stdenv, fetchurl, which, m4
, protobuf, boost, zlib, curl, openssl, icu, jemalloc, libtool
, python2Packages, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "rethinkdb";
  version = "2.3.6";

  src = fetchurl {
    url = "https://download.rethinkdb.com/dist/${pname}-${version}.tgz";
    sha256 = "0a6wlgqa2flf87jrp4fq4y9aihwyhgwclmss56z03b8hd5k5j8f4";
  };

  patches = [
    (fetchurl {
        url = "https://github.com/rethinkdb/rethinkdb/commit/871bd3705a1f29c4ab07a096d562a4b06231a97c.patch";
        sha256 = "05nagixlwnq3x7441fhll5vs70pxppbsciw8qjqp660bdb5m4jm1";
    })
  ];

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

  buildInputs = [ protobuf boost zlib curl openssl icu makeWrapper ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) jemalloc
    ++ stdenv.lib.optional stdenv.isDarwin libtool;

  nativeBuildInputs = [ which m4 python2Packages.python ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/rethinkdb \
      --prefix PATH ":" "${python2Packages.rethinkdb}/bin"
  '';

  meta = {
    description = "An open-source distributed database built with love";
    longDescription = ''
      RethinkDB is built to store JSON documents, and scale to
      multiple machines with very little effort. It has a pleasant
      query language that supports really useful queries like table
      joins and group by, and is easy to setup and learn.
    '';
    homepage    = "http://www.rethinkdb.com";
    license     = stdenv.lib.licenses.agpl3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice bluescreen303 ];
    broken = true;  # broken with openssl 1.1
  };
}
