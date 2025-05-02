{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "std-uritemplate";
  version = "0.0.57";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "std_uritemplate";
    inherit version;
    hash = "sha256-9K3HF67BOFYuZSuV2nT8aBWpQiMdlxMUhWuB9DTBuUw=";
  };

  build-system = [ poetry-core ];

  # Module doesn't have unittest, only functional tests
  doCheck = false;

  pythonImportsCheck = [ "stduritemplate" ];

  meta = with lib; {
    description = "Std-uritemplate implementation for Python";
    homepage = "https://github.com/std-uritemplate/std-uritemplate";
    changelog = "https://github.com/std-uritemplate/std-uritemplate/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
