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

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: netmap.o:(.bss+0x20): multiple definition of `sizecheck'; iouyap.o:(.bss+0x20): first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

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
