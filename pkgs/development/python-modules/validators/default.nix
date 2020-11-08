{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, six
, decorator
, pytestCheckHook
, isort
, flake8
}:

buildPythonPackage rec {
  pname = "validators";
  version = "0.17.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "401cb441dd61bb1a03b10c8a3a884642409e22a2a19e03bbfc4891e0ddbc7268";
  };

  requiredPythonModules = [
    six
    decorator
  ];

  checkInputs = [
    pytestCheckHook
    flake8
    isort
  ];

  disabledTests = lib.optionals isPy27 [ "url" ];

  meta = with lib; {
    description = "Python Data Validation for Humans™";
    homepage = "https://github.com/kvesteri/validators";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
