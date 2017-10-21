{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "shc-${version}";
  version = "3.9.3";
  rev = "${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "neurobin";
    repo = "shc";
    sha256 = "00fqzg4a0f4kp4wr8swhi5zqds3gh3gf7cgi1cipn16av0818xsa";
  };

  meta = with stdenv.lib; {
    homepage = http://neurobin.github.io/shc;
    description = "Shell Script Compiler";
    platforms = stdenv.lib.platforms.linux;
    license = licenses.gpl3;
  };
}
