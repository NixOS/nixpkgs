{ stdenv, fetchFromGitHub, fetchpatch, qmake, pkgconfig, qtbase, qtsvg, radare2 }:


stdenv.mkDerivation rec {
  name = "radare2-cutter-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "radareorg";
    repo = "cutter";
    rev = "v${version}";
    sha256 = "1z76yz2i9k8mxjk85k2agdj941szdbl2gi66p3dh50878zqavfrr";
  };

  postUnpack = "export sourceRoot=$sourceRoot/src";

  patchFlags = [ "-p2" ];

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
