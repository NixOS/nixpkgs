{ stdenv, fetchurl, xorg }:

stdenv.mkDerivation {
  pname = "spacenavd";
  version = "0.7.1";
  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = pname;
    rev = "v${version}";
    sha256 = "xxx";
  buildInputs = [ xorg.libX11 ];
}

