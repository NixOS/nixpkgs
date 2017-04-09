{ stdenv, lib, fetchFromGitHub, cmake, extra-cmake-modules, makeQtWrapper
, boost, doxygen, openssl, mysql, postgresql, graphviz, loki, qscintilla, qtbase }:

let
  qscintillaLib = (qscintilla.override { withQt5 = true; });

in stdenv.mkDerivation rec {
  name = "tora-${version}";
  version = "3.1";

  src = fetchFromGitHub {
    owner  = "tora-tool";
    repo   = "tora";
    rev    = "v${version}";
    sha256 = "0wninl10bcgiljf6wnhn2rv8kmzryw78x5qvbw8s2zfjlnxjsbn7";
  };

  enableParallelBuilding = true;

  buildInputs = [
    cmake extra-cmake-modules makeQtWrapper
    boost doxygen graphviz loki mysql openssl postgresql qscintillaLib qtbase
  ];

  preConfigure = ''
    sed -i \
      's|defaultGvHome = "/usr/bin"|defaultGvHome = "${lib.getBin graphviz}/bin"|' \
      src/widgets/toglobalsetting.cpp

    sed -i \
      's|/usr/bin/dot|${lib.getBin graphviz}/bin/dot|' \
      extlibs/libermodel/dotgraph.cpp
  '';

  cmakeFlags = [
    "-DWANT_INTERNAL_LOKI=0"
    "-DWANT_INTERNAL_QSCINTILLA=0"
    # cmake/modules/FindQScintilla.cmake looks in qtbase and for the wrong library name
    "-DQSCINTILLA_INCLUDE_DIR=${qscintillaLib}/include"
    "-DQSCINTILLA_LIBRARY=${qscintillaLib}/lib/libqscintilla2.so"
    "-DENABLE_DB2=0"
    "-DENABLE_ORACLE=0"
    "-DENABLE_TERADATA=0"
    "-DQT5_BUILD=1"
    "-Wno-dev"
  ];

  # these libraries are only searched for at runtime so we need to force-link them
  NIX_LDFLAGS = [
    "-lgvc"
    "-lmysqlclient"
    "-lecpg"
    "-lssl"
  ];

  postFixup = ''
    wrapQtProgram $out/bin/tora \
      --prefix PATH : ${lib.getBin graphviz}/bin
  '';

  meta = with stdenv.lib; {
    description = "Tora SQL tool";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
