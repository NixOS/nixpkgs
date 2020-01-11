{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1g0zhf09vs8cq0l5lx10dnqpimvg5mzh9k0z12n6nnfsw11cila7";
  };

  meta = with lib; {
    description = "Generate HTML or XML in a pythonic way. Pure python alternative to web template engines. Can fill HTML forms with default values and error messages.";
    license = [ licenses.lgpl21 ];
    homepage = https://www.yattag.org/;
  };
}
