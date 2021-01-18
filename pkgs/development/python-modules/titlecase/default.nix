{ buildPythonPackage, lib, nose, fetchPypi, regex }:

buildPythonPackage rec {
  pname = "titlecase";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16e279edf085293bc9c44a68ce959c7d6cd5c653e6b5669a3a3640015cb63eb6";
  };

  propagatedBuildInputs = [ regex ];

  checkInputs = [ nose ];

  meta = {
    homepage = "https://github.com/ppannuto/python-titlecase";
    description = "Python Port of John Gruber's titlecase.pl";
    license = lib.licenses.mit;
  };
}
