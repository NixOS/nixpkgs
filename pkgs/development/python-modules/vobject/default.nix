{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  python,
  python-dateutil,
}:

buildPythonPackage rec {
  version = "0.9.7";
  format = "setuptools";
  pname = "vobject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q3J7+B3oiYStpcEfBm8eFkmQPT49fskfHOloFyr9UlY=";
  };

  disabled = isPyPy;

  propagatedBuildInputs = [ python-dateutil ];

  checkPhase = "${python.interpreter} tests.py";

  meta = with lib; {
    description = "Module for reading vCard and vCalendar files";
    homepage = "http://eventable.github.io/vobject/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
