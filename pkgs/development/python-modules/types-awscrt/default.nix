{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "types-awscrt";
  version = "0.20.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "types_awscrt";
    inherit version;
    hash = "sha256-ZImKL0okaPZiM8uMKcX2bekHz4C6HvW7E1mu8vgbtSE=";
  };

  build-system = [ poetry-core ];

  pythonImportsCheck = [ "awscrt-stubs" ];

  meta = with lib; {
    description = "Type annotations and code completion for awscrt";
    homepage = "https://github.com/youtype/types-awscrt";
    changelog = "https://github.com/youtype/types-awscrt/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
