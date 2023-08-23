{ lib
, stdenv
, fetchurl
, libibmad
, openssl
, zlib
}:

stdenv.mkDerivation rec {
  pname = "mstflint";
  version = "4.25.0-1";

  src = fetchurl {
    url = "https://github.com/Mellanox/mstflint/releases/download/v${version}/mstflint-${version}.tar.gz";
    sha256 = "sha256-nYGiWfr8a3q3+bGUb1ovLrAS8/LnEJf+4inIEllW95s=";
  };

  buildInputs = [
    libibmad
    openssl
    zlib
  ];

  hardeningDisable = [ "format" ];

  dontDisableStatic = true;  # the build fails without this. should probably be reported upstream

  meta = with lib; {
    description = "Open source version of Mellanox Firmware Tools (MFT)";
    homepage = "https://github.com/Mellanox/mstflint";
    license = with licenses; [ gpl2 bsd2 ];
    platforms = platforms.linux;
  };
}
