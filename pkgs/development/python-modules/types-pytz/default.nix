{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-pytz";
  version = "2024.1.0.20240417";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aBDIofaPIf3w9PN0pDJIfHdkWgrAsx3kv0aQzyGtOYE=";
  };

  nativeBuildInputs = [ setuptools ];

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
