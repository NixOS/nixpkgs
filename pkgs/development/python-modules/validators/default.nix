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
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bfe836a1af37bb266d71ec1e98b530c38ce11bc7fbe0c4c96ef7b1532d019e5";
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
