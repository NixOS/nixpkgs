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
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea9bf8bf22aa692c205e12830d90b3b93950e5122d22bed9eb2f2fece0bba298";
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
