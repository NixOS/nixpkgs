{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "shc-${version}";
  version = "4.0.1";
  rev = "${version}";

  src = fetchFromGitHub {
    inherit rev;
    owner = "neurobin";
    repo = "shc";
    sha256 = "03f5hq1wkwfcm6b1q9956zqd05l2am91ij8lxbc8akiwz14dmkw7";
  };

  meta = with stdenv.lib; {
    homepage = https://neurobin.org/projects/softwares/unix/shc/;
    description = "Shell Script Compiler";
    platforms = stdenv.lib.platforms.linux;
    license = licenses.gpl3;
  };
}
