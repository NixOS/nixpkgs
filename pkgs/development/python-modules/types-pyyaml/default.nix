{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-pyyaml";
  version = "6.0.12.20241230";
  pyproject = true;

  src = fetchPypi {
    pname = "types_pyyaml";
    inherit version;
    hash = "sha256-fwdiLb00u5yLJk/oYKF+DvytANULXyfpOYSQnZNjSYw=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "yaml-stubs" ];

  meta = with lib; {
    description = "Typing stubs for PyYAML";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ dnr ];
  };
}
