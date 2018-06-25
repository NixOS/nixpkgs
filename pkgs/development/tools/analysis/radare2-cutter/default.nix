{ stdenv, fetchFromGitHub
# nativeBuildInputs
, qmake, pkgconfig
# Qt
, qtbase, qtsvg, qtwebengine
# buildInputs
, radare2
, python3 }:


stdenv.mkDerivation rec {
  name = "radare2-cutter-${version}";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "cutter";
    rev = "v${version}";
    sha256 = "0wsxb6jfpsmgsigmbnh08j99779bsjz02v6aasqcwl6hwjx0mjfk";
  };

  postUnpack = "export sourceRoot=$sourceRoot/src";

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ qtbase qtsvg qtwebengine radare2 python3 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A Qt and C++ GUI for radare2 reverse engineering framework";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
