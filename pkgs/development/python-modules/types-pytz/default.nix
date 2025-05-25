{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-pytz";
  version = "2025.2.0.20250516";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pytz";
    inherit version;
    hash = "sha256-4SFjBvjA1dptr9ZJLnLrCAyaFmFx+oDdehmQ/Yvnp7M=";
  };

  build-system = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "pytz-stubs" ];

  meta = with lib; {
    description = "Typing stubs for pytz";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
