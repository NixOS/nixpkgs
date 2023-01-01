{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, calver
, pytest
}:

buildPythonPackage rec {
  pname = "trove-classifiers";
  version = "2022.12.22";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/g/j8IWYcWGu4qWoU8fMfN9kUVxZZdV62Wj92Mw7A2I=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    calver
  ];

  pythonImportsCheck = [ "trove_classifiers" ];

  meta = with lib; {
    description = "Canonical source for classifiers on PyPI.";
    homepage = "https://pypi.org/project/trove-classifiers/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aacebedo ];
  };
}
