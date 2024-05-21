{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-urllib3,
  urllib3,
}:

buildPythonPackage rec {
  pname = "types-requests";
  version = "2.31.0.20240406";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RCjfM8VQOUXHSz9C6CsYHobse3JGIEGaKWbi3mBM4aE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    types-urllib3
    urllib3
  ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "requests-stubs" ];

  meta = with lib; {
    description = "Typing stubs for requests";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
