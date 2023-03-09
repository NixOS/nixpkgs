{ lib, buildPythonPackage, fetchPypi, numpy }:

buildPythonPackage rec {
  pname = "sgp4";
  version = "2.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YXm4dQRId+lBYzwgr3ci/SMaiNiomvAb8wvWTzPN7O8=";
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
