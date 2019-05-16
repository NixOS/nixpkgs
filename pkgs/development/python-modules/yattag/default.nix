{ lib, stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "94210945c868f696a31812a510c01724d61c9a4d279eb4adf340c0d2a4c0bfd7";
  };

  meta = with lib; {
    description = "Generate HTML or XML in a pythonic way. Pure python alternative to web template engines. Can fill HTML forms with default values and error messages.";
    license = [ licenses.lgpl21 ];
    homepage = http://www.yattag.org/;
  };
}
