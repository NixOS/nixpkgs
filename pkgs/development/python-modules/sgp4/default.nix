{ lib, buildPythonPackage, fetchPypi, numpy }:

buildPythonPackage rec {
  pname = "sgp4";
  version = "2.22";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F/Ci6q0tygZbbeJcHOqpQP98+ozGcSDLQRGgDxd7hvk=";
  };

  nativeCheckInputs = [ numpy ];

  pythonImportsCheck = [ "sgp4" ];

  meta = with lib; {
    homepage = "https://github.com/brandon-rhodes/python-sgp4";
    description = "Python version of the SGP4 satellite position library";
    license = licenses.mit;
    maintainers = with maintainers; [ zane ];
  };
}
