{ lib, buildPythonPackage, fetchPypi, isPyPy, python, python-dateutil }:

buildPythonPackage rec {
  version = "0.9.6.1";
  format = "setuptools";
  pname = "vobject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96512aec74b90abb71f6b53898dd7fe47300cc940104c4f79148f0671f790101";
  };

  disabled = isPyPy;

  propagatedBuildInputs = [ python-dateutil ];

  checkPhase = "${python.interpreter} tests.py";

  meta = with lib; {
    description = "Module for reading vCard and vCalendar files";
    homepage = "http://eventable.github.io/vobject/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
