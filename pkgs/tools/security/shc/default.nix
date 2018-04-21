{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "shc-${version}";
  version = "3.9.6";
  rev = "${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "neurobin";
    repo = "shc";
    sha256 = "07l6m24ivjnvbglxkx9mvarpzc453qrlq5ybkyz7jdilh481aj33";
  };

  meta = with stdenv.lib; {
    homepage = http://neurobin.github.io/shc;
    description = "Shell Script Compiler";
    platforms = stdenv.lib.platforms.linux;
    license = licenses.gpl3;
  };
}
