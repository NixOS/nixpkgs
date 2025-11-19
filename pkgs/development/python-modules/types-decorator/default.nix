{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-decorator";
  version = "5.2.0.20251101";
  pyproject = true;

  src = fetchPypi {
    pname = "types_decorator";
    inherit version;
    hash = "sha256-Eg4r9HkuyKR2U9scs4DHqstoYqeXwUkKkQqswhVIKGw=";
  };

  build-system = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "decorator-stubs" ];

  meta = with lib; {
    description = "Typing stubs for decorator";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
