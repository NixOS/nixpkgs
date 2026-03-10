{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-awscrt";
  version = "0.31.2";
  pyproject = true;

  src = fetchPypi {
    pname = "types_awscrt";
    inherit (finalAttrs) version;
    hash = "sha256-3HlwWs0kCUZWuBBbjXmdfic8jqw3xpE331gM2EvrVPY=";
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
