{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "rcm-1.2.3";

  src = fetchurl {
    url = https://thoughtbot.github.io/rcm/dist/rcm-1.2.3.tar.gz;
    sha256 = "0gwpclbc152jkclj3w83s2snx3dcgljwr75q1z8czl3yar7d8bsh";
  };
 
  meta = {
    description = "Management Suite for Dotfiles";
    homepage = https://github.com/thoughtbot/rcm;
    license = stdenv.lib.licenses.bsd3;
  };
}