{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-deprecated";
  version = "1.2.9.20240311";
  pyproject = true;

  src = fetchPypi {
    pname = "types-Deprecated";
    inherit version;
    hash = "sha256-BoDomYmoFCcH3oED8V0YJEWlM8EEf9m36MVFkQHpuQo=";
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
