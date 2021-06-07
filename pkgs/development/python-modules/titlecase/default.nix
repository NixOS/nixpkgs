{ buildPythonPackage, lib, nose, fetchPypi, regex }:

buildPythonPackage rec {
  pname = "titlecase";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6b24c4bfce6b05ee55da48901a1aa39eac20f223160b7872dcf1b8182214bec";
  };

  propagatedBuildInputs = [ regex ];

  checkInputs = [ nose ];

  meta = {
    homepage = "https://github.com/ppannuto/python-titlecase";
    description = "Python Port of John Gruber's titlecase.pl";
    license = lib.licenses.mit;
  };
}
