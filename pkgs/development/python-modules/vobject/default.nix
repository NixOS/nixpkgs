{ lib, buildPythonPackage, fetchPypi, isPyPy, python, dateutil }:

buildPythonPackage rec {
  version = "0.9.6";
  pname = "vobject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cd9ede4363f83c06ba8d8f1541c736efa5c46f9a431430002b2f84f4f4e674d8";
  };

  disabled = isPyPy;

  propagatedBuildInputs = [ dateutil ];

  checkPhase = "${python.interpreter} tests.py";

  meta = with lib; {
    description = "Module for reading vCard and vCalendar files";
    homepage = http://eventable.github.io/vobject/;
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
