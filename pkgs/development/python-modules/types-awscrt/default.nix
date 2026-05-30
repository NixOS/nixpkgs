{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-awscrt";
  version = "0.33.0";
  pyproject = true;

  src = fetchPypi {
    pname = "types_awscrt";
    inherit (finalAttrs) version;
    hash = "sha256-gDvH5+L2FyoKvXHfZZM2j4L8IxJ8oV0ofzYOn8vTqXc=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "awscrt-stubs" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Type annotations and code completion for awscrt";
    homepage = "https://github.com/youtype/types-awscrt";
    changelog = "https://github.com/youtype/types-awscrt/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
