{ stdenv, fetchurl, which, m4
, protobuf, boost, zlib, curl, openssl, icu, jemalloc, libtool
, python2Packages, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "rethinkdb";
  version = "2.3.7";

  src = fetchurl {
    url = "https://download.rethinkdb.com/dist/${pname}-${version}.tgz";
    sha256 = "11zahnwgbl11lvfr0q2z4lixh41007vgjj6vy3qnh5caa7l2anf5";
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
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice bluescreen303 ];
  };
}
