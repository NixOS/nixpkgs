{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "shc";
  version = "4.0.3";
  rev = "${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "neurobin";
    repo = "shc";
    sha256 = "0bfn404plsssa14q89k9l3s5lxq3df0sny5lis4j2w75qrkqx694";
  };

  meta = with stdenv.lib; {
    homepage = https://neurobin.org/projects/softwares/unix/shc/;
    description = "Shell Script Compiler";
    platforms = stdenv.lib.platforms.linux;
    license = licenses.gpl3;
  };
}
