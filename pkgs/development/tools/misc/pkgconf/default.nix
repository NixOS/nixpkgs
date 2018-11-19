{ stdenv, fetchgit, automake, autoconf, libtool }:

# with stdenv.lib;

stdenv.mkDerivation rec {
  name = "pkgconf-1.5.4";

  src = fetchgit {
    url = "https://git.dereferenced.org/pkgconf/pkgconf.git";
    rev = "74133eda31bc1ed5947b4a3a854001e320b6c1fe";
    sha256 = "159fxbwm5shz8p95jp28wrjvinlhmp42dy60pqg34psjn41wq1q4";
  };

  buildInputs = [ automake autoconf libtool ];

  preConfigurePhases = ["autogenPhase"];

  autogenPhase = ''
    ./autogen.sh
  '';

  #meta = {
  #  description = "TODO";
  #  homepage = "TODO";
  #  platforms = "TODO";
  #  license = "TODO";
  #};
}
