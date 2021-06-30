{ buildPythonPackage, lib, nose, fetchPypi, regex }:

buildPythonPackage rec {
  pname = "titlecase";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d97ee51da37fb57c8753b79efa8edfdf3f10c0060de926efee970081e28d52f";
  };

  propagatedBuildInputs = [ regex ];

  checkInputs = [ nose ];

  meta = {
    homepage = "https://github.com/ppannuto/python-titlecase";
    description = "Python Port of John Gruber's titlecase.pl";
    license = lib.licenses.mit;
  };
}
