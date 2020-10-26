{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.14.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5731a31cb7452c0c6930dd1a284e0170b39eee959851a2aceb8d6af4134a5fa8";
  };

  meta = with lib; {
    description = "Generate HTML or XML in a pythonic way. Pure python alternative to web template engines. Can fill HTML forms with default values and error messages.";
    license = [ licenses.lgpl21 ];
    homepage = "https://www.yattag.org/";
  };
}
