{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0grf7hskbxfxj60qmd44xiwmr9mzmi09inilvhykw28m0c84s8fp";
  };

  meta = with lib; {
    description = "Generate HTML or XML in a pythonic way. Pure python alternative to web template engines. Can fill HTML forms with default values and error messages.";
    license = [ licenses.lgpl21 ];
    homepage = http://www.yattag.org/;
  };
}
