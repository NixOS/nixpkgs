{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "types-tqdm";
  version = "4.66.0.5";
  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dL1+RpI4wogWMA9yqbcT0CA29rVXc0YWQwrbe350ESw=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # This package does not have tests.
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for tqdm";
    homepage = "https://pypi.org/project/types-tqdm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
