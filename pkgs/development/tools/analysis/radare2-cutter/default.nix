{ stdenv, fetchFromGitHub, fetchpatch, qmake, pkgconfig, qtbase, qtsvg, radare2 }:

stdenv.mkDerivation rec {
  name = "radare2-cutter-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "cutter";
    rev = "v${version}";
    sha256 = "1ph8kvpai7kr7kcqfp0aagvrm098bbh9ygzg5fp8z8y51mwq898g";
  };

  postUnpack = "export sourceRoot=$sourceRoot/src";

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
