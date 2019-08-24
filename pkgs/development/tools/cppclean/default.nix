{ stdenv, fetchFromGitHub, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  pname = "cppclean";
  version = "0.13";

  src = fetchFromGitHub {
    owner  = "myint";
    repo   = "cppclean";
    rev    = "v${version}";
    sha256 = "081bw7kkl7mh3vwyrmdfrk3fgq8k5laacx7hz8fjpchrvdrkqph0";
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
