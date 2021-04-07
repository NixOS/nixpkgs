{ lib, stdenv, fetchFromGitHub, libpcap, cmake }:

stdenv.mkDerivation rec {
  pname = "pcapc";
  version = "1.0.0";

  src = fetchFromGitHub {
    sha256 = "137crs0bb7kh9a8p9g168yj2jrp0h3j3073nwh31jy4nk0g5hlfp";
    rev = "v${version}";
    repo = "pcapc";
    owner = "pfactum";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libpcap ];

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pfactum/pcapc";
    description = "Compile libpcap filter expressions into BPF opcodes";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
