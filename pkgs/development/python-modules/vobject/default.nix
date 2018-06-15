{ lib, buildPythonPackage, fetchPypi, isPyPy, python, dateutil }:

buildPythonPackage rec {
  version = "0.9.5";
  pname = "vobject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f56cae196303d875682b9648b4bb43ffc769d2f0f800958e0a506af867b1243";
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
