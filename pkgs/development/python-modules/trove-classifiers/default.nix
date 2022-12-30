{ lib
, buildPythonPackage
, fetchPypi
, calver
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "trove-classifiers";
  version = "2022.12.22";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/g/j8IWYcWGu4qWoU8fMfN9kUVxZZdV62Wj92Mw7A2I=";
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
