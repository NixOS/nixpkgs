{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "41c1182f81e69bc53d8763c5bb9d27f54ae05ce581ee4e41c7931cc2f2479262";
  };

  meta = with lib; {
    description = "Generate HTML or XML in a pythonic way. Pure python alternative to web template engines. Can fill HTML forms with default values and error messages.";
    license = [ licenses.lgpl21 ];
    homepage = "https://www.yattag.org/";
  };
}
