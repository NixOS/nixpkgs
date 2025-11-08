{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-deprecated";
  version = "1.3.1.20251101";
  pyproject = true;

  src = fetchPypi {
    pname = "types_deprecated";
    inherit version;
    hash = "sha256-8ALSZrcyAfRuxvxxLB8BYGfsbLRDV1Wc21DIawEJUac=";
  };

  build-system = [ setuptools ];

  # Modules has no tests
  doCheck = false;

  pythonImportsCheck = [ "deprecated-stubs" ];

  meta = with lib; {
    description = "Typing stubs for Deprecated";
    homepage = "https://pypi.org/project/types-Deprecated/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
