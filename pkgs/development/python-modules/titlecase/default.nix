{ buildPythonPackage, lib, nose, fetchPypi, regex }:

buildPythonPackage rec {
  pname = "titlecase";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9a1595ed9b88f3ce4362a7602ee63cf074e10ac80d1256b32ea1ec5ffa265fa0";
  };

  propagatedBuildInputs = [ regex ];

  checkInputs = [ nose ];

  meta = {
    homepage = "https://github.com/ppannuto/python-titlecase";
    description = "Python Port of John Gruber's titlecase.pl";
    license = lib.licenses.mit;
  };
}
