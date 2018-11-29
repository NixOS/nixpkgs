{ lib, stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r3pwfygvpkgc0hzxc6z8dl56g6brlh52r0x8kcjhywr1biahqb2";
  };

  meta = with lib; {
    description = "Generate HTML or XML in a pythonic way. Pure python alternative to web template engines. Can fill HTML forms with default values and error messages.";
    license = [ licenses.lgpl21 ];
    homepage = http://www.yattag.org/;
  };
}
