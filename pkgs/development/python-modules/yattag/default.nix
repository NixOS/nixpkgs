{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "yattag";
  version = "1.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lg+lS+EinZb0MXgTPgsZXAAzkf3Ens22tptzdNtr5BY=";
  };

  meta = with lib; {
    description = "Generate HTML or XML in a pythonic way. Pure python alternative to web template engines. Can fill HTML forms with default values and error messages.";
    license = [ licenses.lgpl21 ];
    homepage = "https://www.yattag.org/";
  };
}
