{ stdenv, fetchurl, xorg }:

stdenv.mkDerivation {
  pname = "libspnav";
  version = "0.2.3";
  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = pname;
    rev = "v${version}";
    sha256 = "xxx";
  };
  buildInputs = [ xorg.libX11 ];
}

