{ stdenv, fetchFromGitHub, qmake, pkgconfig, qtbase, qtsvg, radare2 }:


stdenv.mkDerivation rec {
  name = "r2-cutter-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "cutter";
    rev = "b331dfd083edbbcbd33de83ce7bba17f4d142fe6";
    sha256 = "0y53fxzxszy785xc7glrqnybnar3560kc3q0ih6nzz4bb7i0ghx1";
  };

  postUnpack = "export sourceRoot=$sourceRoot/src";

  prePatch = ''
    substituteInPlace cutter.pro \
      --replace cutter-small.png cutter_appicon.svg
    substituteInPlace cutter.desktop \
      --replace Icon=cutter Icon=cutter_appicon
  '';

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ qtbase qtsvg radare2 ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A Qt and C++ GUI for radare2 reverse engineering framework";
    homepage = src.meta.homepage;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
