{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-deprecated";
  version = "1.2.9.20240106";
  pyproject = true;

  src = fetchPypi {
    pname = "types-Deprecated";
    inherit version;
    hash = "sha256-r+uBnpoD0KV5XxjIj+YgfEjtE8Y56TKBvZ2be7bTQxA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Modules has no tests
  doCheck = false;

  pythonImportsCheck = [
    "deprecated-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for Deprecated";
    homepage = "https://pypi.org/project/types-Deprecated/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
