{ lib, stdenv, fetchFromGitHub, pkg-config, autoconf, automake, openssl, libgsf, gmp }:

stdenv.mkDerivation rec {

  pname = "crackxls";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "GavinSmith0123";
    repo = "crackxls2003";
    rev = "v${version}";
    sha256 = "0q5jl7hcds3f0rhly3iy4fhhbyh9cdrfaw7zdrazzf1wswwhyssz";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ autoconf automake openssl libgsf gmp ];

  installPhase =
  ''
    mkdir -p $out/bin
    cp crackxls2003 $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/GavinSmith0123/crackxls2003/";
    description = "Used to break the encryption on old Microsoft Excel and Microsoft Word files";
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
