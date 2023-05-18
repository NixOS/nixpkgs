{ mkDerivation, lib, fetchFromGitHub, cmake, extra-cmake-modules, makeWrapper
, boost, doxygen, openssl, libmysqlclient, postgresql, graphviz, loki
, qscintilla, qtbase, qttools }:

mkDerivation {
  pname = "tora";
  version = "3.2.176";

  src = fetchFromGitHub {
    owner  = "tora-tool";
    repo   = "tora";
    rev    = "39bf2837779bf458fc72a9f0e49271152e57829f";
    sha256 = "0fr9b542i8r6shgnz33lc3cz333fnxgmac033yxfrdjfglzk0j2k";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules makeWrapper qttools ];

  buildInputs = [
    boost doxygen graphviz loki libmysqlclient openssl postgresql qscintilla qtbase
  ];

  preConfigure = ''
    substituteInPlace src/widgets/toglobalsetting.cpp \
      --replace 'defaultGvHome = "/usr/bin"' 'defaultGvHome = "${lib.getBin graphviz}/bin"'
    substituteInPlace extlibs/libermodel/dotgraph.cpp \
      --replace /usr/bin/dot ${lib.getBin graphviz}/bin/dot
  '';

  cmakeFlags = [
    "-DWANT_INTERNAL_LOKI=0"
    "-DWANT_INTERNAL_QSCINTILLA=0"
    # cmake/modules/FindQScintilla.cmake looks in qtbase and for the wrong library name
    "-DQSCINTILLA_INCLUDE_DIR=${qscintilla}/include"
    "-DQSCINTILLA_LIBRARY=${qscintilla}/lib/libqscintilla2.so"
    "-DENABLE_DB2=0"
    "-DENABLE_ORACLE=0"
    "-DENABLE_TERADATA=0"
    "-DQT5_BUILD=1"
    "-Wno-dev"
  ];

  # these libraries are only searched for at runtime so we need to force-link them
  NIX_LDFLAGS = "-lgvc -lmysqlclient -lecpg -lssl";

  env.NIX_CFLAGS_COMPILE = "-L${libmysqlclient}/lib/mysql -I${libmysqlclient}/include/mysql";

  qtWrapperArgs = [
    ''--prefix PATH : ${lib.getBin graphviz}/bin''
  ];

  meta = with lib; {
    description = "Tora SQL tool";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
