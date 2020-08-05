{ stdenv, fetchurl, xorg, pkg-config, gtk2 }:

stdenv.mkDerivation {
  pname = "spnavcfg";
  version = "0.3";
  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = pname;
    rev = "v${version}";
    sha256 = "xxx";
  buildInputs = [ xorg.libX11 pkg-config gtk2 ];
  preConfigure = ''
    substituteInPlace Makefile.in --replace 4775 0775
  '';
}

