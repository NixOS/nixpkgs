{ stdenv, openssl, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "pev";
  version = "unstable-2020-05-23";

  src = fetchFromGitHub {
    owner = "merces";
    repo = "pev";
    rev = "beec2b4f09585fea919ed41ce466dee06be0b6bf";
    sha256 = "sha256-HrMbk9YbuqkoBBM7+rfXpqVEnd1rDl2rMePdcfU1WDg=";
    fetchSubmodules = true;
  };

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  makeFlags = [ "prefix=$(out)" ];

  installFlags = [ "prefix=$(out)" ];

  meta = with stdenv.lib; {
    description = "A full-featured, open source, multiplatform command line toolkit to work with PE (Portable Executables) binaries";
    homepage = "https://pev.sourceforge.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jeschli ];
    platforms = platforms.linux;
  };
}
