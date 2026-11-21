{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "stdio-mgr";
  version = "1.0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    pname = "stdio_mgr";
    inherit (finalAttrs) version;
    hash = "sha256-7WIPxOTNA01Iap3hw4hQf5E7Oh/I4T86BB7fwL4uqoc=";
  };

  build-system = [ setuptools ];

  dependencies = [ attrs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "stdio_mgr" ];

  meta = {
    description = "Context manager for managing stdin, stdout, and stderr";
    homepage = "https://github.com/bskinn/stdio-mgr";
    changelog = "https://github.com/bskinn/stdio-mgr/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b-rodrigues ];
  };
})
