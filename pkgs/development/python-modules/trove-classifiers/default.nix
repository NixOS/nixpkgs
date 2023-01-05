{ lib
, buildPythonPackage
, fetchPypi
, calver
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "trove-classifiers";
  version = "2022.12.1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8eccd9c075038ef2ec73276e2422d0dbf4d632f9133f029632d0df35374caf77";
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
