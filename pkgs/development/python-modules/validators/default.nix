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
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31e8bb01b48b48940a021b8a9576b840f98fa06b91762ef921d02cb96d38727a";
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
