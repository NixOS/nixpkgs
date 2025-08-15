{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-six";
  version = "1.17.0.20250515";
  pyproject = true;

  src = fetchPypi {
    pname = "types_six";
    inherit version;
    hash = "sha256-9PfwOYy3kwTog5czbmQrFelvvqz1uW12Jdo2awadLRg=";
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
