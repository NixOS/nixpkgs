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
  version = "0.14.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6a0d9502219aee486f1ee12d8a9635e4a56f3dbcfa204b4e0de3a038ae35f34f";
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
    homepage = "https://github.com/kvesteri/validators";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
