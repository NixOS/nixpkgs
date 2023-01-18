{ lib
, buildPythonPackage
, fetchPypi
, calver
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "trove-classifiers";
  version = "2023.1.12";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-66Rg2DJg/PNkjXyKy/IgQ0T9eF+JD7rstoZKf7nwaS4=";
  };

  nativeBuildInputs = [
    calver
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "trove_classifiers" ];

  meta = {
    description = "Canonical source for classifiers on PyPI";
    homepage = "https://github.com/pypa/trove-classifiers";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
