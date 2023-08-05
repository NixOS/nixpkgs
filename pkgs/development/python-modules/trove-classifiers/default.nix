{ lib
, buildPythonPackage
, fetchPypi
, calver
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "trove-classifiers";
  version = "2023.7.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-io4Wi1HSD+1gcEODHTdjK7UJGdHICmTg8Tk3RGkaiyI=";
  };

  nativeBuildInputs = [
    calver
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "trove_classifiers" ];

  meta = {
    description = "Canonical source for classifiers on PyPI";
    homepage = "https://github.com/pypa/trove-classifiers";
    changelog = "https://github.com/pypa/trove-classifiers/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
