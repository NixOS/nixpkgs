{ lib, stdenv, fetchurl, which, m4
<<<<<<< HEAD
, protobuf, boost, zlib, curl, openssl, icu, jemalloc, libtool
, python3Packages, makeWrapper
=======
, protobuf, boost170, zlib, curl, openssl, icu, jemalloc, libtool
, python2Packages, makeWrapper
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "rethinkdb";
<<<<<<< HEAD
  version = "2.4.3";

  src = fetchurl {
    url = "https://download.rethinkdb.com/repository/raw/dist/${pname}-${version}.tgz";
    hash = "sha256-w3iMeicPu0nj2kV4e2vlAHY8GQ+wWeObfe+UVPmkZ08=";
  };

  postPatch = ''
    substituteInPlace external/quickjs_*/Makefile \
      --replace "gcc-ar" "${stdenv.cc.targetPrefix}ar" \
      --replace "gcc" "${stdenv.cc.targetPrefix}cc"
=======
  version = "2.4.1";

  src = fetchurl {
    url = "https://download.rethinkdb.com/repository/raw/dist/${pname}-${version}.tgz";
    sha256 = "5f1786c94797a0f8973597796e22545849dc214805cf1962ef76969e0b7d495b";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    sed -i 's/raise.*No Xcode or CLT version detected.*/version = "7.0.0"/' external/v8_3.30.33.16/build/gyp/pylib/gyp/xcode_emulation.py

    # very meta
    substituteInPlace mk/support/pkg/re2.sh --replace "-i '''" "-i"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  preConfigure = ''
    export ALLOW_WARNINGS=1
    patchShebangs .
  '';

  configureFlags = lib.optionals (!stdenv.isDarwin) [
    "--with-jemalloc"
    "--lib-path=${jemalloc}/lib"
  ];

  makeFlags = [ "rethinkdb" ];

<<<<<<< HEAD
  buildInputs = [ protobuf boost zlib curl openssl icu ]
    ++ lib.optional (!stdenv.isDarwin) jemalloc
    ++ lib.optional stdenv.isDarwin libtool;

  nativeBuildInputs = [ which m4 python3Packages.python makeWrapper ];
=======
  buildInputs = [ protobuf boost170 zlib curl openssl icu ]
    ++ lib.optional (!stdenv.isDarwin) jemalloc
    ++ lib.optional stdenv.isDarwin libtool;

  nativeBuildInputs = [ which m4 python2Packages.python makeWrapper ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/rethinkdb \
<<<<<<< HEAD
      --prefix PATH ":" "${python3Packages.rethinkdb}/bin"
=======
      --prefix PATH ":" "${python2Packages.rethinkdb}/bin"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = {
    description = "An open-source distributed database built with love";
    longDescription = ''
      RethinkDB is built to store JSON documents, and scale to
      multiple machines with very little effort. It has a pleasant
      query language that supports really useful queries like table
      joins and group by, and is easy to setup and learn.
    '';
    homepage    = "https://rethinkdb.com";
    license     = lib.licenses.asl20;
<<<<<<< HEAD
    platforms   = lib.platforms.unix;
=======
    platforms   = lib.platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with lib.maintainers; [ thoughtpolice bluescreen303 ];
  };
}
