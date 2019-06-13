{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "shc-${version}";
  version = "4.0.2";
  rev = "${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "neurobin";
    repo = "shc";
    sha256 = "1vd9dldm6h234awn5fhpgq4lb85ylcawr2p2108332ffy70kvdix";
  };

  meta = with stdenv.lib; {
    homepage = https://neurobin.org/projects/softwares/unix/shc/;
    description = "Shell Script Compiler";
    platforms = stdenv.lib.platforms.linux;
    license = licenses.gpl3;
  };
}
