{ stdenv, fetchgit, autoconf, automake, openssl, libgsf }:

stdenv.mkDerivation rec {

  name = "crackxls-${version}";
  version = "v0.4";

  src = fetchgit {
    url = https://github.com/GavinSmith0123/crackxls2003.git;
    rev = "refs/tags/${version}";
    sha256 = "0q5jl7hcds3f0rhly3iy4fhhbyh9cdrfaw7zdrazzf1wswwhyssz";
  };

  buildInputs = [ openssl libgsf automake autoconf ];

  installPhase =
  ''
    mkdir $out/bin
    cp crackxls2003 $out/bin/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/GavinSmith0123/crackxls2003/;
    description = "Used to break the encryption on old Microsoft Excel and Microsoft Word files";
    platforms = platforms.none;
    license = licenses.gpl3;
  };
}
