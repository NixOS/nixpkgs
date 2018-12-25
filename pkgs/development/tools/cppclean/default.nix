{ stdenv, lib, fetchFromGitHub, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  name = "cppclean-unstable-${version}";
  version = "2018-05-12";

  src = fetchFromGitHub {
    owner  = "myint";
    repo   = "cppclean";
    rev    = "e7da41eca5e1fd2bd1dddd6655e50128bb96dc28";
    sha256 = "0pymh6r7y19bwcypfkmgwyixrx36pmz338jd83yrjflsbjlriqm4";
  };

  postUnpack = ''
    patchShebangs .
    '';

  checkPhase = ''
    ./test.bash
    '';

  meta = with stdenv.lib; {
    description = "Finds problems in C++ source that slow development of large code bases";
    homepage    = https://github.com/myint/cppclean;
    license     = licenses.asl20;
    maintainers = with maintainers; [ nthorne ];
    platforms   = platforms.linux;
  };
}
