{ mkDerivation, lib, fetchFromGitHub, cmake, extra-cmake-modules, makeWrapper
, boost, doxygen, openssl, mysql, postgresql, graphviz, loki, qscintilla, qtbase }:

let
  qscintillaLib = (qscintilla.override { withQt5 = true; });

in mkDerivation rec {
  name = "tora-${version}";
  version = "3.1";

  src = fetchFromGitHub {
    owner  = "tora-tool";
    repo   = "tora";
    rev    = "v${version}";
    sha256 = "0wninl10bcgiljf6wnhn2rv8kmzryw78x5qvbw8s2zfjlnxjsbn7";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules makeWrapper ];
  buildInputs = [
    boost doxygen graphviz loki mysql.connector-c openssl postgresql qscintillaLib qtbase
  ];

  preConfigure = ''
    sed -i \
      's|defaultGvHome = "/usr/bin"|defaultGvHome = "${lib.getBin graphviz}/bin"|' \
      src/widgets/toglobalsetting.cpp

    sed -i \
      's|/usr/bin/dot|${lib.getBin graphviz}/bin/dot|' \
      extlibs/libermodel/dotgraph.cpp
  '';

  cmakeFlags = {
    ENABLE_DB2 = false;
    ENABLE_ORACLE = false;
    ENABLE_TERADATA = false;
    # cmake/modules/FindQScintilla.cmake looks in qtbase and for the wrong library name
    QSCINTILLA_INCLUDE_DIR = "${qscintillaLib}/include";
    QSCINTILLA_LIBRARY = "${qscintillaLib}/lib/libqscintilla2.so";
    QT5_BUILD = true;
    WANT_INTERNAL_LOKI = false;
    WANT_INTERNAL_QSCINTILLA = false;
    extraFlags = [ "-Wno-dev" ];
  };

  # these libraries are only searched for at runtime so we need to force-link them
  NIX_LDFLAGS = [
    "-lgvc"
    "-lmysqlclient"
    "-lecpg"
    "-lssl"
  ];

  NIX_CFLAGS_COMPILE = [ "-L${mysql.connector-c}/lib/mysql" "-I${mysql.connector-c}/include/mysql" ];

  postFixup = ''
    wrapProgram $out/bin/tora \
      --prefix PATH : ${lib.getBin graphviz}/bin
  '';

  meta = with lib; {
    description = "Tora SQL tool";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
