{
  lib,
  buildPythonPackage,
  fetchPypi,
  pretend,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "verspec";
  version = "0.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-xFBMppeyBWzbS/pxIUYfWg6BgJJVtBwD3aS6gjY3wB4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Import fail
    "test/test_specifiers.py"
  ];

  pythonImportsCheck = [ "verspec" ];

  meta = {
    description = "Flexible version handling";
    homepage = "https://github.com/jimporter/verspec";
    license =
      with lib.licenses;
      AND [
        bsd2
        asl20
      ];
    maintainers = [ ];
  };
})
