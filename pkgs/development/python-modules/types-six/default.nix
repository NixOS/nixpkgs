{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-six";
  version = "1.17.0.20251009";
  pyproject = true;

  src = fetchPypi {
    pname = "types_six";
    inherit version;
    hash = "sha256-7+AwZOzQ/7D3r+EzmQojmNhJPY0cHMEP89/kdtV7pE8=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "six-stubs"
  ];

  meta = {
    description = "Typing stubs for six";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ YorikSar ];
  };
}
