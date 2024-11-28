{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-deprecated";
  version = "1.2.15.20241117";
  pyproject = true;

  src = fetchPypi {
    pname = "types-Deprecated";
    inherit version;
    hash = "sha256-kkACyLf93sUbpJSXiKcCQRouNjbNmyozq9juEZcB134=";
  };

  nativeBuildInputs = [ setuptools ];

  # Modules has no tests
  doCheck = false;

  pythonImportsCheck = [ "deprecated-stubs" ];

  meta = with lib; {
    description = "Typing stubs for Deprecated";
    homepage = "https://pypi.org/project/types-Deprecated/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
