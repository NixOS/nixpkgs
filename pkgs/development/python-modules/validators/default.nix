{ lib
, buildPythonPackage
, fetchPypi
, six
, decorator
, pytest
, isort
, flake8
}:

buildPythonPackage rec {
  pname = "validators";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bhla1l8gbks572zp4f254acz23822dz2mp122djxvp328i87b7h";
  };

  propagatedBuildInputs = [
    six
    decorator
  ];

  checkInputs = [
    pytest
    flake8
    isort
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Python Data Validation for Humans™";
    homepage = https://github.com/kvesteri/validators;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
