{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "84.0.0.20260812";
  pyproject = true;

  src = fetchPypi {
    pname = "types_setuptools";
    inherit version;
    hash = "sha256-Cb7cJI67t6IyyUGd/NyjKXBuYb8qpXQ+lCTQJ/HZVrQ=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "setuptools-stubs" ];

  meta = {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
