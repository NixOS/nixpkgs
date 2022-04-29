{ lib, stdenv, fetchFromGitHub, bison, flex }:

stdenv.mkDerivation rec {
  pname = "iouyap";
  version = "0.97";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = pname;
    rev = "v${version}";
    sha256 = "028s9kx67b9x7gwzg0fhc6546diw4n0x4kk1xhl3v7hbsz3wdh6s";
  };

  buildInputs = [ bison flex ];

  installPhase = ''
    install -D -m555 iouyap $out/bin/iouyap;
  '';

  meta = with lib; {
    description = "Bridge IOU to UDP, TAP and Ethernet";
    inherit (src.meta) homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
