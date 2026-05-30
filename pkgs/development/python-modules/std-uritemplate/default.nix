{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "std-uritemplate";
  version = "2.0.10";
  pyproject = true;

  src = fetchPypi {
    pname = "std_uritemplate";
    inherit version;
    hash = "sha256-NQSKMiIXrtl2b9/+WmnwYy9zGVd6SiZSaHYc1P+jIF4=";
  };

  build-system = [ poetry-core ];

  # Module doesn't have unittest, only functional tests
  doCheck = false;

  pythonImportsCheck = [ "stduritemplate" ];

  meta = {
    description = "Std-uritemplate implementation for Python";
    homepage = "https://github.com/std-uritemplate/std-uritemplate";
    changelog = "https://github.com/std-uritemplate/std-uritemplate/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
