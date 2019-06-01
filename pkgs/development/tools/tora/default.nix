{ mkDerivation, lib, fetchFromGitHub, cmake, extra-cmake-modules, makeWrapper
, boost, doxygen, openssl, mysql, postgresql, graphviz, loki, qscintilla, qtbase }:

let
  qscintillaLib = (qscintilla.override { withQt5 = true; });

in mkDerivation rec {
  name = "tora-${version}";
  version = "unstable-2019-04-10";

  src = fetchFromGitHub {
    owner  = "tora-tool";
    repo   = "tora";
    rev    = "e907709e14104ec486b51520c8195267bcc5050e";
    sha256 = "14c5lshphixz64kgkxcgp33pg49a8nvdbz03z8l8lldwpkn8ayiq";
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
