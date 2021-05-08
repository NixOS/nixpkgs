{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "imagelol";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "MCRedstoner2004";
    repo = pname;
    rev = "v${version}";
    sha256 = "0978zdrfj41jsqm78afyyd1l64iki9nwjvhd8ynii1b553nn4dmd";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./ImageLOL $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/MCredstoner2004/ImageLOL";
    description = "Simple program to store a file into a PNG image";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = platforms.unix;
  };
}
