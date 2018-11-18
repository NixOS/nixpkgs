{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "shc-${version}";
  version = "4.0.0";
  rev = "${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "neurobin";
    repo = "shc";
    sha256 = "1ghvggrygvs1nxjbmq4pqskfr3mzjhcprql9qfkyhz6ii6si75v8";
  };

  meta = with stdenv.lib; {
    homepage = http://neurobin.github.io/shc;
    description = "Shell Script Compiler";
    platforms = stdenv.lib.platforms.linux;
    license = licenses.gpl3;
  };
}
