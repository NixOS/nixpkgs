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
  version = "0.18.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "37cd9a9213278538ad09b5b9f9134266e7c226ab1fede1d500e29e0a8fbb9ea6";
  };

  propagatedBuildInputs = [
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
