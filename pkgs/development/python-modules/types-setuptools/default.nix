{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-setuptools";
  version = "80.9.0.20250822";
  pyproject = true;

  src = fetchPypi {
    pname = "types_setuptools";
    inherit version;
    hash = "sha256-Bw6ncWlo7GeoTH93aNmVL/JNKLZbZZR5ekZPGzBm+WU=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "setuptools-stubs" ];

  meta = with lib; {
    description = "Typing stubs for setuptools";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
