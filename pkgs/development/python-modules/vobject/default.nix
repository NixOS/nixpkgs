{lib, buildPythonPackage, fetchPypi, isPyPy, dateutil}:

buildPythonPackage rec {
  pname = "vobject";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hqjgf3ay1m5w1c0k00g5yfpdz1zni5qnr5rh9b8fg9hjvhwlmhg";
  };

  disabled = isPyPy;

  propagatedBuildInputs = [ dateutil ];

  checkPhase = "python tests.py";

  meta = {
    description = "Module for reading vCard and vCalendar files";
    homepage = http://eventable.github.io/vobject/;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
