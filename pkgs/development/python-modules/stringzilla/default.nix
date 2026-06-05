{
  buildPythonPackage,
  numpy,
  pkgs,
  pytest-repeat,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage {
  inherit (pkgs.stringzilla) pname version src;
  pyproject = true;

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "stringzilla" ];

  nativeCheckInputs = [
    numpy
    pytest-repeat
    pytestCheckHook
  ];

  enabledTestPaths = [ "scripts/test_stringzilla.py" ];

  meta = {
    inherit (pkgs.stringzilla.meta)
      changelog
      description
      homepage
      license
      maintainers
      ;
  };
}
