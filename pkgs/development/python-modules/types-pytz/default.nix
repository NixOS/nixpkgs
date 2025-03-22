{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-pytz";
  version = "2025.1.0.20250318";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pytz";
    inherit version;
    hash = "sha256-l+DjUYTG/hTjpQFFEgV/LFe7DGWC1jwc/MSAn4IYBEk=";
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
