{ stdenv
, fetchFromGitHub
, xorg
, pkg-config
, gtk2
}:

stdenv.mkDerivation rec {
  pname = "spnavcfg";
  version = "0.3";
  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ixwxg4qhmx60ik2d0dslkpdl7zmnk2lj08l3srsn8g8fv2rk7pv";
  };
  buildInputs = [ xorg.libX11 pkg-config gtk2 ];
  preConfigure = ''
    substituteInPlace Makefile.in --replace 4775 0775
  '';
}
