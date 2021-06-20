{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "imagelol";
  version = "unstable-2021-03-27";

  src = fetchFromGitHub {
    owner = "MCRedstoner2004";
    repo = pname;
    rev = "9be8791554d5090e1eb36af8ecb34fb711480ef1";
    sha256 = "0843aqx42rsh99m23qjp8lwavydh49d113ih1x3b6yy22ax9asnx";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./imagelol $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/MCredstoner2004/ImageLOL";
    description = "Simple program to store a file into a PNG image";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.unix;
  };
}
