{stdenv, lib, fetchFromGitHub, xz, xar}:

stdenv.mkDerivation rec {
  pname = "pbzx";
  version = "1.0.2";
  src = fetchFromGitHub {
    owner = "NiklasRosenstein";
    repo = "pbzx";
    rev = "v${version}";
    sha256 = "0bwd7wmnhpz1n5p39mh6asfyccj4cm06hwigslcwbb3pdwmvxc90";
  };
  patches = [ ./stdin.patch ];
  buildInputs = [ xz xar ];
  buildPhase = ''
    ${stdenv.cc.targetPrefix}cc pbzx.c -llzma -lxar -o pbzx
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp pbzx $out/bin
  '';
  meta = with lib; {
    description = "Stream parser of Apple's pbzx compression format";
    platforms = platforms.unix;
    license = licenses.gpl3;
    maintainers = [ maintainers.matthewbauer ];
    mainProgram = "pbzx";
  };
}
