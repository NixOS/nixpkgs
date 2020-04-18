{ fetchFromGitHub, stdenv, cmake, qt4 }:

stdenv.mkDerivation {
  name = "resim";
  src = fetchFromGitHub {
    owner = "itszor";
    repo = "resim";
    rev = "cdc7808ceb7ba4ac00d0d08ca646b58615059150";
    sha256 = "1743lngqxd7ai4k6cd4d1cf9h60z2pnvr2iynfs1zlpcj3w1hx0c";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 ];
  installPhase = ''
    mkdir -pv $out/{lib,bin}
    cp -v libresim/libarmsim.so $out/lib/libarmsim.so
    cp -v vc4emul/vc4emul $out/bin/vc4emul
  '';
}
