{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-decorator";
  version = "5.2.0.20250324";
  pyproject = true;

  src = fetchPypi {
    pname = "types_decorator";
    inherit version;
    hash = "sha256-j71ysNrcVhduSOUYfedE52/kW8yRolh0uqdWYkEhVdM=";
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
