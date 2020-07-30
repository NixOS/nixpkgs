{ stdenv, fetchurl, xorg, pkg-config, gtk2 }:

stdenv.mkDerivation {
  pname = "spnavcfg";
  version = "0.3";
  src = fetchurl {
    url = "https://github.com/FreeSpacenav/spnavcfg/releases/download/spnavcfg-0.3/spnavcfg-0.3.tar.gz";
    sha256 = "1msbxb6i01irrc5b5dvbxirwzf415y9cbdh8pz046hmx9s6hp5ac";
  };
  buildInputs = [ xorg.libX11 pkg-config gtk2 ];
  preConfigure = ''
    substituteInPlace Makefile.in --replace 4775 0775
  '';
}


